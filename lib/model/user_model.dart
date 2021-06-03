class UserDataProfile {
  int id;
  String name;
  String phoneNumber;
  String email;
  String avatar;
  String address;

  UserDataProfile({
    this.id,
    this.avatar,
    this.email,
    this.phoneNumber,
    this.name,
    this.address,
  });

  UserDataProfile.fromMap(Map<String, dynamic> data) {
    name = data["name"];
    phoneNumber = data["phoneNumber"];
    email = data["email"];
    avatar = data["avatar"];
    id = data["id"];
    address = data['address'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phoneNumber,
      'email': email,
      'avatar': avatar,
      'id':id,
      'address': address
    };
  }
}