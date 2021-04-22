import 'package:flutter/material.dart';
import 'package:petra/screens/HomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Petra",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFFef7883),
        canvasColor: Colors.transparent,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        backgroundColor: Color(0xFFfff5f3),
        buttonColor: Color(0xFFef7883),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFfff5f3),
          elevation: 0,
          iconTheme: IconThemeData(
            color: Color(0xFFef7883),
            size: 14.0,
          ),
          titleTextStyle: TextStyle(
            color: Color(0xFFef7883),
            fontSize: 16.0,
          ),
          centerTitle: true,
        ),
        textTheme: TextTheme(
          bodyText2: TextStyle(
            color: Color(0xFFef7883),
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
          bodyText1: TextStyle(
            color: Color(0xFF0D0C22).withOpacity(0.7),
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
          ),
          headline6: TextStyle(
            color: Color(0xFF0D0C22),
            fontWeight: FontWeight.bold,
            fontSize: 15.0,
            letterSpacing: 0.3,
          ),
          headline5: TextStyle(
            color: Color(0xFFef7883),
            fontWeight: FontWeight.bold,
            fontSize: 22.0,
            letterSpacing: 0.3,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            elevation: MaterialStateProperty.resolveWith<double>(
                (Set<MaterialState> states) {
              return 10.0;
            }),
            shadowColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              return Color(0xFFef7883).withOpacity(0.3);
            }),
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed))
                  return Color(0xFFef7883).withOpacity(0.8);
                return Color(0xFFef7883);
              },
            ),
            foregroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                return Color(0xFFfff5f3);
              },
            ),
            textStyle: MaterialStateProperty.resolveWith<TextStyle>(
              (Set<MaterialState> states) {
                return TextStyle(
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                );
              },
            ),
            minimumSize: MaterialStateProperty.resolveWith<Size>(
              (Set<MaterialState> states) {
                return Size(160.0, 36.0);
              },
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                return Color(0xFFef7883);
              },
            ),
            textStyle: MaterialStateProperty.resolveWith<TextStyle>(
              (Set<MaterialState> states) {
                return TextStyle(
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                );
              },
            ),
            side: MaterialStateProperty.resolveWith<BorderSide>(
              (Set<MaterialState> states) {
                return BorderSide(
                  color: Color(0xFFef7883),
                );
              },
            ),
            minimumSize: MaterialStateProperty.resolveWith<Size>(
              (Set<MaterialState> states) {
                return Size(160.0, 36.0);
              },
            ),
          ),
        ),
      ),
      home: Homepage(),
    );
  }
}
