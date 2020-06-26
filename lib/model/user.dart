class User {
  int id;
  String name;
  String email;

  User({this.id, this.name, this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        email: json["email"] as String,
        name: json["name"] as String,
        id: json["id"] as int);
  }

  Map<String, dynamic> toJson() => {"id": id, "name": name, "email": email};
}
