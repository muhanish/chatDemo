import 'package:flutter_firestore_chat_app/model/user_model.dart';

class Group {
  final List<MyUser> members;

  final String? lastMessage;

  Group(this.members, this.lastMessage);
}
