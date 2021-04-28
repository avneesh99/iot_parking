import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iot_parking/screens/authenticate/text_box_decoration.dart';
import 'package:iot_parking/services/auth.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  // Creating this instance because we want to access the signIn function
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>(); // will be used to identify the form
  bool _loading = false;

  // text field state
  bool showRegister = true;
  String email = "";
  String password = "";
  String rsid = "";
  String error = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
        title: Text("Welcome"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 0,horizontal: 50),
            child:  Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Colors.grey,
                    style: TextStyle(color: Colors.white),
                    decoration:TextBoxDecoration(hintText: 'Email'),
                    validator: (val){
                      if (val.isEmpty){
                        return "Enter an Email";
                      } else {
                        return null;
                      }
                    },
                    onChanged: (val){
                      setState(() {
                        email = val;
                      });
                    },
                  ),

                  SizedBox(height: 20),
                  TextFormField(
                    cursorColor: Colors.grey,
                    obscureText: true,
                    style: TextStyle(color: Colors.white),
                    decoration: TextBoxDecoration(hintText: 'Password'),
                    validator: (val){
                      if (val.length <6){
                        return "Enter at least 6 character";
                      } else {
                        return null;
                      }
                    },
                    onChanged: (val){
                      setState(() {
                        password = val;
                      });
                    },
                  ),

                  showRegister ? SizedBox(height: 20) : Container(),
                  showRegister ? TextFormField(
                    cursorColor: Colors.grey,
                    obscureText: true,
                    style: TextStyle(color: Colors.white),
                    decoration: TextBoxDecoration(hintText: 'rsid'),
                    validator: (val){
                      if (val.length <6){
                        return "Enter at least 6 character";
                      } else {
                        return null;
                      }
                    },
                    onChanged: (val){
                      setState(() {
                        rsid = val;
                      });
                    },
                  ) : Container(),

                  SizedBox(height: 20),
                  FlatButton(
                    color: Colors.white,
                    child: Text(
                        showRegister ? 'Register' : 'Sign In'
                    ),
                    onPressed: () async {
                      print("clicked");
                      if (_formKey.currentState.validate()){
                        setState(() {
                          _loading = true;
                        });

                        if (showRegister){
                          print("register clicked");
                          dynamic result = await _auth.registerWithEmailAndPassword(email, password, rsid);
                          print("Auth done");
                          if (result == null){
                            setState(() {
                              _loading =false;
                              error = "Couldn't register with those credentials";
                            });
                          }
                        } else {
                          dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                          if (result == null){
                            setState(() {
                              _loading =false;
                              error = "Couldn't sign in with those credentials";
                            });
                          }
                        }
                      }
                    }
                  ),
                  SizedBox(height: 12),
                  Text(
                    error,
                    style: TextStyle(
                        color: Colors.red
                    ),
                  ),

                  SizedBox(height: 12),
                  InkWell(
                    onTap: () {
                      setState(() {
                        showRegister = !showRegister;
                      });
                    },
                    child: Text(
                      showRegister ? "I want to sign in" : "I want to register",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
