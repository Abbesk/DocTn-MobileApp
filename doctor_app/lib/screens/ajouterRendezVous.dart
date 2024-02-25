import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

import '../theme/theme_model.dart';
import 'LoginScreen.dart';

class AddAppointmentPage extends StatefulWidget {
  @override
  _AddAppointmentPageState createState() => _AddAppointmentPageState();
}

class _AddAppointmentPageState extends State<AddAppointmentPage> {
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late String _selectedDoctor;
  late bool _isUrgent = false;
  late TextEditingController _remarksController; // Ajout du contrôleur pour les remarques
  bool isFinished=false ;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
    _selectedDoctor = 'Dr. John Doe'; // Médecin par défaut
    _remarksController = TextEditingController(); // Initialisation du contrôleur
  }

  @override
  void dispose() {
    _remarksController.dispose(); // Libération des ressources du contrôleur
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate)
      setState(() {
        _selectedDate = pickedDate;
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (pickedTime != null && pickedTime != _selectedTime)
      setState(() {
        _selectedTime = pickedTime;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DoctorApp'),
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.warning,
                  animType: AnimType.bottomSlide,
                  title: 'Confirmation de déconnexion',
                  desc: 'Voulez-vous vraiment se déconnecter ?',
                  btnCancelOnPress: () {},
                  btnOkOnPress: () {
                    //Se deconnecter avec auth logout
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginPage()),
                    );
                  },
                )..show();
              }
          ),
          Consumer<ThemeModel>(
            builder: (context, themeNotifier, child) {
              return IconButton(

                icon: Icon(themeNotifier.isDark ? Icons.nightlight_round : Icons.wb_sunny,
                  color: themeNotifier.isDark ? Colors.white : Colors.black,
                ),
                onPressed: () {
                  themeNotifier.isDark = !themeNotifier.isDark;
                },
              );
            },
          ),

        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Champ de texte pour le nom du patient avec une icône
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Nom du patient',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 20),
            // Champ de texte pour l'adresse du médecin avec une icône
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Adresse du médecin',
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            SizedBox(height: 20),
            // Champ de texte pour choisir la date et l'heure du rendez-vous
            ElevatedButton.icon(
              onPressed: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );

                // Ajouter ici la logique pour traiter la date sélectionnée si nécessaire
                if (pickedDate != null) {
                  print('Date sélectionnée: $pickedDate');
                }
              },
              icon: Icon(Icons.calendar_today), // Icône pour afficher le calendrier
              label: Text('Sélectionner  l\'horaire '),
            ),

            SizedBox(height: 20),
            // Bouton pour ajouter des pièces jointes avec une icône
            ElevatedButton.icon(
              onPressed: () {
                // Logique pour ajouter des pièces jointes
              },
              icon: Icon(Icons.attach_file),
              label: Text('Ajouter des pièces jointes'),
            ),
            SizedBox(height: 20),
            // Champ de texte pour les remarques avec une icône
            TextFormField(
              controller: _remarksController,
              decoration: InputDecoration(
                labelText: 'Remarques',
                prefixIcon: Icon(Icons.comment),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: _isUrgent,
                  onChanged: (value) {
                    setState(() {
                      _isUrgent = value ?? false;
                    });
                  },
                ),
                Text('Urgent'),
              ],
            ),
            Spacer(),
            // Bouton pour enregistrer le rendez-vous
            SwipeableButtonView(
              buttonText: "Planifier le rendez-vous",
              buttonWidget: Icon(
                Icons.calendar_today,
                color: Colors.white,
              ),
              activeColor: Colors.lightGreen,
              isFinished: isFinished,
              onWaitingProcess: () {
                // Action pendant que l'utilisateur attend
                // Par exemple, vous pouvez afficher un indicateur de chargement
                // ou exécuter une autre logique pour informer l'utilisateur qu'une action est en cours.
                Future.delayed(Duration(seconds: 2), () {
                  setState(() {
                    isFinished = true;
                  });
                });
              },
              onFinish: () async {
                // Naviguer vers la page de connexion lorsque le bouton est complètement glissé
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );

                // Après le retour de la page de connexion, vous pouvez exécuter du code supplémentaire si nécessaire
              },

            ),

          ],
        ),
      ),

    );
  }
}
