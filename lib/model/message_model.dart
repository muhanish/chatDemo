class Message {
  final String message;
  final String senderUID;
  final String reciverUID;
  final String? timestamp;

  Message(this.message, this.senderUID, this.reciverUID, {this.timestamp});
}
