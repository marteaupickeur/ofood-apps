import 'package:flutter/material.dart';
import 'package:ofood/models/agence.dart';
import 'package:ofood/models/resto.dart';
import 'package:ofood/utils/basket.dart';
import 'package:ofood/widgetUtils/appBar.dart';
import 'package:ofood/widgetUtils/drawer.dart';
import 'package:ofood/widgetUtils/restoListTile.dart';
import 'package:ofood/widgetUtils/fabBasket.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ofood/services/database.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // to manage my endDrawer
  GlobalKey<ScaffoldState> scafKey = GlobalKey();

  List listRestosName = [];

  // get the selected restaurant
  Future getAgenceIdBySP() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    var myAgence = sp.getString('myAgence');

    return myAgence;
  }

  // the funct store the restos names from the selected agence
  // on listRestosName vars
  getListRestosNAmeFromDatabase() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    Stream s = await DatabaseService("no_need_user")
        .getAgneceDataById(sp.getString('myAgence'));
    s.listen((snapshot) {
      if (mounted) {
        setState(() {
          listRestosName = snapshot.agenceRestos;
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getListRestosNAmeFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    //empty or full basket change the icon
    // bool basket = false;
    // of my restos but just the names not data
    bool basket = Provider.of<Basket>(context).foodDisplay.isEmpty;

    return Scaffold(
      key: scafKey,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: basket
            ? const Icon(
                Icons.shopping_basket_outlined,
                color: Colors.black,
              )
            : Stack(
                alignment: Alignment.topRight,
                children: const [
                  Icon(
                    Icons.shopping_basket_outlined,
                    color: Colors.black,
                  ),
                  Icon(
                    Icons.circle,
                    color: Colors.black,
                    size: 8,
                  ),
                ],
              ),
        onPressed: () {
          showDialog(
              barrierColor: Colors.black87,
              context: context,
              builder: (context) {
                return const OfoodBasketFAB();
              });
        },
      ),
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
            children: [
              const Text(
                "O' ",
                style: TextStyle(color: Colors.orange, fontSize: 25),
              ),
              FutureBuilder(
                  future: getAgenceIdBySP(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var agenceName = snapshot.data as String;
                      return Text(agenceName,
                          style: const TextStyle(fontSize: 25));
                    } else {
                      return const Text('agence',
                          style: TextStyle(fontSize: 25));
                    }
                  })
            ],
          )
        ]),
        actions: [OfoodAppBar(scafKey: scafKey)],
      ),
      endDrawer: const OfoodDrawer(),
      body: Container(
          decoration: const BoxDecoration(color: Colors.white),
          padding: const EdgeInsets.all(5),
          child: ListView.builder(
              itemCount: listRestosName.length,
              itemBuilder: (context, i) {
                return FutureBuilder(
                    future: DatabaseService('')
                        .getRestoDataById(listRestosName[i].toString()),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var s = snapshot.data as Stream;
                        return StreamBuilder(
                            stream: s,
                            builder: (context, AsyncSnapshot snap) {
                              switch (snap.connectionState) {
                                case ConnectionState.none:
                                  return Text('Press button to start');
                                case ConnectionState.waiting:
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.orange,
                                    ),
                                  );
                                default:
                                  if (snap.hasError)
                                    return Text('Error: ${snap.error}');
                                  else {
                                    var resto = snap.data as OfoodResto;
                                    return RestoListTile(
                                      resto: resto,
                                    );
                                  }
                              }
                            });
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.orange,
                          ),
                        );
                      }
                    });
              })),
    );
  }
}
