import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ofood/utils/basket.dart';
import 'package:provider/provider.dart';

class OfoodApprovedFAB extends StatelessWidget {
  const OfoodApprovedFAB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Confimation'),
      content: Text('Voulez vous ajouter ces produits au panier ?'),
      actions: [
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.orange)),
            onPressed: () {
              Provider.of<Basket>(context, listen: false)
                  .copyFoodOnValidation();
              Provider.of<Basket>(context, listen: false).removeAllFood();
              Navigator.of(context).pop();

              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.orange,
                content: Row(
                  children: const [
                    Expanded(
                      child: Text(
                        'Valider votre panier !',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Icon(
                      Icons.arrow_upward,
                      color: Colors.black,
                    )
                  ],
                ),
              ));
            },
            child: const Text('Oui', style: TextStyle(color: Colors.black))),
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.orange)),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Non', style: TextStyle(color: Colors.black))),
      ],
    );
  }
}
