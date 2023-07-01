import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'firebase_options.dart';
// import url_launcher
import 'package:url_launcher/url_launcher.dart';
// import firestore
import 'package:cloud_firestore/cloud_firestore.dart';

// import firebase auth

// ...

class ApiInit {
  static Future init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  Future<User?> getCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    }
    return user;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<User?> signIn(String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        return null;
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        return null;
      }
    }
  }

  Future<void> deleteEventForUser(String id) async {
    User? user = await getCurrentUser();
    print(user);

    if (user != null) {
      var res = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('events')
          .doc(id)
          .delete();
    }
  }

  Future<User?> signUp(String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final sendMail = await userCredential.user?.sendEmailVerification();
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        return null;
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future addEventForUser(DateTime startDate, DateTime endDate) async {
    User? user = await getCurrentUser();
    print(user);

    if (user != null) {
      var res = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('events')
          .add({
        'startDate': startDate,
        'endDate': endDate,
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
      });

      print(res);
    }
  }

  Future<void> updateEventForUser(
      String id, DateTime startDate, DateTime endDate) async {
    User? user = await getCurrentUser();
    print(user);

    if (user != null) {
      var res = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('events')
          .doc(id)
          .update({
        'startDate': startDate,
        'endDate': endDate,
        'updatedAt': DateTime.now(),
      });
      return res;
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>?> getEventsForUser() async {
    User? user = await getCurrentUser();
    print(user);

    if (user != null) {
      var res = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('events')
          .get();

      print(res);
      return res;
    }
    return null;
  }

  Future<QuerySnapshot<Map<String, dynamic>>?> getEventsForUserByDate(
      DateTimeRange? date) async {
    User? user = await getCurrentUser();
    print(user);

    if (user != null && date != null) {
      print(date.start);
      print(date.end);
      var res = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('events')
          .orderBy('startDate', descending: false)
          .where('startDate', isGreaterThanOrEqualTo: date.start)

          // .where('endDate', isLessThanOrEqualTo: date.end)
          // .where('startDate', isGreaterThanOrEqualTo: date.start)
          // .where('endDate', isLessThanOrEqualTo: date.end)
          .get();

      return res;
    }
    return null;
  }
  // verif session token with the date of the last login
}

class Nav {
  static NavToRoute(BuildContext context) {}
}
