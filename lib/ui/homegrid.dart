import 'package:flutter/material.dart';
import 'package:harinifertilizers/ui/bills.dart';
import 'package:harinifertilizers/ui/billsummary.dart';
import 'package:harinifertilizers/ui/login.dart';
import 'package:harinifertilizers/ui/registeredfarmers.dart';
import 'package:harinifertilizers/ui/registerform.dart';
import 'package:harinifertilizers/ui/report.dart';
import 'package:harinifertilizers/ui/addbill.dart';

import 'billsearch.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Harini Fertilizers'),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) => new LoginPage(),
                      maintainState: true));
                },
                child: Icon(
                  Icons.power_settings_new,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: new GridView.count(crossAxisCount: 2, children: <Widget>[
        new GridTile(
            child: new InkResponse(
          enableFeedback: true,
          child: new Center(
            child: Image(
                image: AssetImage('fertilizersassets/register.png'),
                width: 150,
                height: 150),
          ),
          onTap: () => {
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) => new RegisterForm(), maintainState: true))
          },
        )),
        new GridTile(
            child: new InkResponse(
          enableFeedback: true,
          child: new Center(
            child: Image(
                image: AssetImage('fertilizersassets/farmers.png'),
                width: 150,
                height: 150),
          ),
          onTap: () => {
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) => new RegisteredFarmers(),
                maintainState: true))
          },
        )),
        new GridTile(
            child: new InkResponse(
          enableFeedback: true,
          child: new Center(
            child: Image(
                image: AssetImage('fertilizersassets/addrecord.png'),
                width: 150,
                height: 150),
          ),
          onTap: () => {
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) => new AddBill(), maintainState: true))
          },
        )),
        new GridTile(
            child: new InkResponse(
          enableFeedback: true,
          child: new Center(
            child: Image(
                image: AssetImage('fertilizersassets/bills.png'),
                width: 150,
                height: 150),
          ),
          onTap: () => {
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) => new BillSearch(), maintainState: true))
          },
        )),
        new GridTile(
            child: new InkResponse(
          enableFeedback: true,
          child: new Center(
            child: Image(
                image: AssetImage('fertilizersassets/summary.png'),
                width: 150,
                height: 150),
          ),
          onTap: () => {
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) => new BillSummary(), maintainState: true))
          },
        )),
        new GridTile(
            child: new InkResponse(
          enableFeedback: true,
          child: new Center(
            child: Image(
                image: AssetImage('fertilizersassets/print.png'),
                width: 150,
                height: 150),
          ),
          onTap: () => {
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) => new Report(), maintainState: true))
          },
        ))
      ]),
    );
  }
}
