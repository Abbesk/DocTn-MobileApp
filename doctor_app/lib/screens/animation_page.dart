import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:lottie/lottie.dart';

class AnimationPage extends StatelessWidget {
  final String animationUrl;

  const AnimationPage({Key? key, required this.animationUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

