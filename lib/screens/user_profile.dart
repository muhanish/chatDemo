import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firestore_chat_app/firebaseAuth/auth_helper.dart';

import 'package:flutter_firestore_chat_app/firestoreUser/user_db_helper.dart';
import 'package:flutter_firestore_chat_app/model/user_model.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  UserProfile({super.key, required this.myUser});
  MyUser myUser;

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  // @override
  // void initState() {
  //   super.initState();

  // }

  @override
  Widget build(BuildContext context) {
    //User? user = Provider.of<AuthProvider>(context, listen: false).user;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
              ),
              Center(
                child: CircleAvatar(
                  child: Icon(
                    Icons.person,
                    size: 50,
                  ),
                  radius: 50,
                ),
              ),
              Divider(),
              SizedBox(
                height: 40,
              ),
              Text(
                widget.myUser != null
                    ? widget.myUser!.name != null
                        ? "User Name: ${widget.myUser!.name!}"
                        : 'No User name'
                    : 'No User',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                widget.myUser != null
                    ? widget.myUser!.phone != null
                        ? "Phone no.:  ${widget.myUser!.phone!}"
                        : 'No User phone'
                    : 'No User',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                widget.myUser != null
                    ? widget.myUser!.email != null
                        ? "Email:  ${widget.myUser!.email!}"
                        : 'No User email'
                    : 'User not available',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
