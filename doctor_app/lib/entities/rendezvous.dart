class RendezVous {
  int? id;
  String? heureDebut;
  String? heureFin;
  String? date;
  String? nomPrenomMedecin;
  String? specialiteMedecin;
  String? telephoneMedecin;
  String? medecinPhoto;
  Null? ordonnance;
  String? statut;

  RendezVous(
      {this.id,
        this.heureDebut,
        this.heureFin,
        this.date,
        this.nomPrenomMedecin,
        this.specialiteMedecin,
        this.telephoneMedecin,
        this.medecinPhoto,
        this.ordonnance,
        this.statut});

  RendezVous.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    heureDebut = json['heureDebut'];
    heureFin = json['heureFin'];
    date = json['date'];
    nomPrenomMedecin = json['nomPrenomMedecin'];
    specialiteMedecin = json['specialiteMedecin'];
    telephoneMedecin = json['telephoneMedecin'];
    medecinPhoto = json['medecinPhoto'];
    ordonnance = json['ordonnance'];
    statut = json['statut'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['heureDebut'] = this.heureDebut;
    data['heureFin'] = this.heureFin;
    data['date'] = this.date;
    data['nomPrenomMedecin'] = this.nomPrenomMedecin;
    data['specialiteMedecin'] = this.specialiteMedecin;
    data['telephoneMedecin'] = this.telephoneMedecin;
    data['medecinPhoto'] = this.medecinPhoto;
    data['ordonnance'] = this.ordonnance;
    data['statut'] = this.statut;
    return data;
  }
  @override
  String toString() {
    return 'RendezVous{id: $id, heureDebut: $heureDebut, heureFin: $heureFin, date: $date, nomPrenomMedecin: $nomPrenomMedecin, specialiteMedecin: $specialiteMedecin, telephoneMedecin: $telephoneMedecin, medecinPhoto: $medecinPhoto, ordonnance: $ordonnance, statut: $statut}';
  }
}