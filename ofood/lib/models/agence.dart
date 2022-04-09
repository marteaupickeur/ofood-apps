// The ofood agence model wich is the same form firestore DB
class OfoodAgence {
  final String agenceId;
  final String agenceName;
  final List agenceRestos;

  OfoodAgence(
      {required this.agenceId,
      required this.agenceName,
      required this.agenceRestos});
  @override
  String toString() {
    // TODO: implement toString
    return 'agenceId: $agenceId ,agenceName: $agenceName ,agenceRestos: $agenceRestos';
  }
}
