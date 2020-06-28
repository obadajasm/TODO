import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:todo/provider/auth.dart';
import 'package:todo/screens/home_screen.dart';

class AuthScreen extends StatefulWidget {
  static const String ROUTE_NAME = 'auth';

  AuthScreen({Key key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthProvider _authprovider;
  String userid = '';
  @override
  void didChangeDependencies() {
    _authprovider = Provider.of<AuthProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  void navigateAfterAuth() {
    if (userid?.isNotEmpty ?? false) {
      Navigator.of(context).pushReplacementNamed(MyHomePage.ROUTE_NAME);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome to our APP \n',
                      style: TextStyle(fontSize: 30),
                    ),
                    Text(
                      'join us now ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, letterSpacing: 5),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    FlatButton(
                      onPressed: () async {
                        userid = await _authprovider.signInWithGoogle();
                        navigateAfterAuth();
                      },
                      child: Image.asset('images/google.png',
                          width: 300, height: 100),
                    ),
                    FlatButton(
                      onPressed: () async {
                        userid = await _authprovider.signInWithFacebook();
                        navigateAfterAuth();
                      },
                      child: Image.asset(
                        'images/fac.png',
                        width: 300,
                        height: 100,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
