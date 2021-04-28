import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iot_parking/model/CustomUser.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  final CollectionReference userDetailsCollection = FirebaseFirestore.instance.collection('UserDetails');

  // function to convert user details from stream to UserDetails
  UserDetails _userDetailsFromFirebase(DocumentSnapshot snapshot){
    return UserDetails(
        uid,
        snapshot.data()['username'],
        snapshot.data()['rsid']
    );
  }

  // stream to get user data
  Stream<UserDetails> get userDetails {
    return userDetailsCollection.doc(uid).snapshots()
        .map(_userDetailsFromFirebase);
  }

  // Only to be used for initialisation in auth.dart
  Future setUserDetails({String username, String rsid}) async{
    try {
      await userDetailsCollection.doc(uid).set({
        "username":username,
        "rsid":rsid
      });
      print("user details set");
      return true;
    }
    catch(err){
      return false;
    }
  }

}