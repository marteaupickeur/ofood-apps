import 'package:flutter/material.dart';
import 'package:ofood/models/food.dart';
import 'package:ofood/utils/basket.dart';
import 'package:provider/provider.dart';

class FoodListTile extends StatefulWidget {
  final OfoodFood food;
  const FoodListTile({Key? key, required this.food}) : super(key: key);

  @override
  _FoodListTileState createState() => _FoodListTileState();
}

class _FoodListTileState extends State<FoodListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.food.foodName),
      subtitle: Text('${widget.food.foodPrice} frcs'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
              onPressed: () {
                Provider.of<Basket>(context, listen: false)
                    .removeFood(widget.food);
              },
              icon: const Icon(Icons.remove)),
          Text('${Provider.of<Basket>(context).itemFoodQty(widget.food)}'),
          IconButton(
              onPressed: () {
                Provider.of<Basket>(context, listen: false)
                    .addFood(widget.food);
              },
              icon: const Icon(Icons.add)),
        ],
      ),
    );
  }
}
