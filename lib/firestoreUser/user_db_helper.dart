import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_firestore_chat_app/firebaseAuth/auth_helper.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/user_model.dart';

const String USERCOLLECTION = 'Users';
const String nameField = 'name';
const String phoneField = 'phone';
const String emailField = 'email';

class UserProvider extends ChangeNotifier {
  var dbRef = FirebaseFirestore.instance.collection(USERCOLLECTION);

  late final MyUser? _user;
  List<MyUser> _users = [];

  MyUser? get user => _user;

  List<MyUser?> get users => _users;

  addUserToDb(String n, String e, String p) {
    print("in userprovider's addFunction");
    MyUser user = MyUser(id: "id", name: n, email: e, phone: p);

    try {
      dbRef
          .add(user.toJson())
          .then((user) => print('user added: $user'))
          .catchError((error) => print('error occured while adding user!!'));
    } on Exception catch (e) {
      // TODO
      print('Exception occured in addUserToDB');
      print(e.toString());
    }

    notifyListeners();
  }

  Future<MyUser> findMySelfFromDatabase(User myUser) async {
    //1. getAllUser  -> _users
    // logged in user's mail find -> from _users
    MyUser user1 = _users.firstWhere((tempUser) {
      if (tempUser.email == myUser.email) {
        print("${tempUser.email} is matched with ${myUser.email}");
        return true;
      }
      return false;
    });
    print('from findMySelfFromDatabase ${user1.email}');

    return user1;
  }

  getAllUsersFromDb() async {
    var records =
        await FirebaseFirestore.instance.collection(USERCOLLECTION).get();

    mapRecords(records);
  }

  listenToChanges() {
    FirebaseFirestore.instance
        .collection(USERCOLLECTION)
        .snapshots()
        .listen((records) {
      mapRecords(records);
    });
  }

// takes list of docs(records) and save them to list of users
  mapRecords(QuerySnapshot<Map<String, dynamic>> records) {
    var userList = records.docs
        .map(
          (user) => MyUser(
            id: user.id,
            name: user['name'],
            email: user['email'],
            phone: user['phone'],
          ),
        )
        .toList();

    _users = userList;
  }
}
