import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ofood/services/authentification.dart';
import 'package:ofood/services/database.dart';
import 'package:ofood/utils/currentUser.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OfoodDrawer extends StatefulWidget {
  const OfoodDrawer({Key? key}) : super(key: key);

  @override
  _OfoodDrawerState createState() => _OfoodDrawerState();
}

class _OfoodDrawerState extends State<OfoodDrawer> {
  AuthenticationService auth = AuthenticationService();

  var uid;

  Future<Stream> setStreamWithUserId() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    uid = sp.getString('myUserId');
    return DatabaseService('uid').checkIfUserHasCurrentOrders(uid);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.orange,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SafeArea(
          child: Column(children: [
            const Icon(
              Icons.person,
              size: 50,
            ),
            const Divider(
              color: Colors.black,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer<CurrentUser>(builder: (BuildContext context,
                      CurrentUser myCurrentUser, Widget? child) {
                    myCurrentUser.getUserFromAuth();
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 18.0),
                          child: myCurrentUser.userDataFlag
                              ? Text(
                                  "Nom: ${myCurrentUser.userData.userName}",
                                  style: const TextStyle(fontSize: 18),
                                )
                              : const Text(
                                  "Nom: Null",
                                  style: TextStyle(fontSize: 18),
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 18.0),
                          child: myCurrentUser.userDataFlag
                              ? Text(
                                  "Numero: ${myCurrentUser.userData.userPhoneNumber}",
                                  style: const TextStyle(fontSize: 18),
                                )
                              : const Text(
                                  "Numero: Null",
                                  style: TextStyle(fontSize: 18),
                                ),
                        ),
                      ],
                    );
                  }),
                  FutureBuilder(
                      future: setStreamWithUserId(),
                      builder: (context, snap) {
                        if (snap.hasData) {
                          var myStreamChecker = snap.data as Stream<bool>;
                          return StreamBuilder<bool>(
                              stream: myStreamChecker,
                              builder: (context, AsyncSnapshot snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.none:
                                    return const Center(
                                      child: Text('Pas de connexion'),
                                    );
                                  default:
                                    if (snapshot.hasError) {
                                      return const Icon(Icons.error);
                                    } else {
                                      if (snapshot.data == null) {
                                        return const Center(
                                            child: Icon(Icons.cancel_outlined));
                                      }
                                      var onOrder = snapshot.data as bool;
                                      if (onOrder) {
                                        return ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.black)),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Navigator.pushNamed(
                                                  context, '/order');
                                            },
                                            child: const Text(
                                              "Commande En cours",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ));
                                      } else {
                                        return const Text("Pas de commande !",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w900));
                                      }
                                    }
                                }
                              });
                        }
                        return Text('no data');
                      })
                ],
              ),
            ),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Icon(
                        Icons.logout,
                      ),
                    ),
                    Text("deconexion")
                  ],
                ),
                onPressed: () {
                  Navigator.of(context).pop;
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Confirmation'),
                          content: const Text('Etes vous sûr ?'),
                          actions: [
                            ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.orange)),
                                onPressed: () async {
                                  await auth.signOut();
                                  // remove the Alert dialog
                                  Navigator.pushNamedAndRemoveUntil(context,
                                      '/log', (Route<dynamic> route) => false);
                                },
                                child: const Text(
                                  'Oui',
                                  style: TextStyle(color: Colors.black),
                                )),
                            ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.orange)),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Non',
                                    style: TextStyle(color: Colors.black)))
                          ],
                        );
                      });
                })
          ]),
        ),
      ),
    );
  }
}
