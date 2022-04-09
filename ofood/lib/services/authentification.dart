import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ofood/models/user.dart';
import 'package:ofood/services/database.dart';

class AuthenticationService {
  // the firebase instance for authentication
  FirebaseAuth auth = FirebaseAuth.instance;

  // transform user to userFormFireBase locally
  // take some strings on parameter
  AppUser? userFromDatabase(User? user, String? name, String? number) {
    if (user == null || name == null || number == null) {
      return null;
    }
    return AppUser(userId: user.uid, userName: name, userPhoneNumber: number);
  }

  // give the current user if connected or not
  AppUser? userFromFireBaseAuth(User? user) {
    if (user == null) {
      return null;
    }

    return AppUser(userId: user.uid);
  }

  // Creation of Stream to load data all along the app
  // do the real connection before to signIn or signUp its null
  // as the the app is wrap with this stream on authStateChanges
  // the user id is provides
  Future<Stream> getUser() async {
    return auth.authStateChanges().map(userFromFireBaseAuth);
  }

  Future registerWithEmailAndPassword(
      String name, String number, String email, String password) async {
    try {
      UserCredential result = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      // recover only user in result
      User? user = result.user;
      // create at the same time the user on database
      DatabaseService('no_userId_from_now')
          .saveUser(userFromDatabase(user, name, number));
      return userFromFireBaseAuth(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'weak';
      }
      if (e.code == 'email-already-in-use') {
        return 'already';
      }
    } catch (e) {
      return '$e';
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return userFromFireBaseAuth(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'not_found';
      }
      if (e.code == 'wrong-password') {
        return 'wrong_password';
      }
    } catch (e) {
      return '$e';
    }
  }

  Future signOut() async {
    try {
      return await auth.signOut();
    } catch (e) {
      return '$e';
    }
  }
}
