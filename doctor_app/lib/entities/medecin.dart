import 'adresse.dart';

class Medecin {
  int? id;
  String? nomPrenom;
  String? email;
  Null? cin;
  Null? matriculeFiscal;
  String? telephone;
  String? specialite;
  Adresse? adresse;
  int? tempConsultation;
  String? propos;
  String? photo;
  String? competences;
  bool? active;

  Medecin(
      {this.id,
        this.nomPrenom,
        this.email,
        this.cin,
        this.matriculeFiscal,
        this.telephone,
        this.specialite,
        this.adresse,
        this.tempConsultation,
        this.propos,
        this.photo,
        this.competences,
        this.active});

  Medecin.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nomPrenom = json['nomPrenom'];
    email = json['email'];
    cin = json['cin'];
    matriculeFiscal = json['matriculeFiscal'];
    telephone = json['telephone'];
    specialite = json['specialite'];
    adresse =
    json['adresse'] != null ? new Adresse.fromJson(json['adresse']) : null;
    tempConsultation = json['tempConsultation'];
    propos = json['propos'];
    photo = json['photo'];
    competences = json['competences'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nomPrenom'] = this.nomPrenom;
    data['email'] = this.email;
    data['cin'] = this.cin;
    data['matriculeFiscal'] = this.matriculeFiscal;
    data['telephone'] = this.telephone;
    data['specialite'] = this.specialite;
    if (this.adresse != null) {
      data['adresse'] = this.adresse!.toJson();
    }
    data['tempConsultation'] = this.tempConsultation;
    data['propos'] = this.propos;
    data['photo'] = this.photo;
    data['competences'] = this.competences;
    data['active'] = this.active;
    return data;
  }
}