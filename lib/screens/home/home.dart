import 'package:flutter/material.dart';
import 'package:iot_parking/model/CustomUser.dart';
import 'package:iot_parking/model/Parking.dart';
import 'package:iot_parking/services/DatabaseService.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream<List<Parking>> _parkingStream;
  final _databaseService = DatabaseService();
  @override
  void initState() {
    super.initState();
    _parkingStream = DatabaseService().parkingDetails;
  }

  @override
  Widget build(BuildContext context) {
    final userDetails = Provider.of<UserDetails>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text("PARKING IOT APP"),
      ),
      body: userDetails == null ? Container(): 
      StreamBuilder<List<Parking>>(
        stream: _parkingStream,
        builder: (context, snapshot) {
          return Container(
            child: Column(
              children: [
                ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index)  {
                      Parking spot = snapshot.data[index];
                      return InkWell(
                        onTap: () {
                          if (spot.rsid == null) {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) => PayBottomSheet(
                                  amountToPay:null,duration:null,
                                  parkingID: spot.parkingID,
                                  databaseService: _databaseService,
                                  uid: userDetails.uid,
                                )
                            );
                          } else if (spot.rsid == userDetails.rsid) {
                            if (spot.tillPaidTime >= DateTime.now().millisecondsSinceEpoch) {
                              _databaseService.setParking(parkingID:spot.parkingID, uid:null, durationInMilliseconds: 0,);
                            } else {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) => PayBottomSheet(
                                      amountToPay: 100,duration: DateTime.now().millisecondsSinceEpoch - spot.tillPaidTime,
                                      parkingID: spot.parkingID,
                                      databaseService: _databaseService,
                                      uid: null
                                    )
                                );
                            }
                          }
                        },
                        child: ListTile(
                          title: Text(spot.parkingID),
                          tileColor: spot.rsid == null ? Colors.green : Colors.red,
                        ),
                      );
                    }
                ),
                FlatButton(
                  color: Colors.white,
                  child: Text("CLICK"),
                  onPressed: () async {
                    _databaseService.setParking(
                        parkingID:"parking_three",
                        uid:null,
                        durationInMilliseconds: 1000
                    );
                  },
                ),
              ],
            )
          );
        }
      )
    );
  }
}


class PayBottomSheet extends StatelessWidget {
  final int amountToPay;
  final int duration;
  final String parkingID;
  final DatabaseService databaseService;
  final String uid;
  PayBottomSheet({this.amountToPay, this.duration, this.parkingID, this.databaseService, this.uid});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2*MediaQuery.of(context).size.height/3,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
              "Confirm booking parking slot : $parkingID for ${duration / (1000 * 60 * 60)} hours"
          ),
          FlatButton(
              onPressed: () async{
                await databaseService.setParking(parkingID:parkingID, uid:uid, durationInMilliseconds: duration,);
                Navigator.pop(context);
              },
              color: Colors.green,
              child: Text("PAY Rs. $amountToPay")
          )
        ],
      ),
    );
  }
}
