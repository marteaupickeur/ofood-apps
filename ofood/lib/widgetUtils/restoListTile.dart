import 'package:flutter/material.dart';
import 'package:ofood/models/resto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestoListTile extends StatefulWidget {
  final OfoodResto resto;
  const RestoListTile({Key? key, required this.resto}) : super(key: key);

  @override
  _RestoListTileState createState() => _RestoListTileState();
}

class _RestoListTileState extends State<RestoListTile> {
  goToFood() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('myResto', widget.resto.restoName.toString());
    var list = List<String>.from(widget.resto.restoMenu);
    sp.setStringList('foodList', list);
    Navigator.pushNamed(context, '/resto');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: ListTile(
          title: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: InkWell(
                onTap: (() {
                  goToFood();
                }),
                child: widget.resto.restoDelivry
                    ? Center(
                        child: Stack(alignment: Alignment.topRight, children: [
                          Image(
                              image: AssetImage(
                                  'assets/${widget.resto.restoKind[0].toString()}.jpg')),
                          const Text(
                            ' Livraison      ',
                            style: TextStyle(
                                backgroundColor: Colors.orange,
                                fontWeight: FontWeight.bold),
                          )
                        ]),
                      )
                    : Image(
                        image: AssetImage(
                            'assets/${widget.resto.restoKind[0].toString()}.jpg')),
              )),
          subtitle: Column(
            children: [
              Row(
                children: [
                  Text(widget.resto.restoName,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  const Expanded(child: SizedBox()),
                  Text(
                    widget.resto.restoKind.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.orange),
                  ),
                ],
              ),
              // const Divider(
              //   color: Colors.black,
              // ),
            ],
          )),
    );
  }
}
