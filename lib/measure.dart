import 'package:flutter/material.dart';
import 'package:object_measure/home_screen.dart';

class Measure extends StatefulWidget {
  const Measure({super.key});

  @override
  State<Measure> createState() => _MeasureState();
}

class _MeasureState extends State<Measure> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[500],
        title: const Text("Page Title", style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              // Provide an alternative action or navigate to a specific screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePageWidget()),
              );
            }
          },
        ),
      ),
      body: Center(
        child: Text('This is the Measure page'),
      ),
    );
  }
}
