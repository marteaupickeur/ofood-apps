import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ofood/models/user.dart';
import 'package:ofood/services/authentification.dart';
import 'package:ofood/services/database.dart';
import 'package:ofood/widgetUtils/appBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ofood/widgetUtils/drawer.dart';

class Agence extends StatefulWidget {
  const Agence({Key? key}) : super(key: key);

  @override
  _AgenceState createState() => _AgenceState();
}

class _AgenceState extends State<Agence> {
  // key for opening manualy the endDrawer
  final GlobalKey<ScaffoldState> scafKey = GlobalKey();

  String dropdownvalue = 'Selection';
  // the dropdawnvalue item
  var items = [
    'Selection',
  ];

  AuthenticationService auth = AuthenticationService();

  // get the list of agence direct from firestore DB
  // and put it on list agence item
  getListAgence() async {
    Stream s = await DatabaseService("no_need_userId").getAgnecesData();
    s.listen((snapshot) {
      if (mounted) {
        setState(() {
          items = ['Selection'];
          for (var agence in snapshot) {
            items.add(agence.agenceId);
          }
        });
      }
    });
  }

  // declare the Sharedpreferences
  // set it
  // and go to selected restaurant
  goToAgence() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    sp.setString("myAgence", dropdownvalue);
    Navigator.pushNamed(context, '/home');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getListAgence();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: scafKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
          actions: [OfoodAppBar(scafKey: scafKey)],
        ),
        // to define with stream
        endDrawer: const OfoodDrawer(),
        body: Container(
          decoration: const BoxDecoration(color: Colors.white),
          padding: const EdgeInsets.all(18),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "O'",
                      style: TextStyle(color: Colors.orange, fontSize: 25),
                    ),
                    Text("agence",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 25))
                  ],
                ),
                SizedBox(
                  width: 500,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 28, 0, 28),
                        child: DropdownButton<String>(
                          value: dropdownvalue,
                          icon: const Icon(Icons.arrow_drop_down),
                          isExpanded: true,
                          elevation: 16,
                          underline: Container(
                            height: 2,
                            color: Colors.orange,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownvalue = newValue!;
                            });
                          },
                          items: items.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                        ),
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.orange),
                          ),
                          onPressed: () {
                            if (dropdownvalue == 'Selection') {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                backgroundColor: Colors.orange,
                                content: Row(
                                  children: const [
                                    Expanded(child: SizedBox()),
                                    Text(
                                      "Veuillez selectionner une agence !",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Expanded(child: SizedBox())
                                  ],
                                ),
                              ));
                            } else {
                              goToAgence();
                            }
                          },
                          child: const Icon(Icons.arrow_forward,
                              color: Colors.black)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
