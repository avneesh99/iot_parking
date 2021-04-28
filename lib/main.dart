import 'package:flutter/material.dart';
import 'package:iot_parking/screens/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:iot_parking/services/auth.dart';

import 'model/CustomUser.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Stream<CustomUser> _streamUser;
  @override
  void initState() {
    super.initState();
    _streamUser = AuthService().user;
  }
  @override
  Widget build(BuildContext context) {
    return StreamProvider<CustomUser>.value(
      value:_streamUser,
      child: StreamBuilder<CustomUser>(
        stream: _streamUser,
        builder: (context, snapshot) {
          if (!snapshot.hasError) {
            switch (snapshot.connectionState){
              case ConnectionState.none:
                return MaterialApp(home: Scaffold(backgroundColor: Colors.black,));
              case ConnectionState.waiting:
                return MaterialApp(home: Scaffold(backgroundColor: Colors.black,));
              default:
                return MaterialApp(
                  home: Wrapper(),
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

