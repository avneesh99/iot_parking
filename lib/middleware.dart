import 'package:flutter/material.dart';
import 'package:iot_parking/screens/home/home.dart';
import 'package:provider/provider.dart';

import 'model/CustomUser.dart';
import 'services/DatabaseService.dart';

class Middleware extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser>(context);
    return StreamProvider<UserDetails>.value(
      value: DatabaseService(uid: user.uid).userDetails,
      child: StreamBuilder<UserDetails>(
          stream: DatabaseService(uid: user.uid).userDetails,
          builder: (context, snapshot) {
            if (!snapshot.hasError){
              switch (snapshot.connectionState){
                case ConnectionState.none:
                  return MaterialApp(home: Scaffold(backgroundColor: Colors.black,));
                case ConnectionState.waiting:
                  return MaterialApp(home: Scaffold(backgroundColor: Colors.black,));
                default:
                  return MaterialApp(
                    home: Home(),
                  );
              }
            } else {
              return MaterialApp(home: Scaffold(backgroundColor: Colors.black,));
            }
          }
      ),
    );
  }
}