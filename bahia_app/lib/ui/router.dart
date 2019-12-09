import 'package:flutter/material.dart';

import 'package:bahia_app/ui/views/login_screen_view.dart';
import 'package:bahia_app/ui/views/home_screen_view.dart';

const String homeRoute = '/';
const String loginRoute = 'login';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
      var scaffoldText = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => HomeScreenView(scaffoldText: scaffoldText));
      case loginRoute:
        return MaterialPageRoute(builder: (_) => LoginScreenView());
      default:
        return MaterialPageRoute(
          builder: (_) {
            return Scaffold(
              body: Center(
                child: Text('BUG: Rota não definida para ${settings.name}'),
              ),
            );
          },
        );
    }
  }
}
