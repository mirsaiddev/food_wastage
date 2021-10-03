import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_wastage/services/firestore_service.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<String> checkRole() async {
    User? _user = _auth.currentUser;
    if (_user != null) {
      String role = await FirestoreService().getCurrentUsersRole();
      return role;
    } else {
      return 'error';
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<String?> signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return "Signed in";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> signUp({required String email, required String password, required String username}) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await FirestoreService().saveNewUserData(user: _auth.currentUser!, username: username);
      return "Signed up";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> sendPasswordResetMail() async {
    User? _user = _auth.currentUser;
    await _auth.sendPasswordResetEmail(email: _user!.email!);
  }
}
