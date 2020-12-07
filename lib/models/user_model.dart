import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {
  FirebaseAuth _auth = FirebaseAuth.instance;

  UserCredential firebaseUser;

  Map<String, dynamic> userData = Map();

  bool isLoading = false;

  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);

    _loadCurrentUser();
  }

  void sigUp({
    @required Map<String, dynamic> userData,
    @required String pass,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
  }) {
    isLoading = true;
    notifyListeners();

    _auth
        .createUserWithEmailAndPassword(
      email: userData['email'],
      password: pass,
    )
        .then((user) async {
      firebaseUser = user;

      await _saveUserData(userData);

      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((e) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  void sigIn({
    @required String email,
    @required String pass,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
  }) async {
    isLoading = true;
    notifyListeners();

    _auth
        .signInWithEmailAndPassword(email: email, password: pass)
        .then((user) async {
      firebaseUser = user;

      await _loadCurrentUser();

      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((e) {
      onFail();
      isLoading = false;
      notifyListeners();
    });

    isLoading = false;
    notifyListeners();
  }

  void recoverPass(String email) {
    _auth.sendPasswordResetEmail(email: email);
  }

  void signOut() async {
    await _auth.signOut();

    userData = Map();
    firebaseUser = null;

    notifyListeners();
  }

  bool isLoggedIn() {
    return firebaseUser != null;
  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseUser.user.uid)
        .set(userData);
  }

  Future<Null> _loadCurrentUser() async {
    if (firebaseUser == null) {
      firebaseUser = _auth.currentUser as UserCredential;
    }
    if (firebaseUser != null) {
      if (userData['name'] == null) {
        DocumentSnapshot docUser = await FirebaseFirestore.instance
            .collection("users")
            .doc(firebaseUser.user.uid)
            .get();
        userData = docUser.data();
      }
    }
    notifyListeners();
  }
}
