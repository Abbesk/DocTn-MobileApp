class User {
  int? id;
  String? token;
  String? role;
  String? email;
  String? nomPrenom;
  Null? photo;

  User(
      {this.id, this.token, this.role, this.email, this.nomPrenom, this.photo});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    token = json['token'];
    role = json['role'];
    email = json['email'];
    nomPrenom = json['nomPrenom'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['token'] = this.token;
    data['role'] = this.role;
    data['email'] = this.email;
    data['nomPrenom'] = this.nomPrenom;
    data['photo'] = this.photo;
    return data;
  }
}