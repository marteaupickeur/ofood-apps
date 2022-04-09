// The ofood resto model wich is the same form firestore DB

class OfoodResto {
  final String restoId;
  final String restoName;
  final List restoKind;
  final List restoMenu;
  final bool restoDelivry;

  OfoodResto(
      {required this.restoId,
      required this.restoName,
      required this.restoDelivry,
      required this.restoKind,
      required this.restoMenu});

  @override
  String toString() {
    // TODO: implement toString
    return 'restoId: $restoId, restoName: $restoName, restoKind: $restoKind, restoMenu: $restoMenu';
  }
}
