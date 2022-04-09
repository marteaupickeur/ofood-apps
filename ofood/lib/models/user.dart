// the User model in firebase auth
class AppUser {
  final String userId;
  final String userName;
  final String userPhoneNumber;

  AppUser(
      {required this.userId, this.userName = '', this.userPhoneNumber = ''});

  @override
  String toString() {
    // TODO: implement toString
    return 'userId: $userId,userName: $userName, userPhoneNumber: $userPhoneNumber';
  }
}
