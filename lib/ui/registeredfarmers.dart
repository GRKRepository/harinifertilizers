import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harinifertilizers/database/readregisteredfarmers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:harinifertilizers/ui/updatefarmer.dart';
import 'package:harinifertilizers/ui/utilities.dart';

import 'homegrid.dart';

class RegisteredFarmers extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RegisteredFarmersState();
}

class RegisteredFarmersState extends State<RegisteredFarmers> {
  List<Map<String, dynamic>> registeredfarmerslist;

  @override
  void initState() {
    super.initState();
    registeredfarmerslist =
        new ReadRegisteredFarmers().fetchRegisteredFarmers(this, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registered Farmers"),
       // backgroundColor: Colors.blue,
        /*leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => new HomePage()),
            );
          },
        ),*/
      ),
      body: SafeArea(
          child: Scrollbar(
        child: ListView(
            //shrinkWrap: true,
            //scrollDirection: Axis.horizontal,
            children: <Widget>[
              Table(
                columnWidths: {
                  0: FractionColumnWidth(.2),
                  1: FractionColumnWidth(.4),
                  2: FractionColumnWidth(.2)
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                border: TableBorder.all(width: 1.0, color: Colors.grey),
                children: renderTableRows(registeredfarmerslist),
              ),
            ]),
      )),
    );
  }

  renderTableRows(registeredfarmerslist) {
    List<TableRow> rows = new List<TableRow>();
    rows.add(TableRow(children: [
      Column(children: [
        Container(
            decoration: BoxDecoration(color: Colors.lightGreen),
            padding: EdgeInsets.fromLTRB(6.0, 0.0, 0.0, 0.0),
            alignment: Alignment.center,
            child: Text("Surname",
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                )))
      ]),

      Column(children: [
        Container(
            decoration: BoxDecoration(color: Colors.lightGreen),
            padding: EdgeInsets.fromLTRB(6.0, 0.0, 0.0, 0.0),
            alignment: Alignment.center,
            child: Text("Name",
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                )))
      ]),
      Column(children: [
        Container(
            decoration: BoxDecoration(color: Colors.lightGreen),
            padding: EdgeInsets.fromLTRB(6.0, 0.0, 0.0, 0.0),
            alignment: Alignment.center,
            child: Text("Phone No",
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                )))
      ]),
      // you can have more properties of course
    ]));

    int count = 2;
    Color bgColor;
    registeredfarmerslist.forEach((item) => {
          bgColor = (count % 2 == 0)
              ? Colors.white
              : Color.fromRGBO(210, 245, 210, 1.0),
          count++,
          rows.add(TableRow(children: [
            Column(children: [
              Container(
                  decoration: BoxDecoration(color: bgColor),
                  padding: EdgeInsets.fromLTRB(6.0, 0.0, 0.0, 0.0),
                  alignment: Alignment.centerLeft,
                  child: Text(item['surname'],
                      style: TextStyle(
                        fontSize: 18,
                      )))
            ]),
            Column(children: [
              Container(
                  decoration: BoxDecoration(color: bgColor),
                  padding: EdgeInsets.fromLTRB(6.0, 0.0, 0.0, 0.0),
                  alignment: Alignment.centerLeft,
                  child: Text(item['name'],
                      style: TextStyle(
                        fontSize: 18,
                      )))
            ]),
            Column(children: [
              Container(
                  decoration: BoxDecoration(color: bgColor),
                  padding: EdgeInsets.fromLTRB(6.0, 0.0, 0.0, 0.0),
                  alignment: Alignment.centerLeft,
                  child: Text(item['phonenumber'],
                      style: TextStyle(
                        fontSize: 18,
                      )))
            ]),
            // you can have more properties of course
          ]))
        });
    return rows;
  }
}
