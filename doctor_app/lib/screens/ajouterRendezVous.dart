import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:table_calendar/table_calendar.dart';
import '../entities/medecin.dart';
import '../notification_controller.dart';
import '../theme/theme_model.dart';
import 'LoginScreen.dart';
import 'animation_page.dart';
import '../controllers/medecinController.dart';

class AddAppointmentPage extends StatefulWidget {
  final Medecin selectedDoctor;

  AddAppointmentPage({required this.selectedDoctor});

  @override
  _AddAppointmentPageState createState() => _AddAppointmentPageState();
}
class _AddAppointmentPageState extends State<AddAppointmentPage> {
  Medecin? selectedDoctor;
  final MedController medecinController = Get.find<MedController>();
  late String _selectedDoctor;
  late bool _pushed =false;
  late bool _isUrgent = false;
  late TextEditingController _remarksController;
  int _currentStep = 0;
  bool isFinished = false;
  DateTime _selectedDate = DateTime.now();
  String? _selectedTimeSlot; // Ajouter la variable pour stocker le créneau horaire sélectionné
  Map<DateTime, List<dynamic>> _events = {};
  List<String>? _availableTimeSlots;
  Future<void> _fetchAvailableTimeSlots(int doctorId, DateTime date) async {
    try {
      final List<String> availableTimeSlots = await medecinController.fetchAvailableTimeSlots(doctorId, date);
      setState(() {
        _events[date] = availableTimeSlots;
        _availableTimeSlots= availableTimeSlots;
      });
    } catch (e) {
      print('Error fetching available time slots: $e');
    }
  }
  @override
  void initState() {
    super.initState();
    selectedDoctor = widget.selectedDoctor; // Assign value from the constructor to the local variable
    _pushed= false ;
    _selectedDoctor = selectedDoctor?.nomPrenom ?? 'Dr. John Doe'; // Use the selected doctor's name or default to 'Dr. John Doe'
    _remarksController = TextEditingController();
  }
  @override
  void dispose() {
    _remarksController.dispose();
    super.dispose();
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
              // Handle logout
            },
          ),
          Consumer<ThemeModel>(
            builder: (context, themeNotifier, child) {
              return IconButton(
                icon: Icon(
                  themeNotifier.isDark
                      ? Icons.nightlight_round
                      : Icons.wb_sunny,
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
      body: Column(
        children: [
          Expanded(
            child: Stepper(
              currentStep: _currentStep,
              onStepTapped: (int newIndex) {
                setState(() {
                  _currentStep = newIndex;
                });
              },
              onStepContinue: () {
                setState(() {
                  if (_currentStep < 3) {
                    _currentStep += 1;
                  }
                });
              },
              onStepCancel: () {
                setState(() {
                  if (_currentStep > 0) {
                    _currentStep -= 1;
                  }
                });
              },
              steps: [
                Step(
                  title: Text('Médecin Info'),
                  content: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: selectedDoctor?.nomPrenom,
                          prefixIcon: Icon(Icons.person),
                        ),
                        enabled: false, // Rendre le champ de texte non modifiable
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: selectedDoctor?.specialite,
                          prefixIcon: Icon(Icons.local_hospital),
                        ),
                        enabled: false, // Rendre le champ de texte non modifiable
                      ),
                    ],
                  ),
                ),
                Step(
                  title: Text('Date & Time'),
                  content: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _selectedDate = pickedDate;
                              _pushed=true;
                              _fetchAvailableTimeSlots(selectedDoctor!.id!, pickedDate); // Remplacez `doctorId` par l'ID réel du médecin
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.calendar_today), // Icône de calendrier
                            SizedBox(width: 8), // Espacement entre l'icône et le texte
                            Text('Select Date'), // Texte du bouton
                          ],
                        ),
                      ),
                      if (_selectedDate != null  && _pushed==true)
                        Row(
                          children: [
                            Icon(Icons.event), // Icône de calendrier
                            SizedBox(width: 8), // Espacement entre l'icône et le texte
                            Text('Selected Date: ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}'), // Afficher la date sélectionnée
                          ],
                        ),
                      if (_availableTimeSlots != null && _availableTimeSlots!.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            Text(
                              'Available Time Slots:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Wrap(
                              spacing: 8.0,
                              runSpacing: 4.0,
                              children: _availableTimeSlots!.map((timeSlot) {
                                final formattedTimeSlot = timeSlot.substring(0, 5); // Supprimer les secondes et formater au format HH:mm
                                return FilterChip(
                                  label: Text(formattedTimeSlot),
                                  selected: _selectedTimeSlot == timeSlot,
                                  onSelected: (isSelected) {
                                    setState(() {
                                      _selectedTimeSlot = isSelected ? timeSlot : null;
                                    });
                                  },
                                  backgroundColor: _selectedTimeSlot == timeSlot ? Colors.green.withOpacity(0.3) : null, // Mettre en surbrillance le créneau sélectionné
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),


                Step(
                  title: Text('Remarks'),
                  content: Column(
                    children: [
                      TextFormField(
                        controller: _remarksController,
                        decoration: InputDecoration(
                          labelText: 'Remarques',
                          prefixIcon: Icon(Icons.comment),
                        ),
                      ),
                    ],
                  ),
                ),
                Step(
                  title: Text('Urgent?'),
                  content: Column(
                    children: [
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
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20), // Marge à gauche et à droite
            child: Container(
              margin: EdgeInsets.only(bottom: 20),
              child: SizedBox(
                height: 50, // Hauteur fixe pour le bouton
                child: SwipeableButtonView(
                  buttonText: _selectedTimeSlot == null ? "Sélectionner l'heure" : "Valider",
                  buttonWidget: _selectedTimeSlot == null
                      ? Icon(Icons.close, color: Colors.white)
                      : Icon(Icons.check, color: Colors.white),
                  activeColor: _selectedTimeSlot == null ? Colors.red : Colors.purple,
                  isFinished: isFinished,
                  onWaitingProcess: () {
                    if (_selectedTimeSlot != null) {
                      Future.delayed(Duration(seconds: 1), () {
                        setState(() {
                          isFinished = true;
                        });
                      });
                    }
                    if (_selectedTimeSlot == null) {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.warning,
                        animType: AnimType.topSlide,
                        title: 'Attention',
                        desc: 'Veuillez choisir un créneau avant de valider la prise de rendez-vous.',
                        btnCancelOnPress: () {},
                        btnOkOnPress: () {
                          setState(() {
                            isFinished = false;
                          });
                        },
                      )..show();
                    }
                  },
                  onFinish: () async {
                    if (_selectedTimeSlot != null) {
                      final String animationUrl = 'https://lottie.host/75f3c1bd-3ec8-4b3b-8843-eee26f4b2631/ux35ssq7Uh.json';

                      // Naviguer vers la page de l'animation avec l'URL de l'animation lorsque le bouton est complètement glissé
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AnimationPage(animationUrl: animationUrl)),
                      );

                      // Envoyer une notification ici
                      await NotificationController.initialize(); // Assurez-vous que votre NotificationController est importé
                      // Ajoutez votre logique pour envoyer une notification
                      // Par exemple :
                      await AwesomeNotifications().createNotification(
                        content: NotificationContent(
                          id: 10,
                          channelKey: 'alerts',
                          title: 'Rendez-vous confirmé',
                          body: 'Votre rendez-vous avec ${selectedDoctor?.nomPrenom} le ${DateFormat('dd/MM/yyyy').format(_selectedDate)} à ${_selectedTimeSlot} a été confirmé.',
                        ),
                      );

                      try {
                        // Récupérer l'ID du patient à partir du stockage sécurisé
                        final idPatientString = await storage.read(key: 'id_patient');
                        print("L'ID du patient est : $idPatientString");
                        if (idPatientString == null) {
                          throw Exception('ID du patient non trouvé');
                        }
                        final idPatient = int.parse(idPatientString);

                        final selectedDateFormatted = DateFormat('dd/MM/yyyy').format(_selectedDate);
                        print("Date sélectionnée : $selectedDateFormatted");

                        // Formater le créneau horaire sélectionné au format "HH:mm"
                        final selectedTimeSlotFormatted = DateFormat('HH:mm').format(DateFormat('HH:mm:ss').parse(_selectedTimeSlot!));
                        print("Heure de début sélectionnée : $selectedTimeSlotFormatted");

                        print("ID du médecin : ${selectedDoctor!.id}");
                        print("ID du patient : $idPatient");

                        await medecinController.prendreRendezVous(
                          date: selectedDateFormatted,
                          heureDebut: selectedTimeSlotFormatted,
                          sujet: 'Checkup',
                          idMedecin: selectedDoctor!.id!,
                          idPatient: idPatient, // Utiliser l'ID récupéré du patient
                        );
                        print('Rendez-vous pris avec succès');
                      } catch (e) {
                        print('Erreur lors de la prise de rendez-vous: $e');
                        // Gérer l'erreur
                      }


                    }
                  },


                ),
              ),
            ),
          ),


        ],
      ),
    );
  }
}
