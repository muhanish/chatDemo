import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../model/user_model.dart';

const String CHATCOLLECTION = 'chats';

class GroupProvider extends ChangeNotifier {
  var dbRef = FirebaseFirestore.instance.collection(CHATCOLLECTION);

  getAllGroupsFromDB() async {
    var records = await FirebaseFirestore.instance
        .collection(CHATCOLLECTION)
        .doc("jJj681JivkmipwVui8q6")
        .collection("RKMkXHF7HGc8I2FAkh24_TJc0AluQKm6ejP9HQfI4")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        print(result.data());
      });
    });

    // print(records);
  }

//   late final MyUser? _group;
//   List<MyUser> _groups = [];

//   MyUser? get user => _group;

//   List<MyUser?> get users => _groups;

//   getAllGroupsFromDb() async {
//     var records =
//         await FirebaseFirestore.instance.collection(USERCOLLECTION).get();

//     mapRecords(records);
//   }

//   listenToChanges() {
//     FirebaseFirestore.instance
//         .collection(USERCOLLECTION)
//         .snapshots()
//         .listen((records) {
//       mapRecords(records);
//     });
//   }

  // takes list of docs(records) and save them to list of users
  // mapRecords(QuerySnapshot<Map<String, dynamic>> records) {
  //   var userList = records.docs
  //       .map(
  //         (user) => MyUser(
  //           id: user.id,
  //           name: user['name'],
  //           email: user['email'],
  //           phone: user['phone'],
  //         ),
  //       )
  //       .toList();

  //   _groups = userList;
  // }
}
