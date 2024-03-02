import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'ListAppointments.dart';

class AnimationPage extends StatelessWidget {
  final String animationUrl;

  const AnimationPage({Key? key, required this.animationUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ajouter un délai avant de naviguer vers une autre page
    Future.delayed(Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ListeRendezVous()),
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Enregistrement..'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.network(
                  animationUrl,
                  width: 300,
                  height: 300,
                  fit: BoxFit.cover,
                  alignment: Alignment.center
              ),
              SizedBox(height: 20),
              Text(
                'Votre rendez-vous est bien enregistré',
                textAlign: TextAlign.center, // Alignement centré du texte
                style: TextStyle(
                  color: Colors.blueGrey, // Couleur du texte
                  fontSize: 20, // Taille du texte
                  fontWeight: FontWeight.w100, // Gras
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
