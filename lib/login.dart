import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:lost_and_found/blocks/auth_bloc.dart';
import 'package:lost_and_found/homePage.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    var authBloc = Provider.of<AuthBloc>(context, listen: false);
    authBloc.currentUser.listen((fbUser) {
      if (fbUser != null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => MyHomePage(fbUser.displayName)));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            Image(image: AssetImage('assets/logo.png')),
            Text('The #1 app to find your lost items!'),
            SizedBox(
              height: 180,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SignInButton(
                  Buttons.Google,
                  onPressed: () => authBloc.loginGoogle(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
