import 'package:flutter/material.dart';
import 'package:ofood/models/order.dart';
import 'package:ofood/services/database.dart';
import 'package:ofood/widgetUtils/orderListTile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  // to manage my endDrawer
  GlobalKey<ScaffoldState> scafKey = GlobalKey();

  var uid;

  Future<Stream> setStreamWithUserId() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    uid = sp.getString('myUserId');
    return DatabaseService('uid').getOrdersByUserId(uid);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setStreamWithUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scafKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Row(
              children: const [
                Text(
                  "O' ",
                  style: TextStyle(color: Colors.orange, fontSize: 25),
                ),
                Text('commandes', style: TextStyle(fontSize: 25))
              ],
            )
          ]),
        ),
        body: FutureBuilder(
            future: setStreamWithUserId(),
            builder: (context, snap) {
              if (snap.hasData) {
                var myStreamOrders = snap.data as Stream;
                return StreamBuilder(
                  stream: myStreamOrders,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return const Center(
                          child: Text('Pas de connexion'),
                        );
                      case ConnectionState.waiting:
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.orange,
                          ),
                        );
                      default:
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else {
                          if (snapshot.data == null) {
                            return const Center(
                                child: CircularProgressIndicator(
                              color: Colors.orange,
                            ));
                          }
                          var orders = snapshot.data as List<OfoodOrder>;
                          return ListView.builder(
                              itemCount: orders.length,
                              itemBuilder: (context, i) {
                                return OrderListTile(
                                    order: orders[i], rank: i + 1);
                              });
                        }
                    }
                  },
                );
              }
              return Text('no data');
            }));
  }
}
