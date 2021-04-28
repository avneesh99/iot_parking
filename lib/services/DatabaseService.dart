import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iot_parking/model/CustomUser.dart';
import 'package:iot_parking/model/Parking.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  final CollectionReference userDetailsCollection = FirebaseFirestore.instance.collection('UserDetails');
  final CollectionReference parkingCollection = FirebaseFirestore.instance.collection('Parking');

  // function to convert user details from stream to UserDetails
  UserDetails _userDetailsFromFirebase(DocumentSnapshot snapshot){
    print(snapshot.data());
    return UserDetails(
        snapshot.data()['username'],
        uid,
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

  Future setParking({String parkingID, String rsid, int durationInMilliseconds}) async {
    try {
      int time = DateTime.now().millisecondsSinceEpoch;
      await parkingCollection.doc(parkingID).set({
        "parkingID":parkingID,
        "rsid": rsid,
        "startTime": time,
        "tillPaidTime": time + durationInMilliseconds
      });
      return true;
    }
    catch(err) {
      return false;
    }
  }

  List<Parking> _convertToParkingList(QuerySnapshot querySnapshot) {
    List<Parking> parkingSpots = new List<Parking>();
    querySnapshot.docs.forEach((element) {
      parkingSpots.add(_convertToParking(element));
    });
    print("**************");
    print(parkingSpots);
    print("**************");
    return parkingSpots;
  }
  // function to convert user details from stream to UserDetails
  Parking _convertToParking(DocumentSnapshot snapshot){
    return Parking(
        parkingID:snapshot.data()['parkingID'],
        rsid:snapshot.data()['rsid'],
        startTime:snapshot.data()['startTime'],
        tillPaidTime:snapshot.data()['tillPaidTime'],
    );
  }

  // stream to get user data
  Stream<List<Parking>> get parkingDetails{
    parkingCollection.snapshots().listen((QuerySnapshot querySnapshot) {
    });
    return parkingCollection.snapshots().map((event) => _convertToParkingList(event));
  }

}