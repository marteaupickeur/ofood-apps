import 'dart:async';

import 'package:flutter/material.dart';

class Spalsh extends StatefulWidget {
  const Spalsh({Key? key}) : super(key: key);

  @override
  _SpalshState createState() => _SpalshState();
}

class _SpalshState extends State<Spalsh> {
  // this function called on init will call
  // after a delay the agenceRoute
  startTimer() async {
    var duration = Duration(seconds: 4);
    return Timer(duration, agenceRoute);
  }

  // this one allow us to reach the page login
  agenceRoute() {
    Navigator.pushReplacementNamed(context, '/log');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: true,
        child: Container(
          decoration: const BoxDecoration(color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: const Image(
                        width: 70,
                        height: 70,
                        image: AssetImage("assets/ab.jpg"),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: const [
                    Expanded(child: Text("in Memoriam of AAD")),
                    Expanded(child: SizedBox()),
                    Text(
                      'Orange',
                      style: TextStyle(fontSize: 20, color: Colors.orange),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
