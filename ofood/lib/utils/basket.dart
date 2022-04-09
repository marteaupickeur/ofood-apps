import 'package:flutter/material.dart';
import 'package:ofood/models/food.dart';

class Basket with ChangeNotifier {
  // sub list on resto screen
  // validate or delete when left
  List food = [];

  // real list : on each validation on
  // food sub list it will be add on this list
  // to display on the basket
  List foodDisplay = [];

  // on each validation of listFoddDisplay
  // add contents on this order list
  List foodOnOrder = [];

  // boolean var for display icon on
  // basket validation;
  bool validate = false;

  // add on future other method to set false
  // validate when there is no more order on Order screen

  // RESTO FUNCTIONS********************

  addFood(OfoodFood f) {
    // if false add new one else it suppose to be exist already
    bool found = false;

    for (List item in food) {
      OfoodFood myFood = item[0];
      if (myFood.foodId == f.foodId) {
        item[1]++;

        found = true;
      }
    }

    if (!found) {
      food.add([f, 1]);
    }

    notifyListeners();
  }

  removeFood(OfoodFood f) {
    List found = [];
    for (List item in food) {
      OfoodFood myFood = item[0];
      if (myFood.foodId == f.foodId) {
        if (item[1] == 1) {
          found = item;
        }
        if (item[1] > 1) {
          item[1]--;
        }
      }
    }

    if (found.isNotEmpty) {
      food.remove(found);
    }
    notifyListeners();
  }

  // remove sublist food when left the resto screen without
  // validation
  removeAllFood() {
    food.clear();
    notifyListeners();
  }

  // the item counter display on add or remove item
  int? itemFoodQty(OfoodFood f) {
    if (food.isEmpty) {
      return 0;
    }
    for (List item in food) {
      OfoodFood myFood = item[0];
      if (myFood.foodId == f.foodId) {
        return item[1];
      }
    }
    return 0;
  }

  // three cases:
  // case 1 : when foodDisplay is empty
  // case 2 : when foodDisplay is not empty and contain element
  // case 3 : when foodDisplay is not empty and doesnt containt element
  copyFoodOnValidation() {
    int counter = 0; // for case 3

    for (List item in food) {
      if (foodDisplay.isNotEmpty) {
        for (List itemDisplay in foodDisplay) {
          OfoodFood i = item[0];
          OfoodFood iD = itemDisplay[0];
          // case 2 : adding the new quantity of the item (already exist on foodDisplay)
          if (i.foodId == iD.foodId) {
            itemDisplay[1] = itemDisplay[1] + item[1];
          }
          //case 3 : in preparation cauze when after loop the counter's size  equals to foodDisplay's size its mean that element is not in list
          else {
            counter++;
          }
        }
        // case 3 : final step because we add the item now
        if (counter == foodDisplay.length) {
          foodDisplay.add(item);
          counter = 0;
        }
      }
      // case 1 : because the foodDisplay is empty
      else {
        foodDisplay.add(item);
      }
    }
    notifyListeners();
  }

  // BASKET FUNCTIONS************************

  // for basket screen
  int getTotalPrice() {
    int price = 0;
    for (List l in foodDisplay) {
      OfoodFood f = l[0];
      int p = int.parse(f.foodPrice);
      price += p * l[1] as int;
    }
    return price;
  }

  // the buttton remove on real basket
  // when it's display
  removeFullFood(List f) {
    foodDisplay.remove(f);
    notifyListeners();
  }

  // for Order screen
  validateOrderOnBasket() {
    if (foodDisplay.isNotEmpty) {
      validate = true;
      for (List l in foodDisplay) {
        foodOnOrder.add(l);
      }
      foodDisplay.clear();
    } else {
      validate = false;
    }
    notifyListeners();
  }

  // ORDER FUNCTIONS**************************

  @override
  String toString() {
    // TODO: implement toString
    return food.toString();
  }
}
