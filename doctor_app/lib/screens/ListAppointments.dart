import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../controllers/medecinController.dart';
import '../entities/rendezvous.dart';
import '../theme/theme_model.dart';
import 'LoginScreen.dart';
import 'doctorCard.dart';

class ListeRendezVous extends StatefulWidget {
  const ListeRendezVous({Key? key}) : super(key: key);

  @override
  State<ListeRendezVous> createState() => _ListeRendezVousState();
}

class _ListeRendezVousState extends State<ListeRendezVous> {
  final MedController medecinController = Get.find<MedController>();
  late List<RendezVous> rendezVousList = [];
  late List<RendezVous> first_rendezVousList = [];
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    fetchRendezVous();
  }
  void _showRendezVousFilterDialog() {
    // Liste des statuts possibles, y compris l'option "Tous"
    final List<String> statuts = [
      "Tous", // Option par défaut
      "EN_ATTENTE",
      "APPROUVE",
      "REFUSE",
    ];

    // Initialisation de la valeur sélectionnée
    String selectedStatut = "Tous"; // Par défaut

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              "Filtrer les rendez-vous",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Container(
            padding: EdgeInsets.all(20.0),
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedStatut,
                  onChanged: (value) {
                    selectedStatut = value!;
                  },
                  items: statuts.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: "Statut",
                    icon: Icon(Icons.assignment),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Annuler"),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _selectedIndex=1;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                // Appliquer les filtres
                List<RendezVous> filteredRendezVousList = List.from(rendezVousList); // Crée une copie de la liste originale

                if (selectedStatut != "Tous") {
                  filteredRendezVousList = filteredRendezVousList.where((rendezVous) => rendezVous.statut == selectedStatut).toList();
                  setState(() {
                    rendezVousList = filteredRendezVousList;
                    setState(() {
                      _selectedIndex=1;
                    });
                  });
                }
             else
               {
                 setState(() {
                   rendezVousList = first_rendezVousList;

                 });
               }
                // Mettre à jour la liste des rendez-vous


                Navigator.of(context).pop();
              },
              child: Text("Appliquer"),
            ),
          ],
        );
      },
    );
  }


  Future<void> fetchRendezVous() async {
    try {
      List<RendezVous> fetchedRendezVous = await medecinController
          .getAllRendezVous();
      setState(() {
        rendezVousList = fetchedRendezVous;
        first_rendezVousList = fetchedRendezVous;
      });
    } catch (e) {
      // Gérer les erreurs
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erreur'),
            content: Text(
                'Impossible de récupérer les rendez-vous. Veuillez réessayer plus tard.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  print('');
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
  Color _getColorForStatut(String? statut) {
    switch (statut) {
      case 'APPROUVE':
        return Colors.green;
      case 'REFUSE':
        return Colors.red;
      case 'EN_ATTENTE':
        return Colors.yellow;
      default:
        return Colors.black; // Couleur par défaut si le statut est inconnu
    }
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
              return Row(
                children: [
                  IconButton(
                    icon: Icon(
                      themeNotifier.isDark ? Icons.nightlight_round : Icons.wb_sunny,
                      color: themeNotifier.isDark ? Colors.white : Colors.black,
                    ),
                    onPressed: () {
                      themeNotifier.isDark = !themeNotifier.isDark;
                    },
                  ),

                ],
              );
            },
          ),

        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: rendezVousList.length,
              itemBuilder: (BuildContext context, int index) {
                final rendezVous = rendezVousList[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Container(
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          // Image du médecin
                          Container(
                            height: 130,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(rendezVous.medecinPhoto ?? ''),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5),
                              Text(
                                rendezVous.statut ?? '',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: _getColorForStatut(rendezVous.statut),
                                ),
                              ),


                                SizedBox(height: 20), // Ajustement de l'espace
                                // Affichage du nom et de la spécialité du médecin avec des icônes
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.person, color: Colors.black),
                                        SizedBox(width: 5),
                                        Text(
                                          rendezVous.nomPrenomMedecin ?? '',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Icon(Icons.local_hospital, color: Colors.black),
                                        SizedBox(width: 5),
                                        Text(
                                          rendezVous.specialiteMedecin ?? '',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10), // Ajustement de l'espace
                                // Affichage de la date, de l'heure de début et de la durée de la consultation avec des icônes
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.watch, color: Colors.black),
                                        SizedBox(width: 5),
                                        Text(
                                          rendezVous.heureDebut?.substring(0, 5) ?? '', // Extrait l'heure sans les secondes
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Icon(Icons.date_range, color: Colors.black),
                                        SizedBox(width: 5),
                                        Text(
                                          rendezVous.date ?? '',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Icon(Icons.access_time, color: Colors.black),
                                        SizedBox(width: 5),
                                        Text(
                                          '30 min', // Durée de la consultation, à remplacer par la valeur réelle
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
  bottomNavigationBar: Container(
    color: Colors.black,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
      child: GNav(
        backgroundColor: Colors.black,
        color: Colors.white,
        activeColor: Colors.white,
        tabBackgroundColor: Colors.grey.shade800,
        padding: EdgeInsets.all(16),
        gap: 8,
        tabs: [
          GButton(
            icon: Icons.home,
            text: 'Home',
          ),
          GButton(
            icon: Icons.list,
            text: 'Mes rendez-vous',
          ),
          GButton(
            icon: Icons.filter_alt,
            text: 'Filtre',
          ),
        ],
        selectedIndex: _selectedIndex,
        onTabChange: (index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 2) {
            _showRendezVousFilterDialog();

          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ListeRendezVous()),
            );
          } else if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DoctorCard()),
            );
          }
        },
      ),
    ),
  ),
    );
  }
}

  // Fonction pour afficher le filtre

