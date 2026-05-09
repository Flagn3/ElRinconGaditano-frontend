class User {
  int? id;
  String? name;
  String? secondName;
  String? email;
  String? password;
  String? role;
  String? address;
  bool? verified;
  bool? activated;
  bool? deleted;
  int? points;
  String? token;

  User({
    this.id,
    this.name,
    this.secondName,
    this.email,
    this.password,
    this.role,
    this.address,
    this.verified,
    this.activated,
    this.deleted,
    this.points,
    this.token,
  });

  factory User.fromLoginJson(Map<String, dynamic> json) => User(
    id: json['id'],
    email: json['email'],
    role: json['role'],
    token: json['token'],
  );

  factory User.fromRegisterJson(Map<String, dynamic> json) => User(
    id: json['id'],
    email: json['email'],
    name: json['name'],
    secondName: json['secondName'],
  );

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    name: json['name'],
    secondName: json['secondName'],
    email: json['email'],
    role: json['role'],
    address: json['address'],
    verified: json['verified'],
    activated: json['activated'],
    deleted: json['deleted'],
    points: json['points'],
  );
}
