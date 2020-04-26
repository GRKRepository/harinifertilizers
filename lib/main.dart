import 'package:flutter/material.dart';
import 'package:harinifertilizers/ui/login.dart';

void main(){
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Harini Fertilizers",
    theme: new ThemeData(
      fontFamily: 'Quicksand',
      primarySwatch: Colors.lightGreen,
    ),
    home: new LoginPage(),
  ));
}

