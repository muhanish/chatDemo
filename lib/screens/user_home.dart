import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firestore_chat_app/firebaseAuth/auth_helper.dart';
import 'package:flutter_firestore_chat_app/firestoreUser/group_db_helper.dart';
import 'package:flutter_firestore_chat_app/firestoreUser/user_db_helper.dart';
import 'package:flutter_firestore_chat_app/screens/chat_screen.dart';
import 'package:flutter_firestore_chat_app/screens/login_screen.dart';
import 'package:flutter_firestore_chat_app/screens/user_profile.dart';
import 'package:provider/provider.dart';

import '../model/user_model.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  // list of all user available in User collection
  List<MyUser?> myUsers = [];

  // only user which have a conversation with current user
  // List<MyUser?> myUsers = [];
  User? currentLoggedInUser;
  MyUser? senderUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentLoggedInUser = FirebaseAuth.instance.currentUser;

    fetchUsers();

    FirebaseFirestore.instance
        .collection(USERCOLLECTION)
        .snapshots()
        .listen((records) {
      context.read<UserProvider>().mapRecords(records);
      fetchUsers();
    });
  }

  fetchUsers() async {
    await context.read<UserProvider>().getAllUsersFromDb();

    setState(() {
      myUsers = Provider.of<UserProvider>(context, listen: false).users;
    });

    getSenderUser();
  }

  getSenderUser() async {
    currentLoggedInUser = FirebaseAuth.instance.currentUser;
    print('currentLoggedInUser from user_home: $currentLoggedInUser');

    MyUser tempSenderUser = await context
        .read<UserProvider>()
        .findMySelfFromDatabase(currentLoggedInUser!);
    //MyUser tempSenderUser = context.read<UserProvider>().user!;
    print('tempSenderUser from user_home: ${tempSenderUser!.email}');
    setState(() {
      senderUser = tempSenderUser;
    });
    print('senderUser from uer_home: ${senderUser!.email}');
  }

  printGroups() async {
    print("----------- Print Groups ------------");
    await context.read<GroupProvider>().getAllGroupsFromDB();
    print("----------- printed Groups ------------");
  }

  @override
  Widget build(BuildContext context) {
    //getByEmail();
    printGroups();

    print(
        "from user_home build, it's currentLoggedInUser: $currentLoggedInUser");

    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
        leadingWidth: 50,
        leading: IconButton(
          icon: const Icon(
            Icons.person,
            size: 30,
          ),
          onPressed: () async {
            MyUser me = MyUser(
                id: 'not available',
                name: 'not available',
                email: 'not available',
                phone: 'not available');

            User? myUser = FirebaseAuth.instance.currentUser;

            if (myUser != null) {
              me = await context
                  .read<UserProvider>()
                  .findMySelfFromDatabase(myUser);
            }
            //go to user profile page with MyUser object
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserProfile(myUser: me),
                ));
          },
          tooltip: 'show profile',
        ),
        actions: [
          IconButton(
              onPressed: () {
                var userId = currentLoggedInUser!.uid;
                var userMail = currentLoggedInUser!.email;
                var show = userMail ?? userId;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(show + ' has successfully signed out.'),
                ));
                context.read<AuthProvider>().signOut();
              },
              icon: Icon(Icons.logout)),
        ],
      ),
      body: showAllUserAtHome(),
    );
  }

  Widget showAllUserAtHome() {
    return ListView.builder(
      itemCount: myUsers.length,
      itemBuilder: (context, index) {
        return myUsers[index]!.email == currentLoggedInUser!.email
            ? const SizedBox(
                height: 0,
              )
            : ListTile(
                onTap: () {
                  print(
                      'from home onTap of Tile: ${myUsers[index]!.id}, ${myUsers[index]!.name} ');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatPage(
                                reciverUser: myUsers[index]!,
                                senderUser: senderUser!,
                              )));
                },
                leading: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey.withOpacity(0.2),
                  child: Icon(Icons.person),
                ),
                title: Text(
                  myUsers[index]!.name,
                  style: TextStyle(fontSize: 18),
                ),
                // title: Text(users[index].name),
                // TODO: it should show last message in chat
                subtitle: Text(myUsers[index]!.email),
              );
      },
    );
  }

  Widget showRecentUser() {
    return ListView.builder(
      itemCount: myUsers.length,
      itemBuilder: (context, index) {
        return myUsers[index]!.email == currentLoggedInUser!.email
            ? const SizedBox(
                height: 0,
              )
            : ListTile(
                onTap: () {
                  print(
                      'from home onTap of Tile: ${myUsers[index]!.id}, ${myUsers[index]!.name} ');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatPage(
                                reciverUser: myUsers[index]!,
                                senderUser: senderUser!,
                              )));
                },
                leading: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey.withOpacity(0.2),
                  child: Icon(Icons.person),
                ),
                title: Text(
                  myUsers[index]!.name,
                  style: TextStyle(fontSize: 18),
                ),
                // title: Text(users[index].name),
                // TODO: it should show last message in chat
                subtitle: Text(myUsers[index]!.email),
              );
      },
    );
  }
}
