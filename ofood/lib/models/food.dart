// The ofood food model wich is the same form firestore DB
class OfoodFood {
  final String foodId;
  final String foodName;
  final String foodKind;
  final String foodPrice;
  final String foodResto;

  OfoodFood(
      {required this.foodId,
      required this.foodName,
      required this.foodKind,
      required this.foodPrice,
      required this.foodResto});

  @override
  String toString() {
    // TODO: implement toString
    return foodName;
  }
}
