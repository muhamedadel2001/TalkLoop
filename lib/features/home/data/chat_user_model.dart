class ChatUserModel {
  late String id;
  late String name;
  late String email;
  late String about;
  late String image;
  late String createdAt;
  late String lastActive;
  late bool isOnline;
  late String pushToken;
  late List friends;

  ChatUserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    name = json['name'] ?? '';
    email = json['email'] ?? '';
    about = json['about'] ?? '';
    image = json['image'] ?? '';
    createdAt = json['createdAt'] ?? '';
    lastActive = json['lastActive'] ?? '';
    isOnline = json['isOnline'] ?? false;
    pushToken = json['pushToken'] ?? '';
    friends = json['friends'] ?? [];
  }

  ChatUserModel(
      {required this.id,
      required this.name,
      required this.email,
      required this.about,
      required this.image,
      required this.createdAt,
      required this.lastActive,
      required this.isOnline,
      required this.pushToken,
      required this.friends});

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['about'] = about;
    data['createdAt'] = createdAt;
    data['pushToken'] = pushToken;
    data['name'] = name;
    data['id'] = id;
    data['isOnline'] = isOnline;
    data['email'] = email;
    data['lastActive'] = lastActive;
    data['friends'] = friends;
    return data;
  }
}
