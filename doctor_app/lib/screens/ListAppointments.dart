import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/medecinController.dart';
import '../entities/rendezvous.dart';
import 'doctorCard.dart';

class ListeRendezVous extends StatefulWidget {
  const ListeRendezVous({Key? key}) : super(key: key);

  @override
  State<ListeRendezVous> createState() => _ListeRendezVousState();
}

class _ListeRendezVousState extends State<ListeRendezVous> {
  final MedController medecinController = Get.find<MedController>();
  late List<RendezVous> rendezVousList = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchRendezVous();
  }

  Future<void> fetchRendezVous() async {
    try {
      List<RendezVous> fetchedRendezVous = await medecinController
          .getAllRendezVous();
      setState(() {
        rendezVousList = fetchedRendezVous;
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
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des rendez-vous'),
      ),
      body: ListView.builder(
        itemCount: rendezVousList.length,
        itemBuilder: (BuildContext context, int index) {
          final rendezVous = rendezVousList[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Container(
              width: double.infinity,
              height: 130,
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
                        image: DecorationImage(
                          image: NetworkImage(rendezVous.medecin!.photo!),
                          // L'URL de la photo du médecin
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 25),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5),
                          // Titre et sous-titre du rendez-vous
                          Text(
                            rendezVous.sujet ?? '',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Date: ${DateFormat('yyyy-MM-dd').format(
                                rendezVous.date!)}\n'
                                'Heure début: ${rendezVous.heureDebut}\n'
                                'Heure fin: ${rendezVous.heureFin}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade400,
                            ),
                          ),
                          // Spécialité du médecin
                          Text(
                            'Spécialité: ${rendezVous.medecin!.specialite}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade400,
                            ),
                          ),
                          Spacer(),
                          // Widget pour modifier le temps du rendez-vous
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                // Widget pour afficher l'heure du rendez-vous
                                Container(
                                  width: 90,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: Colors.greenAccent,
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.access_time),
                                        SizedBox(width: 10),
                                        Text(
                                          'Heure',
                                          // Remplacer par l'heure du rendez-vous
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                                // Bouton pour éditer le rendez-vous
                                GestureDetector(
                                  onTap: () {
                                    // Ajouter ici la logique pour l'édition du rendez-vous si nécessaire
                                  },
                                  child: Container(
                                    width: 90,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: Color(0xffE2F6F1),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit),
                                          SizedBox(width: 10),
                                          Text(
                                            'edit',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.home,
                    color: _selectedIndex == 0 ? Colors.white : Colors.grey),
                onPressed: () {
                  setState(() {
                    _selectedIndex = 0;
                  });
                  // Naviguer vers la page DoctorCard
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DoctorCard()));
                },
              ),
              IconButton(
                icon: Icon(Icons.filter_alt,
                    color: _selectedIndex == 1 ? Colors.white : Colors.grey),
                onPressed: () {
                  setState(() {
                    _selectedIndex = 1;
                  });
                  // Afficher le filtre

                },
              ),
              IconButton(
                icon: Icon(Icons.settings,
                    color: _selectedIndex == 2 ? Colors.white : Colors.grey),
                onPressed: () {
                  setState(() {
                    _selectedIndex = 2;
                  });
                  // Ajouter ici la logique pour les paramètres si nécessaire
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

  // Fonction pour afficher le filtre

