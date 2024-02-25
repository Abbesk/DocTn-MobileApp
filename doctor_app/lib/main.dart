import 'package:doctor_app/screens/LoginScreen.dart';
import 'package:doctor_app/screens/ajouterRendezVous.dart';
import 'package:doctor_app/screens/doctorCard.dart';
import 'package:doctor_app/theme/app_theme.dart';
import 'package:doctor_app/theme/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'controllers/authController.dart';
import 'controllers/medecinController.dart';


void main() {
  Get.put(AuthController());
  Get.lazyPut(() => MedController());
  runApp(
      ChangeNotifierProvider(
          create: (_) => ThemeModel(),
          child: Consumer<ThemeModel>(
              builder: (context, ThemeModel themeNotifier, child) {
                return MaterialApp(

                  home: AddAppointmentPage(),
                  theme: themeNotifier.isDark ? AppTheme.dark : AppTheme.light,
                  debugShowCheckedModeBanner: false,
                );
              }
          )
      )
  );
}