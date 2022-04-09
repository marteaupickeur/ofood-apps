import 'package:flutter/material.dart';
import 'package:ofood/services/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OfoodAppBar extends StatefulWidget {
  final GlobalKey<ScaffoldState> scafKey;
  const OfoodAppBar({Key? key, required this.scafKey}) : super(key: key);

  @override
  _OfoodAppBarState createState() => _OfoodAppBarState();
}

class _OfoodAppBarState extends State<OfoodAppBar> {
  var uid;

  Future<Stream> setStreamWithUserId() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    uid = sp.getString('myUserId');
    return DatabaseService('uid').checkIfUserHasCurrentOrders(uid);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: FutureBuilder(
          future: setStreamWithUserId(),
          builder: (context, snap) {
            if (snap.hasData) {
              var myStreamChecker = snap.data as Stream<bool>;
              return StreamBuilder<bool>(
                  stream: myStreamChecker,
                  builder: (context, AsyncSnapshot snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return const Icon(Icons.wifi_off);
                      case ConnectionState.waiting:
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.orange,
                          ),
                        );
                      default:
                        if (snapshot.hasError) {
                          return const Icon(Icons.error);
                        } else {
                          if (snapshot.data == null) {
                            return const Center(
                                child: CircularProgressIndicator(
                              color: Colors.orange,
                            ));
                          }
                          var onOrder = snapshot.data as bool;
                          if (onOrder) {
                            return CircleAvatar(
                                backgroundColor: Colors.orange,
                                child: IconButton(
                                    onPressed: () {
                                      widget.scafKey.currentState!
                                          .openEndDrawer();
                                    },
                                    icon: const Icon(
                                      Icons.fastfood,
                                      color: Colors.black,
                                    )));
                          } else {
                            return IconButton(
                                onPressed: () {
                                  widget.scafKey.currentState!.openEndDrawer();
                                },
                                icon: const Icon(
                                  Icons.person,
                                  size: 30,
                                ));
                          }
                        }
                    }
                  });
            }
            return const Text('no data');
          },
        ));
  }
}
