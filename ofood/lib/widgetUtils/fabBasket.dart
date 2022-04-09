import 'package:flutter/material.dart';
import 'package:ofood/models/food.dart';
import 'package:ofood/utils/basket.dart';
import 'package:ofood/utils/currentUser.dart';
import 'package:ofood/utils/handleOrders.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OfoodBasketFAB extends StatefulWidget {
  const OfoodBasketFAB({Key? key}) : super(key: key);

  @override
  _OfoodBasketFABState createState() => _OfoodBasketFABState();
}

class _OfoodBasketFABState extends State<OfoodBasketFAB> {
  var myUid;

  getMyUidFromSP() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    myUid = sp.getString('myUserId');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMyUidFromSP();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Basket>(
      builder: (BuildContext context, Basket basket, Widget? child) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 18, 0, 18),
          child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 28.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "O' ",
                      style: TextStyle(color: Colors.orange, fontSize: 25),
                    ),
                    Text("panier",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 25))
                  ],
                ),
              ),
              Builder(builder: (context) {
                if (basket.foodDisplay.isNotEmpty) {
                  return SizedBox(
                    height: 200,
                    child: ListView.builder(
                      itemCount: basket.foodDisplay.length,
                      itemBuilder: (context, i) {
                        OfoodFood foodItem = basket.foodDisplay[i][0];

                        return ListTile(
                          leading: Text('${basket.foodDisplay[i][1]}  x  '),
                          title: Text('${basket.foodDisplay[i][0]}'),
                          subtitle: Text(foodItem.foodPrice),
                          trailing: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.orange)),
                            onPressed: () {
                              setState(() {
                                basket.removeFullFood(basket.foodDisplay[i]);
                              });
                            },
                            child: const Icon(
                              Icons.delete,
                              color: Colors.black,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                return const Padding(
                  padding: EdgeInsets.fromLTRB(0, 50, 0, 50),
                  child: Center(
                    child: Text(
                      'Panier vide',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                );
              }),
              Builder(builder: (context) {
                if (basket.foodDisplay.isNotEmpty) {
                  return Text(
                      'Total : ${basket.getTotalPrice().toString()} frcs');
                }
                return Container();
              }),
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.orange)),
                    onPressed: () {
                      if (basket.foodDisplay.isNotEmpty) {
                        basket.validateOrderOnBasket();
                        // dispatch and send to DB
                        HandleOrders(
                                bruteOrders: basket.foodOnOrder, userId: myUid)
                            .dispatchOrdersByRestoName();
                        basket.foodOnOrder.clear();

                        Navigator.pop(context);
                        // Navigator.pushNamed(context, '/order');
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('valider panier',
                        style: TextStyle(color: Colors.black))),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
