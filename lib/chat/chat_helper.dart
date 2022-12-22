import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_firestore_chat_app/model/message_model.dart';

const String CHATCOLLECTION = 'chats';
const String fieldSenderUID = 'senderUid';
const String fieldReciverUID = 'reciverUid';
const String fieldMessage = 'message';
const String fieldTimeStamp = 'time';

class ChatProvider extends ChangeNotifier {
  /// Database reference for chats
  var dbRef = FirebaseFirestore.instance.collection(CHATCOLLECTION);
  late String rootDocInChat;
  bool isFirstChat = true;

  // send message to Reciver From Sender UID
  addChatToDb(String senUid, String recUid, String mess) async {
    await dbRef.get().then((value) {
      value.docs.forEach((element) {
        print(element.id);
        rootDocInChat = element.id;
      });
    });
    //Message myMessage = Message(mess, senUid, recUid);
    String convoUID = senUid.hashCode <= recUid.hashCode
        ? senUid + '_' + recUid
        : recUid + '_' + senUid;

    print(
        "convoUID: $convoUID, sender: $senUid, sendHash: ${senUid.hashCode}, reciver: $recUid, reciHash: ${recUid.hashCode}, message: $mess");

    FirebaseFirestore.instance
        .collection(CHATCOLLECTION)
        .doc(rootDocInChat)
        .collection(convoUID)
        .add({
      fieldSenderUID: senUid,
      fieldReciverUID: recUid,
      fieldMessage: mess,
      fieldTimeStamp: DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }

  // get all the chats for Current Sender and Reciver UID
  getChats() {}
}
