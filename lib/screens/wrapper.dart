import 'package:flutter/material.dart';
import 'package:iot_parking/middleware.dart';
import 'package:iot_parking/model/CustomUser.dart';
import 'package:iot_parking/screens/authenticate/authenticate.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser>(context); // catching the user passed
    if (user== null){
      return Authenticate();
    } else {
      return Middleware();
    }
  }
}
