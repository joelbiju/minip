import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timetablr/core/constants.dart';
import 'package:timetablr/domain/class/department_repo.dart';
import 'package:timetablr/domain/login/model/user_model.dart';

class AuthService {
  Future<Either<String, void>> loginUser(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userId = userCredential.user!.uid;
      final _u = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      final u = _u.data();
      final user = UserModel.instance
          .getValues(email: email, username: u!['username'], userId: userId);

      final sharedpref = await SharedPreferences.getInstance();

      sharedpref.setString(userSharedPreferencesKey, user.toJson().toString());
      await DepartmentRepo.instance.getDepartments();
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      } else {
        message = 'Error: ${e.message}';
      }
      return Left(message);
    } catch (e) {
      return Left('Error: $e');
    }
  }

  Future<Either<String, void>> signUpWithEmailPasswordAndUsername(
      String email, String password, String username) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userId = userCredential.user!.uid;
      final user = UserModel.instance
          .getValues(email: email, username: username, userId: userId);

      final sharedpref = await SharedPreferences.getInstance();

      sharedpref.setString(userSharedPreferencesKey, user.toJson());

      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'email': email,
        'username': username,
      });
      await DepartmentRepo.instance.getDepartments();
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      } else {
        message = 'An error occurred while creating the account: ${e.message}';
      }
      Left(message);
    }
    return Left('An error occurred while creating the account');
  }

  signout() async {
    final sharedpref = await SharedPreferences.getInstance();
    sharedpref.remove(userSharedPreferencesKey);
    await FirebaseAuth.instance.signOut();
  }
}
