import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../entities/medecin.dart';

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
      final baseUrl = 'http://localhost:8080/api/v1/medecin/all';

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

}
