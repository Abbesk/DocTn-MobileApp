class Adresse {
  String? ville;
  String? rue;
  String? batiment;
  String? codePostal;
  String? description;

  Adresse(
      {this.ville, this.rue, this.batiment, this.codePostal, this.description});

  Adresse.fromJson(Map<String, dynamic> json) {
    ville = json['ville'];
    rue = json['rue'];
    batiment = json['batiment'];
    codePostal = json['codePostal'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ville'] = this.ville;
    data['rue'] = this.rue;
    data['batiment'] = this.batiment;
    data['codePostal'] = this.codePostal;
    data['description'] = this.description;
    return data;
  }
}