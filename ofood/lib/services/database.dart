import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ofood/models/food.dart';
import 'package:ofood/models/order.dart';
import 'package:ofood/models/resto.dart';
import 'package:ofood/models/user.dart';
import 'package:ofood/models/agence.dart';

class DatabaseService {
  // for getUser i need the userId
  final String uid;
  DatabaseService(this.uid);

  // Creation of collection named users
  final CollectionReference users =
      FirebaseFirestore.instance.collection("users");

  // agences collection
  final CollectionReference agences =
      FirebaseFirestore.instance.collection('agences');

  // restos collection
  final CollectionReference restos =
      FirebaseFirestore.instance.collection('restos');

  // foods collection
  final CollectionReference foods =
      FirebaseFirestore.instance.collection('foods');

  // orders collection
  final CollectionReference orders =
      FirebaseFirestore.instance.collection('orders');

  // ******************* ALL ABOUT USER ******************************
  // Creation of user with the user_id from FB Auth
  // when yu use instance.collection.doc(value of your table)
  // set will be used because yu have already created the element
  Future<void> saveUser(AppUser? appUser) async {
    if (appUser == null) {
      return;
    }
    try {
      return await users.doc(appUser.userId).set(
          {'name': appUser.userName, 'phoneNumber': appUser.userPhoneNumber});
    } catch (e) {
      print("Error from database/set_user: $e");
    }
  }

  // take a snapshot as parameter
  AppUser? userFromDatabase(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    if (data == null) {
      return null;
    }

    return AppUser(
        userId: snapshot.id,
        userName: data['name'],
        userPhoneNumber: data['phoneNumber']);
  }

  Future<Stream> getUser() async {
    return users.doc(uid).snapshots().map(userFromDatabase);
  }

  // ******************* ALL ABOUT AGENCES ******************************
  OfoodAgence agenceFromDatabase(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;

    return OfoodAgence(
        agenceId: snapshot.id,
        agenceName: data['agenceName'],
        agenceRestos: List.from(data['agenceRestos']));
  }

  List<OfoodAgence> agenceListFromDatabase(QuerySnapshot snapshot) {
    var newSnapchot = snapshot as QuerySnapshot<Map<String, dynamic>>;
    return newSnapchot.docs.map((doc) {
      return agenceFromDatabase(doc);
    }).toList();
  }

  Future<Stream> getAgnecesData() async {
    return agences.snapshots().map(agenceListFromDatabase);
  }

  Future<Stream> getAgneceDataById(String? id) async {
    return agences.doc(id).snapshots().map(agenceFromDatabase);
  }

  // ******************* ALL ABOUT RESTOS ******************************
  OfoodResto restoFromDatabase(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;

    return OfoodResto(
        restoId: snapshot.id,
        restoName: data['restoName'],
        restoDelivry: data['restoDelivry'],
        restoKind: List.from(data['restoKind']),
        restoMenu: List.from(data['restoMenu']));
  }

  List<OfoodResto> restoListFromDatabase(QuerySnapshot snapshot) {
    var newSnapshot = snapshot as QuerySnapshot<Map<String, dynamic>>;
    return newSnapshot.docs.map((doc) {
      return restoFromDatabase(doc);
    }).toList();
  }

  Future<Stream> getRestosData() async {
    return restos.snapshots().map(restoListFromDatabase);
  }

  Future<Stream> getRestoDataById(String id) async {
    return restos.doc(id).snapshots().map(restoFromDatabase);
  }

  // ******************* ALL ABOUT FOODS ******************************
  OfoodFood foodFromDatabase(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return OfoodFood(
        foodId: snapshot.id.toString(),
        foodName: data['foodName'],
        foodKind: data['foodKind'],
        foodPrice: data['foodPrice'],
        foodResto: data['foodResto']);
  }

  List<OfoodFood> foodsFromDatabase(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return foodFromDatabase(doc);
    }).toList();
  }

  Stream getFoodDataById(String id) {
    return foods.doc(id).snapshots().map(foodFromDatabase);
  }

  Stream getFoodDataByNameAndKind(String kind, String name) {
    return foods
        .where('foodResto', isEqualTo: name)
        .where('foodKind', isEqualTo: kind)
        .snapshots()
        .map(foodsFromDatabase);
  }

  // ******************* ALL ABOUT ORDERS ******************************
  Future addOrder(OfoodOrder o) async {
    await orders
        .add({
          'userId': o.userId,
          'order': o.order,
          'restoName': o.restoName,
          'state': o.state
        })
        .then((value) => print('orders added'))
        .catchError((e) => print('failed to add orders'));
  }

  List<OfoodOrder> ordersFromDatabase(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return orderFromDatabase(doc);
    }).toList();
  }

  OfoodOrder orderFromDatabase(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    // print(data);
    return OfoodOrder(
        order: data['order'],
        state: data['state'],
        restoName: data['restoName'],
        userId: data['userId']);
  }

  Stream getOrdersByUserId(String userId) {
    return orders
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map(ordersFromDatabase);
  }

  Stream checkIfUserHasCurrentOrders(String userId) {
    // check of my user order
    Stream checker = getOrdersByUserId(userId);

    // creation of the boolean stream
    StreamController<bool> controller = StreamController<bool>();
    Stream<bool> myStream = controller.stream;

    // do the checking here and fill the new stream at the same time !
    checker.listen((snap) {
      List<OfoodOrder> orders = snap;

      if (orders.isEmpty) {
        controller.add(false);
      } else {
        controller.add(true);
      }
    });

    return myStream;
  }
}
