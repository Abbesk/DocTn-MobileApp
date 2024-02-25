import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import '../controllers/medecinController.dart';
import '../entities/medecin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/services.dart';

import '../theme/theme_model.dart';
import 'LoginScreen.dart';

class DoctorCard extends StatefulWidget {
  const DoctorCard({Key? key}) : super(key: key);

  @override
  _DoctorCardState createState() => _DoctorCardState();
}

class _DoctorCardState extends State<DoctorCard> {
  dynamic _selectedIndex = {};
  int _selectedIndex1 = 0;
  String? _selectedSpecialite;
  String _nomPrenom = '';
  String _ville = '';
  int _current = 0;
  bool _isSelected = false;
  bool _canScroll = false;
  TextEditingController specialtyController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  CarouselController _carouselController = CarouselController();
  late String? v_location_medecin = "";
  final MedController medecinController = Get.find<MedController>();
  List<Medecin> _medecins = [];

  @override
  void initState() {
    super.initState();
    _initStateAsync();
  }

  Future<void> _initStateAsync() async {
    try {
      Position position = await _determinePosition();
      String? address = await getAddressFromLatLng(position.latitude, position.longitude);
      setState(() {
        v_location_medecin = address?.split(', ')[1].split(' ').sublist(1).join(' ');
      });
      print(v_location_medecin);
      await fetchMedecins();
    } catch (e) {
      print('Error initializing DoctorCard: $e');
    }
  }

  Future<void> fetchMedecins({String? ville, String? nomPrenom, String? specialite}) async {
    try {
      List<Medecin> medecins = await medecinController.fetchMedecins(ville: ville, nomPrenom: nomPrenom, specialite: specialite);
      setState(() {
        _medecins = medecins;
      });
    } catch (e) {
      print('Failed to fetch medecins due to unexpected error: $e');
      throw Exception('Unexpected error occurred while fetching medecins');
    }
  }

  Future<String?> getAddressFromLatLng(double lat, double lng) async {
    String mapApiKey = 'AIzaSyAlaY2-1iL8KOx3c6-VDHjKFTa9ms_UojY'; // Replace this with your API key
    String _host = 'https://maps.google.com/maps/api/geocode/json';
    final url = '$_host?key=$mapApiKey&language=en&latlng=$lat,$lng';

    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data["status"] == "OK" && data.containsKey("results") && data["results"].isNotEmpty) {
          String _formattedAddress = data["results"][0]["formatted_address"];
          print("Response: $_formattedAddress");
          return _formattedAddress;
        } else {
          print("Error: No results found for the provided coordinates.");
          return null;
        }
      } else {
        print("Error: Failed to fetch data from Google Geocoding API. Status code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  Future<Position> _determinePosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }
      LocationPermission permission = await Geolocator.requestPermission();
       permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      // Permissions are granted, get current position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium);
      print('Position: $position');
      return position;
    } catch (e) {
      print('Error getting position: $e');
      throw e;
    }
  }

  void _showFilterDialog() {
    final List<String> specialites = [
      "Médecin généraliste",
      "Dentiste",
      "Pédiatre",
      "Cardiologue",
    ];
    String selectedSpecialite = specialites.first;
    String defaultVille = v_location_medecin ?? "";
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              "Choisissez vos critères de recherche",
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
                  value: selectedSpecialite,
                  onChanged: (value) {
                    selectedSpecialite = value!;
                  },
                  items: specialites.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: "Spécialité",
                    icon: Icon(Icons.local_hospital),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Nom et prénom",
                    icon: Icon(Icons.person),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: addressController..text = defaultVille,
                  decoration: InputDecoration(
                    labelText: "Ville",
                    icon: Icon(Icons.location_on),
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
                  _selectedIndex1 = 0; // Réinitialiser l'index du bas de navigation à zéro
                });
              },
            ),

            ElevatedButton(
              onPressed: () {
                _selectedSpecialite = selectedSpecialite;
                _nomPrenom = nameController.text;
                _ville = addressController.text;
                fetchMedecins(ville: _ville, nomPrenom: _nomPrenom, specialite: _selectedSpecialite);
                Navigator.of(context).pop();
                setState(() {
                  _selectedIndex1 = 0; // Réinitialiser l'index du bas de navigation à zéro
                });
              },
              child: Text("Appliquer"),
            ),

          ],
        );
      },
    );
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_on, size: 24),
                  SizedBox(width: 10),
                  Text(
                    'Localisation : ${v_location_medecin ?? "Non disponible"}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CarouselSlider(
                carouselController: _carouselController,
                options: CarouselOptions(
                  height: 450.0,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.70,
                  enlargeCenterPage: true,
                  pageSnapping: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  },
                ),
                items: _medecins.map((med) {
                  return Builder(
                    builder: (BuildContext context) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (_selectedIndex == med) {
                              _selectedIndex = null;
                              _isSelected = false;
                            } else {
                              _selectedIndex = med;
                              _isSelected = true;
                            }
                          });
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: _selectedIndex == med
                                ? Border.all(
                                color: Colors.blue.shade500, width: 1)
                                : null,
                            boxShadow: _selectedIndex == med
                                ? [
                              BoxShadow(
                                  color: Colors.blue.shade100,
                                  blurRadius: 30,
                                  offset: Offset(0, 10))
                            ]
                                : [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  blurRadius: 20,
                                  offset: Offset(0, 5))
                            ],
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                AnimatedContainer(
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeIn,
                                  height: _isSelected ? 200 : 320,
                                  margin: EdgeInsets.only(top: 10),
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Image.network(
                                    med.photo!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  med.nomPrenom!,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  med.specialite!,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
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
                icon: Icons.settings,
                text: 'Paramètres',
              ),
              GButton(
                icon: Icons.filter_alt,
                text: 'Filtre',
              ),
            ],
            selectedIndex: _selectedIndex1,
            onTabChange: (index) {
              setState(() {
                _selectedIndex1 = index;
              });
              if (index == 2) {
                _showFilterDialog();
              }
            },
          ),
        ),
      ),

    );
  }
}
