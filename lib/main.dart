import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_browser.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

void main() {
  runApp(AgeFinder());
}

class AgeFinder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Welcome to My App",
      home: AppBody(),
    );
  }
}

class AppBody extends StatefulWidget {
  @override
  _AppBodyState createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> {
  String year = "";
  late ConfettiController _controllerCenter;
  final dateController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    super.dispose();
  }

  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  Text _display(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.white, fontSize: 20),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.adb_outlined),
        title: const Text("Find Your Age"),
      ),
      body: SafeArea(
        child: Container(
          child: Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: ConfettiWidget(
                        confettiController: _controllerCenter,
                        blastDirectionality: BlastDirectionality
                            .explosive, // don't specify a direction, blast randomly
                        shouldLoop:
                            true, // start again as soon as the animation is finished
                        colors: const [
                          Colors.green,
                          Colors.blue,
                          Colors.pink,
                          Colors.orange,
                          Colors.purple
                        ], // manually specify the colors to be used
                        createParticlePath:
                            drawStar, // define a custom shape/path.
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Select your birthday",
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 200,
                  height: 200,
                  child: DateTimePicker(
                    type: DateTimePickerType.date,
                    controller: dateController,
                    dateHintText: "Your birth date",
                    icon: const Icon(Icons.baby_changing_station),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2025),
                    dateLabelText: 'Date',
                    onChanged: (val) => calculateBirthday(val),
                    validator: (val) {
                      return null;
                    },
                    onSaved: (val) => print(val),
                  ),
                ),
                Text(
                  year,
                  style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void calculateBirthday(String birthday) {
    final birth = DateFormat("yyyy-MM-dd").parse(birthday);

    final now = DateTime.now();
    final difference = now.difference(birth).inDays;
    setState(() {
      year = "Hurray you are " + (difference ~/ 365).toString() + " years old";
    });
    _controllerCenter.play();
  }
}
