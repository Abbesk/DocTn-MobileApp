import 'package:flutter/material.dart';

class Forms extends StatefulWidget {
  const Forms({Key? key}) : super(key: key);

  @override
  State<Forms> createState() => _FormsState();
}

class _FormsState extends State<Forms> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Wrap with Scaffold
      appBar: AppBar(
        title: Text('Your App Title'), // Set your app title
      ),
      body: Center(
        child: Stepper(
          steps: [
            Step(
              isActive: _currentStep == 0,
              title: const Text("Coordonnés"),
              content: const Text(
                'Information 1 ',
                style: TextStyle(
                  color: Colors.greenAccent,
                ),
              ),
            ),
            Step(
              isActive: _currentStep == 1,
              title: const Text("Date"),
              content: const Text(
                'Information 1 ',
                style: TextStyle(
                  color: Colors.greenAccent,
                ),
              ),
            ),
            Step(
              isActive: _currentStep == 2,
              title: const Text("Remarque"),
              content: const Text(
                'Information 1 ',
                style: TextStyle(
                  color: Colors.greenAccent,
                ),
              ),
            ),
          ],
          onStepTapped: (int newIndex) {
            setState(() {
              _currentStep = newIndex;
            });
          },
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep != 2) {
              setState(() {
                _currentStep += 1;
              });
            }
          },
          onStepCancel: () {
            setState(() {
              if (_currentStep != 0) {
                setState(() {
                  _currentStep -= 1;
                });
              }
            });
          },
          type: StepperType.horizontal,
        ),
      ),
    );
  }
}
