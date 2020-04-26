import 'package:flutter/material.dart';
import 'package:harinifertilizers/ui/datecomponent.dart';
import 'package:harinifertilizers/ui/dropdowncomponent.dart';
import 'package:harinifertilizers/ui/homegrid.dart';
import 'package:harinifertilizers/ui/login.dart';
import 'package:harinifertilizers/ui/transactionform.dart';

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

