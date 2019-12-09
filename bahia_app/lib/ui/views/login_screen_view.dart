import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bahia_app/services/login_provider.dart';
import 'package:bahia_app/ui/router.dart';

class LoginScreenView extends StatefulWidget {
  @override
  _LoginScreenViewState createState() => _LoginScreenViewState();
}

class _LoginScreenViewState extends State<LoginScreenView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(builder: (context, loginProvider, _) {
      return Scaffold(
        body: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                    image: AssetImage("assets/bahia_logo.png"),
                    fit: BoxFit.contain,
                    height: 80.0),
                SizedBox(height: 70),
                SingInButton(
                  onPressed: () {
                    loginProvider.signInWithGoogle().then(
                      (user) {
                        Navigator.of(context).pushNamed(homeRoute, arguments: "Logado pelo Google :  ${user.email}");
                      },
                      onError: (error) {
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Erro ao logar : $error}'),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class SingInButton extends StatelessWidget {
  final void Function() onPressed;
  const SingInButton({Key key, @required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: onPressed,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
      highlightElevation: 10,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/google_logo.png"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Entrar com Google',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
