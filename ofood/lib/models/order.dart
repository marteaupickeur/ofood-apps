import 'package:flutter/foundation.dart';

class OfoodOrder {
  String userId;
  bool state;
  String restoName;
  Map order;

  OfoodOrder(
      {required this.order,
      required this.state,
      required this.restoName,
      required this.userId});

  @override
  String toString() {
    // TODO: implement toString
    return 'Commande chez $restoName\nEtat de votre commande: $state\nVotre commande : $order';
  }
}
