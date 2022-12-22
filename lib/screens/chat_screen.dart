import 'package:bubble/bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firestore_chat_app/chat/chat_helper.dart';
import 'package:flutter_firestore_chat_app/firebaseAuth/auth_helper.dart';
import 'package:flutter_firestore_chat_app/model/user_model.dart';
import 'package:flutter_firestore_chat_app/screens/user_profile.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../firestoreUser/user_db_helper.dart';

class ChatPage extends StatefulWidget {
  ChatPage({super.key, required this.reciverUser, required this.senderUser});
  MyUser reciverUser;
  MyUser senderUser;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  var chatController = TextEditingController();
  User? currentLoggedInUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: TextButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      UserProfile(myUser: widget.reciverUser)));
        },
        child: Text(
          widget.reciverUser!.name != null
              ? widget.reciverUser!.name!
              : 'No User name',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      )),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              Expanded(flex: 10, child: chatModule(widget.senderUser)),
              Expanded(flex: 1, child: bottomBar())
            ],
          ),
        ),
      ),
    );
  }

  chatModule(MyUser senderUser) {
    String convoUID = senderUser.id.hashCode <= widget.reciverUser.id.hashCode
        ? senderUser.id + '_' + widget.reciverUser.id
        : widget.reciverUser.id + '_' + senderUser.id;
    print(convoUID);
    // return Container();
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .doc("jJj681JivkmipwVui8q6")
          .collection(convoUID)
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          var listMessage = snapshot.data!;
          print('messages: ');
          print(listMessage.docs);
          // listMessage.docs.forEach((message) {
          //   print(message.data());
          // });
          //print("doc snapshots: ${listMessage.docs.first}");

          return ListView.builder(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
            padding: EdgeInsets.all(10.0),
            itemBuilder: (context, index) {
              Map<String, dynamic> mss = snapshot.data!.docs[index].data();
              print(mss);
              return buildChatBubble(index, mss);
            },
            itemCount: snapshot.data!.docs.length,
            reverse: true,
          );
        }
      },
    );
  }

  Widget buildChatBubble(index, messageMap) {
    // messageMap -> {senderUid: tGfW132Vp4ShDA68J5S3BjYBEo32, reciverUid: xnQAUBYGvxoQCqS9zr6S,time: 1671515252659 , message: hi to muhanish from test47 6}
    return buildItem(messageMap);

    // return ListTile(
    //   title: Text('${messageMap['message']}'),
    // );
  }

  Widget buildItem(messageMap) {
    // if (!document['read'] && document['idTo'] == uid) {
    //   Database.updateMessageRead(document, convoID);
    // }

    var dt =
        (DateTime.fromMillisecondsSinceEpoch(int.parse(messageMap['time'])))
            .toString();
    // dt -> 1671515252659 as string
    DateTime dateTime = DateTime.parse(dt).toLocal();
    // dateTime -> 2022-12-20 11:17:32.659

    String messageTime = DateFormat.jm().format(dateTime).toString();
    // newDM -> 11:14 AM

    if (messageMap['senderUid'] == widget.senderUser.id) {
      // Right (my message)

      return Row(
        children: <Widget>[
          // Text
          Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              child: Bubble(
                color: Colors.green,
                elevation: 1,
                padding: const BubbleEdges.all(10.0),
                nip: BubbleNip.rightBottom,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(messageMap['message'],
                        style: TextStyle(
                          color: Colors.white,
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(messageTime ?? '',
                            style: TextStyle(color: Colors.white, fontSize: 12))
                      ],
                    ),
                  ],
                ),
              ),
              width: 200)
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      // Left (peer message)
      return Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Column(
          children: <Widget>[
            Row(children: <Widget>[
              Container(
                child: Bubble(
                  color: Colors.blue[600],
                  elevation: 1,
                  padding: const BubbleEdges.all(10.0),
                  nip: BubbleNip.leftTop,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(messageMap['message'],
                          style: TextStyle(
                            color: Colors.white,
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(messageTime ?? '',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12))
                        ],
                      ),
                    ],
                  ),
                ),
                width: 200.0,
                margin: const EdgeInsets.only(left: 10.0),
              )
            ])
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      );
    }
  }

  Widget bottomBar() {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Row(
        children: [
          Expanded(
              child: TextFormField(
            controller: chatController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please Enter something';
              }
              return null;
            },
          )),
          IconButton(
              onPressed: () async {
                //User? user = FirebaseAuth.instance.currentUser;
                String? message;
                if (chatController.text.isNotEmpty) {
                  setState(() {
                    message = chatController.text.trim();
                  });
                  await Provider.of<ChatProvider>(context, listen: false)
                      .addChatToDb(widget.senderUser.id, widget.reciverUser.id,
                          message!);
                  chatController.text = '';
                }
              },
              icon: Icon(
                Icons.send,
                color: Colors.blue,
                size: 30,
              )),
        ],
      ),
    );
  }
}
