class UserDataProfile {
  int id;
  String name;
  String phoneNumber;
  String email;
  String avatar;

  UserDataProfile.fromMap(Map<String, dynamic> data) {
    name = data["name"];
    phoneNumber = data["phoneNumber"];
    email = data["email"];
    avatar = data["avatar"];
    id = data["id"];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phoneNumber,
      'email': email,
      'avatar': avatar,
      'id':id
    };
  }
}