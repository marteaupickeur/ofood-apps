import 'package:flutter/material.dart';
import 'package:ofood/models/food.dart';
import 'package:ofood/services/database.dart';
import 'package:ofood/widgetUtils/foodListTile.dart';

// As we have multiple type of food depends of
// type we will have the appropriated fodd section
class FoodSection extends StatefulWidget {
  final Future funct;
  final String kind;
  const FoodSection({Key? key, required this.funct, required this.kind})
      : super(key: key);

  @override
  _FoodSectionState createState() => _FoodSectionState();
}

class _FoodSectionState extends State<FoodSection>
    with AutomaticKeepAliveClientMixin<FoodSection> {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 0, 0, 50),
      child: Container(
        child: FutureBuilder(
            future: widget.funct,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data as List;
                return StreamBuilder(
                    stream: DatabaseService('')
                        .getFoodDataByNameAndKind(widget.kind, data[0]),
                    builder: (context, AsyncSnapshot snap) {
                      switch (snap.connectionState) {
                        case ConnectionState.none:
                          return Text('Connection non établie');
                        case ConnectionState.waiting:
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.orange,
                            ),
                          );
                        default:
                          if (snap.hasError) {
                            return Text(
                                'Erreur: ${snap.error}\n Veuillez signaler ça au gerant de cette application');
                          } else {
                            var list = snap.data as List<OfoodFood>;
                            return ListView.builder(
                                itemCount: list.length,
                                itemBuilder: (context, i) {
                                  return FoodListTile(food: list[i]);
                                });
                          }
                      }
                    });
              } else {
                return CircularProgressIndicator();
              }
            }),
      ),
    );
  }
}
