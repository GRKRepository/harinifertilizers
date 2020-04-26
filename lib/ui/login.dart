import 'package:flutter/material.dart';
import 'package:harinifertilizers/ui/utilities.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'homegrid.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  ProgressDialog progressdialog;
  final loginFormKey = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    progressdialog = Utilities.renderProgressDial(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Login Page",
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(15.0),
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
              key: loginFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                      controller: userNameController,
                      decoration: InputDecoration(
                          hintText: 'username',
                          suffixIcon: const Icon(Icons.person, size: 30.0)),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'Please enter user name';
                        }
                        return null;
                      }),
                  TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                          hintText: 'password',
                          suffixIcon: const Icon(Icons.fingerprint, size: 30.0)),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'Please enter password';
                        }
                        return null;
                      }),
                  Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                      child: renderLoginButton()),
                ],
              ),
            )),
      ),
    );
  }

  renderLoginButton() {
    return new RaisedButton.icon(
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0),
            side: BorderSide(color: Colors.blue)),
        icon: Icon(
          Icons.add_to_home_screen,
          size: 30.0,
        ),
        label: const Text('Login'),
        color: Theme.of(context).primaryColorDark,
        textColor: Theme.of(context).primaryColorLight,
        onPressed: () {
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (context) => new HomePage(),
              maintainState: true));
        });
  }

}