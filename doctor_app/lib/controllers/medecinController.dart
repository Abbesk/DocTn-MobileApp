import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

import '../entities/medecin.dart';
import '../entities/rendezvous.dart';

final storage = FlutterSecureStorage();

class MedController extends GetxController {
  Future<List<Medecin>>? _medecinsFuture;

  Future<List<Medecin>> get medecinsFuture async {
    if (_medecinsFuture == null) {
      _medecinsFuture = fetchMedecins();
    }
    return _medecinsFuture!;
  }

  Future<List<Medecin>> fetchMedecins({String? ville, String? nomPrenom, String? specialite}) async {
    try {
      final token = (await storage.read(key: "jwt_token"))?.replaceAll('"', '');
      final baseUrl = 'http://192.168.122.232:8080/api/v1/medecin/all';

      // Construire l'URL en ajoutant les paramètres si non nuls
      String url = baseUrl;
      if (ville != null || nomPrenom != null || specialite != null) {
        url += '?';
        if (ville != null) url += 'ville=$ville&';
        if (nomPrenom != null) url += 'nomPrenom=$nomPrenom&';
        if (specialite != null) url += 'specialite=$specialite&';
      }

      final encodedUrl = Uri.parse(url);
      final response = await http.get(
        encodedUrl,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Iterable jsonList = json.decode(response.body);
        List<Medecin> medecins =
        jsonList.map((model) => Medecin.fromJson(model)).toList();
        return medecins;
      } else {
        final errorMessage = response.reasonPhrase ?? 'Unknown error';
        print('Failed to fetch medecins. Reason: $errorMessage');
        throw Exception('Failed to fetch medecins. Reason: $errorMessage');
      }
    } catch (e) {
      print('Failed to fetch medecins due to unexpected error: $e');
      throw Exception('Unexpected error occurred while fetching medecins');
    }
  }
  Future<List<String>> fetchAvailableTimeSlots(int doctorId, DateTime date) async {
    try {
      final token = await storage.read(key: "jwt_token"); // Assurez-vous de récupérer correctement le jeton
      final baseUrl = 'http://192.168.122.232:8080/api/v1/rendezvous/$doctorId/disponible/${DateFormat('yyyy-MM-dd').format(date)}';

      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<String> availableTimeSlots = json.decode(response.body).cast<String>();
        return availableTimeSlots;
      } else {
        final errorMessage = response.reasonPhrase ?? 'Unknown error';
        print('Failed to fetch available time slots. Reason: $errorMessage');
        throw Exception('Failed to fetch available time slots. Reason: $errorMessage');
      }
    } catch (e) {
      print('Failed to fetch available time slots due to unexpected error: $e');
      throw Exception('Unexpected error occurred while fetching available time slots');
    }
  }
  Future<void> prendreRendezVous({
    required String date,
    required String heureDebut,
    required String sujet,
    required int idMedecin,
    required int idPatient,
  }) async {
    try {
      final token = (await storage.read(key: "jwt_token"))?.replaceAll('"', '');
      final baseUrl = 'http://192.168.122.232:8080/api/v1/rendezvous';
      final Map<String, dynamic> body = {
        "date": date,
        "heureDebut": heureDebut,
        "sujet": sujet,
        "idMedecin": idMedecin,
        "idPatient": idPatient,
      };
      final encodedUrl = Uri.parse(baseUrl);
      final response = await http.post(
        encodedUrl,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        print('Rendez-vous pris avec succès');
      } else {
        final errorMessage = response.reasonPhrase ?? 'Unknown error';
        print('Failed to prendre rendez-vous. Reason: $errorMessage');
        throw Exception('Failed to prendre rendez-vous. Reason: $errorMessage');
      }
    } catch (e) {
      print('Failed to prendre rendez-vous due to unexpected error: $e');
      throw Exception('Unexpected error occurred while taking rendez-vous');
    }
  }
  Future<List<RendezVous>> getAllRendezVous() async {
    try {
      final token = await storage.read(key: "jwt_token");
      final baseUrl = 'http://192.168.122.232:8080/api/v1/patient/rendezvous';

      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final List<RendezVous> rendezVousList =
        jsonData.map((data) => RendezVous.fromJson(data)).toList();
        return rendezVousList;
      } else {
        final errorMessage = response.reasonPhrase ?? 'Unknown error';
        print('Failed to fetch rendez-vous. Reason: $errorMessage');
        throw Exception('Failed to fetch rendez-vous. Reason: $errorMessage');
      }
    } catch (e) {
      print('Failed to fetch rendez-vous due to unexpected error: $e');
      throw Exception('Unexpected error occurred while fetching rendez-vous');
    }
  }


}
