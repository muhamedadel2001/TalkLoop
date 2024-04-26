class MessagesModel {
  late String fromId;
  late String msg;
  late String read;
  late String sent;
  late String toId;
  late Type type;

  MessagesModel(
      this.fromId, this.msg, this.read, this.sent, this.toId, this.type);
  MessagesModel.fromJson({required Map<String, dynamic> json}) {
    fromId = json['fromId'].toString() ?? '';
    msg = json['msg'].toString() ?? '';
    read = json['read'].toString() ?? '';
    sent = json['sent'].toString() ?? '';
    toId = json['toId'].toString() ?? '';
    type = json['type'].toString() == Type.image.name
        ? Type.image
        : json['type'].toString() == Type.text.name
            ? Type.text
            : Type.voice;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['fromId'] = fromId;
    data['read'] = read;
    data['sent'] = sent;
    data['toId'] = toId;
    data['msg'] = msg;
    data['type'] = type.name;
    return data;
  }
}

enum Type { text, image, voice }
