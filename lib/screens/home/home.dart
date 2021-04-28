import 'package:flutter/material.dart';
import 'package:iot_parking/model/CustomUser.dart';
import 'package:iot_parking/model/Parking.dart';
import 'package:iot_parking/services/DatabaseService.dart';
import 'package:iot_parking/services/auth.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream<List<Parking>> _parkingStream;
  final _databaseService = DatabaseService();
  final AuthService _auth = AuthService();
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
          if (snapshot.hasData && snapshot.data != null) {
            print("***********");
            print(snapshot.data.length);
            print("***********");
            return Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height:200,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
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
                                        rsid: userDetails.rsid,
                                        isSet: false,
                                      )
                                  );
                                } else if (spot.rsid == userDetails.rsid) {
                                  if (spot.tillPaidTime >= DateTime.now().millisecondsSinceEpoch) {
                                    _databaseService.setParking(parkingID:spot.parkingID,rsid:null, durationInMilliseconds: 0,);
                                  } else {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (context) => PayBottomSheet(
                                            amountToPay: 100,duration: DateTime.now().millisecondsSinceEpoch - spot.tillPaidTime,
                                            parkingID: spot.parkingID,
                                            databaseService: _databaseService,
                                            rsid: null,
                                            isSet: true,
                                        )
                                    );
                                  }
                                }
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                height: 30,
                                width: 80,
                                child: Center(child: Text(spot.parkingID,style: TextStyle(color: Colors.white, fontSize: 15),)),
                                color: spot.rsid == null ? Colors.green : Colors.red,
                              ),
                            );
                          }
                      ),
                    ),
                    FlatButton(
                      color: Colors.white,
                      child: Text("CLICK"),
                      onPressed: () async {
                        _auth.signOut();
                      },
                    ),
                  ],
                )
            );
          } else {
            return Container();
          }

        }
      )
    );
  }
}


class PayBottomSheet extends StatefulWidget {
  final bool isSet;
  final int amountToPay;
  final int duration;
  final String parkingID;
  final DatabaseService databaseService;
  final String rsid;
  PayBottomSheet({this.amountToPay, this.duration, this.parkingID, this.databaseService, this.rsid, this.isSet});

  @override
  _PayBottomSheetState createState() => _PayBottomSheetState();
}

class _PayBottomSheetState extends State<PayBottomSheet> {
  int value = 0;
  int amount = 0;
  @override
  void initState() {
    super.initState();
    if (widget.duration != null) {
      setState(() {
        value = widget.duration ;
        amount = widget.amountToPay;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2*MediaQuery.of(context).size.height/3,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          widget.isSet ? Container() : TextField(
            keyboardType: TextInputType.number,
            onChanged: (val) {
              setState(() {
                value = int.parse(val) * (1000 * 60 * 60);
                amount = int.parse(val) * 100;
              });
            },
          ),
          value == 0? Container() : Text("Confirm booking parking slot : ${widget.parkingID} for ${value / (1000 * 60 * 60)} hours"),
          value == 0? Container() : FlatButton(
              onPressed: () async{
                await widget.databaseService.setParking(parkingID:widget.parkingID, rsid:widget.rsid, durationInMilliseconds: value,);
                Navigator.pop(context);
              },
              color: Colors.green,
              child: Text("PAY Rs. $amount")
          )
        ],
      ),
    );
  }
}
