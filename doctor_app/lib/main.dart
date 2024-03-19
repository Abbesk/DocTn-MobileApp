import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:doctor_app/screens/LoginScreen.dart';
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



// Initialize notifications en utilisant l'icône personnalisée
  await AwesomeNotifications().initialize(
    'doctor_app/assets/images/icone_docteur2.png',
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Channel',
        channelDescription: 'Basic notifications channel',
      )
    ],
  );

  Get.put(AuthController());
  Get.lazyPut(() => MedController());
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
