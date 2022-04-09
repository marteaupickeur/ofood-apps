import 'package:flutter/material.dart';
import 'package:ofood/utils/basket.dart';
import 'package:ofood/widgetUtils/appBar.dart';
import 'package:ofood/widgetUtils/drawer.dart';
import 'package:ofood/widgetUtils/fabAlertDialog.dart';
import 'package:ofood/widgetUtils/foodSection.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Resto extends StatefulWidget {
  const Resto({Key? key}) : super(key: key);

  @override
  _RestoState createState() => _RestoState();
}

class _RestoState extends State<Resto> {
  GlobalKey<ScaffoldState> scafKey = GlobalKey();

  List<String> listFoodsName = [];

  Future getFoodIdAndFoodListBySP() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    var myResto = sp.getString('myResto');
    var foodList = sp.getStringList('foodList') as List<String>;

    return [myResto, foodList];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          key: scafKey,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            foregroundColor: Colors.black,
            leading: Consumer<Basket>(
              builder: (context, basket, child) => IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () {
                  basket.removeAllFood();
                  Navigator.of(context).pop();
                },
              ),
            ),
            title:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Row(
                children: [
                  const Text(
                    "O' ",
                    style: TextStyle(color: Colors.orange, fontSize: 25),
                  ),
                  FutureBuilder(
                      future: getFoodIdAndFoodListBySP(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var dataFromSP = snapshot.data as List;
                          return Text('${dataFromSP[0]}',
                              style: const TextStyle(fontSize: 25));
                        } else {
                          // i will change it ......
                          return CircularProgressIndicator();
                          // const Text('resto',
                          //     style: TextStyle(fontSize: 25));
                        }
                      })
                ],
              )
            ]),
            bottom: const TabBar(indicatorColor: Colors.orange, tabs: [
              Tab(text: 'Menus'),
              Tab(text: 'Boissons'),
              Tab(text: 'Plats'),
              Tab(text: 'Desserts'),
            ]),
          ),
          body: Stack(alignment: Alignment.bottomCenter, children: [
            TabBarView(children: [
              FoodSection(funct: getFoodIdAndFoodListBySP(), kind: 'Menus'),
              FoodSection(funct: getFoodIdAndFoodListBySP(), kind: 'Boissons'),
              FoodSection(funct: getFoodIdAndFoodListBySP(), kind: 'Plats'),
              FoodSection(funct: getFoodIdAndFoodListBySP(), kind: 'Desserts'),
            ]),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.orange)),
                onPressed: () {
                  showDialog(
                      barrierColor: Colors.black87,
                      context: context,
                      builder: (context) {
                        return OfoodApprovedFAB();
                      });
                },
                child: const Text(
                  "ajouter au panier",
                  style: TextStyle(color: Colors.black),
                ))
          ]),
        ),
      ),
    );
  }
}
