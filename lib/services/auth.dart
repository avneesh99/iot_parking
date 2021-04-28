import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iot_parking/model/CustomUser.dart';
import 'package:iot_parking/services/DatabaseService.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CustomUser _userFromFirebaseUser(User user) {
    print("userFromFirebaseUser: ");
    print(user);
    return user != null ? CustomUser(user.uid) : null;
  }

  // auth change user stream
  // so this stream will return us FirebaseUser when there is change in auth
  // but we use <User> because we r converting Firebase user to our custom User
  Stream<CustomUser> get user {
    return _auth.authStateChanges()
        .map(_userFromFirebaseUser);
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      User user= (await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      )).user;
      return _userFromFirebaseUser(user);
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  //register with email and password
  Future registerWithEmailAndPassword(String email, String password, String rsid) async {
    try {
      print("Register hit");
      User user= (await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      )).user;
      print("user created");

      //create a new document for the user with uid
      await DatabaseService(uid:user.uid).setUserDetails(
          username: email,
          rsid: rsid
      );

      return _userFromFirebaseUser(user);
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

}