import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Server {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<String?> signIn({String? Email, String? Password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: Email!, password: Password!);
      return 'sign in successfully';
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> signUp({String? Email, String? Password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: Email!, password: Password!);
      return 'sign up successfully';
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> deleteUser() async {
    try {
      var userEmail = _firebaseAuth.currentUser!.email;
      DocumentReference firestore = FirebaseFirestore.instance.collection(
          'Host4Me').doc(userEmail);
      if (firestore != null) {
        firestore.delete();
      }
      await _firebaseAuth.currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  void setUserInfo(Map Info) {
    var userEmail = _firebaseAuth.currentUser!.email;
    DocumentReference firestore = FirebaseFirestore.instance.collection(
        'Host4Me').doc(userEmail);
    firestore.set(Info);
  }

  Future<DocumentSnapshot<Object?>>? getUserInfo() {
    var userEmail = _firebaseAuth.currentUser!.email;
    DocumentReference firestore = FirebaseFirestore.instance.collection(
        'Host4Me').doc(userEmail);
    if (firestore == null) {
      return null;
    }
    var info = firestore.get();
    return info;
  }

  Future<QuerySnapshot<Object?>>? getUsers() {
    CollectionReference ref = FirebaseFirestore.instance.collection('Host4Me');
    if (ref == null) {
      return null;
    }
    var collection = ref.get();
    return collection;
  }
}

