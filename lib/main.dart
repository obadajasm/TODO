import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/provider/auth.dart';
import 'package:todo/provider/task.dart';
import 'package:todo/provider/theme.dart';
import 'package:todo/screens/auth_screen.dart';
import 'package:todo/screens/home_screen.dart';
import 'package:todo/sharedpref.dart';

Future<void> main() async {
  // if your flutter > 1.7.8 :  ensure flutter activated
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefUtil.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of(context);
    return MaterialApp(
      title: 'todo Demo',
      // set the theme depneding on last user choice
      theme: themeProvider.currentThemeData,
      // if user allready signed in
      //redirect to homeScreen
      home: SharedPrefUtil.getInstance().getData('userid').isEmpty
          ? AuthScreen()
          : MyHomePage(),
      // defiens the named routes

      routes: {
        MyHomePage.ROUTE_NAME: (ctx) => MyHomePage(),
        AuthScreen.ROUTE_NAME: (ctx) => AuthScreen(),
      },
    );
  }
}
