import 'package:flutter/material.dart';
import 'package:ofood/models/food.dart';
import 'package:ofood/models/order.dart';

class OrderListTile extends StatefulWidget {
  final OfoodOrder order;
  final int rank;
  const OrderListTile({Key? key, required this.order, required this.rank})
      : super(key: key);

  @override
  _OrderListTileState createState() => _OrderListTileState();
}

class _OrderListTileState extends State<OrderListTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.orange)),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(48.0),
                          child: Center(child: Text(widget.order.toString())),
                        ),
                      ],
                    ),
                  );
                });
          },
          child: ListTile(
            title: Text('Commande n° ${widget.rank}'),
            subtitle: Text(
              'Chez ${widget.order.restoName}',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
            // Modidy and set the state
            trailing: Text('etat'),
          ),
        ),
      ),
    );
  }
}
