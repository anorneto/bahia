import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bahia_app/ui/router.dart';
import 'package:bahia_app/services/login_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginProvider>(
      create: (_) => LoginProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bahia App',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          /* scaffoldBackgroundColor: AppColors.homeBackgroundColor,
          appBarTheme: AppBarTheme(
            elevation: 0.0,
            color: AppColors.detailsScreensBackground,
            iconTheme: IconThemeData(color: AppColors.defaultGrey, size: 32, opacity: 1),
            textTheme: TextTheme(
              title: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.defaultGrey,
              ),
            ),
          ), */
          textTheme: TextTheme(
            title: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            display1: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
            ),
            body1: TextStyle(
              fontSize: 18.5,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
            body2: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
            headline: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
            subhead: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w300,
              color: Colors.grey.withOpacity(0.95),
            ),
          ),
          iconTheme: IconThemeData(size: 32.0, color: Colors.black),
        ),
        onGenerateRoute: Router.generateRoute,
        initialRoute: loginRoute,
      ),
    );
  }
}
