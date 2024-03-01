import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../entities/user.dart';



final storage = FlutterSecureStorage();

class AuthController extends GetxController {
  var isLoggedIn = false.obs;


  Future<bool> login(String codeuser, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.122.232:8080/api/v1/auth/authenticate'),
        headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
        },
        body: json.encode({'email': codeuser, 'password': password}),
      );
      if (response.statusCode == 200) {
        // Convertir la réponse JSON en un objet User
        User user = User.fromJson(jsonDecode(response.body));
        print(user);
        // Utiliser les données de l'utilisateur comme vous le souhaitez
        await storage.write(key: 'jwt_token', value: user.token);
        await storage.write(key: 'id_patient', value: user.id.toString());
        isLoggedIn.value = true;
        return true;
      } else {
        // Handle invalid credentials
        Get.snackbar(
          'Error',
          'Invalid email or password',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        isLoggedIn.value = false;
        return false;
      }
    } catch (e) {
      isLoggedIn.value = false;
      return false;
    }
  }

}