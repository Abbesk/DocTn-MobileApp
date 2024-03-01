import 'package:doctor_app/screens/LoginScreen.dart';
import 'package:doctor_app/screens/StepForms.dart';
import 'package:doctor_app/screens/ajouterRendezVous.dart';
import 'package:doctor_app/screens/doctorCard.dart';
import 'package:doctor_app/screens/multiple_forms.dart';
import 'package:doctor_app/theme/app_theme.dart';
import 'package:doctor_app/theme/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'controllers/authController.dart';
import 'controllers/medecinController.dart';
import 'notification_controller.dart'; // Assurez-vous d'importer votre classe NotificationController

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(AuthController());
  Get.lazyPut(() => MedController());
  await NotificationController.initialize(); // Appelez la méthode initialize() de NotificationController
  runApp(
      ChangeNotifierProvider(
          create: (_) => ThemeModel(),
          child: Consumer<ThemeModel>(
              builder: (context, ThemeModel themeNotifier, child) {
                return MaterialApp(
                  home: LoginPage(),
                  theme: themeNotifier.isDark ? AppTheme.dark : AppTheme.light,
                  debugShowCheckedModeBanner: false,
                );
              }
          )
      )
  );
}
