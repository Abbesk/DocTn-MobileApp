import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'medecin.dart';

class RendezVous {
  int? id;
  //DateTime? date;
  //TimeOfDay? heureDebut;
  //TimeOfDay? heureFin;
  String? status;
  String? sujet;
  //Medecin? medecin;

  RendezVous({
    this.id,
    //this.date,
    //this.heureDebut,
    //this.heureFin,
    this.status,
    this.sujet,
    //this.medecin,
  });

  RendezVous.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    /*try {
      // Essayez de parser la date avec le format 'yyyy-MM-dd'
      date = DateTime.parse(json['date']);
    } catch (e) {
      // En cas d'échec, essayez un autre format de date
      date = DateFormat('yyyy-MM-dd').parse(json['date']);
    }*/
    //heureDebut = TimeOfDay.fromDateTime(DateTime.parse(json['heureDebut']));
    //heureFin = TimeOfDay.fromDateTime(DateTime.parse(json['heureFin']));
    status = json['status'];
    sujet = json['sujet'];
    //medecin = Medecin.fromJson(json['medecin']);
  }



  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    //data['date'] = date!.toIso8601String();
    //data['heureDebut'] = heureDebut;
    //data['heureFin'] = heureFin;
    data['status'] = status;
    data['sujet'] = sujet;
    //data['medecin'] = medecin!.toJson();
    return data;
  }
}
