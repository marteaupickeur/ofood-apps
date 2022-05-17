import 'package:ofood/models/food.dart';
import 'package:ofood/models/order.dart';
import 'package:ofood/services/database.dart';

class HandleOrders {
  List bruteOrders;
  List goodOrders = [];

  String userId;

  HandleOrders({required this.bruteOrders, required this.userId});

  // the dispatcher on local before sending to DB
  dispatchOrdersByRestoName() {
    List memory = [];
    for (int i = 0; i < bruteOrders.length; i++) {
      // food on memory
      var fm = bruteOrders[i][0] as OfoodFood;

      // check if fm is already on my memory
      if (!memory.contains(fm.foodResto)) {
        // if not add it
        memory.add(fm.foodResto);

        // add the current order on myRest a temporay list foreach loop
        List myResto = [bruteOrders[i]];
        for (int j = 0; j < bruteOrders.length; j++) {
          // fi: current food / fj: food on secand loop
          var fi = bruteOrders[i][0] as OfoodFood;
          var fj = bruteOrders[j][0] as OfoodFood;

          // exept the same food if fi ==  fj add it on list
          if (i != j && fi.foodResto == fj.foodResto) {
            myResto.add(bruteOrders[j]);
          }
        }

        // after each sub-loop (j) add the temporary list on good orders
        goodOrders.add(myResto);

        // wipe the temp list
        myResto = [];
      }
    }

    // send now !
    sendOrdersOnline();
  }

  // prepare the request and send to DB
  // if i don't use userId as null like 'null' it will create order on DB and set userId as null
  sendOrdersOnline() async {
    if (goodOrders.isNotEmpty && userId != 'null') {
      for (List l in goodOrders) {
        var map = {};
        l.forEach((element) => map[element[0].toString()] = element[1]);
        OfoodFood food = l[0][0];
        await DatabaseService('uid').addOrder(OfoodOrder(
            order: map,
            state: true,
            restoName: food.foodResto,
            userId: userId));
      }
    } else {
      print('no way bro §');
    }
  }
}
