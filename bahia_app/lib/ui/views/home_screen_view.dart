import 'dart:async';
import 'package:bahia_app/ui/router.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:json_table/json_table.dart';

import 'package:bahia_app/services/login_provider.dart';
import 'package:bahia_app/ui/viewmodels/base_viewmodel.dart';
import 'package:bahia_app/ui/viewmodels/home_viewmodel.dart';

class HomeScreenView extends StatelessWidget {
  final String scaffoldText;
  HomeScreenView({@required this.scaffoldText}) {
    scheduleMicrotask(() => _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(
          scaffoldText,
          style: TextStyle(fontSize: 16),
        ))));
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = Provider.of<LoginProvider>(context);
    GoogleSignInAccount user = loginProvider.getLoggedUser();
    return ChangeNotifierProvider<HomeViewModel>(
      create: (_) => HomeViewModel(),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Bahia App - Desafio Anor'),
        ),
        drawer: Drawer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.red[600]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Image.network(user.photoUrl),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      user.displayName,
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      user.email,
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: OutlineButton(
                  onPressed: () {
                    loginProvider.signOutGoogle();
                    Navigator.pushReplacementNamed(context, loginRoute);
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80)),
                  highlightElevation: 10,
                  borderSide: BorderSide(color: Colors.grey),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Text(
                      'Deslogar',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ReportSelector(),
              Selector<HomeViewModel, dynamic>(
                selector: (_, _state) => _state.reportTable,
                builder: (context, reportTable, _) {
                  if (reportTable == null)
                    return Padding(
                      padding: const EdgeInsets.only(top: 80),
                      child: Center(
                        child: Text(
                            'Selecione uma Planilha acima para visualiza-lá', textAlign: TextAlign.center,),
                      ),
                    );
                  else if (reportTable == 'LOADING')
                    return Padding(
                        padding: const EdgeInsets.only(top: 80),
                        child: Center(child: CircularProgressIndicator()));
                  else if (reportTable == 'NOTFOUND')
                    return Padding(
                      padding: const EdgeInsets.only(top: 80),
                      child: Center(
                        child: Text('Planilha não encontrada, atualize a lista de planilhas', textAlign: TextAlign.center,),
                      ),
                    );
                  else
                    return Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: JsonTable(
                        reportTable['root']['row'],
                        showColumnToggle: true,
                        allowRowHighlight: true,
                        rowHighlightColor: Colors.yellow[500].withOpacity(0.7),
                        tableHeaderBuilder: (String header) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            decoration: BoxDecoration(
                                border: Border.all(width: 0.5),
                                color: Colors.grey[300]),
                            child: Text(
                              header,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .display1
                                  .copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16.0,
                                      color: Colors.black87),
                            ),
                          );
                        },
                        tableCellBuilder: (value) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4.0, vertical: 2.0),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 0.5,
                                    color: Colors.grey.withOpacity(0.5))),
                            child: Text(
                              value,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .display1
                                  .copyWith(
                                      fontSize: 16.0, color: Colors.grey[900]),
                            ),
                          );
                        },
                      ),
                    );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReportSelector extends StatefulWidget {
  ReportSelector({Key key}) : super(key: key);

  @override
  _ReportSelectorState createState() => _ReportSelectorState();
}

class _ReportSelectorState extends State<ReportSelector> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(builder: (context, homeViewModel, _) {
      if (homeViewModel.state == ViewState.Busy)
        return Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 20,
                child: CircularProgressIndicator(),
              ),
              SizedBox(
                width: 25,
              ),
              Text('Atualizando Planilhas ...'),
            ],
          ),
        );
      else
        return Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.refresh),
                iconSize: 34,
                onPressed: homeViewModel.fetchReportsList,
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: DropdownButton<String>(
                  value: homeViewModel.selectedReportDescription,
                  hint: Center(
                    child: Text(
                      "Selecione uma Planilha",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                  iconSize: 30,
                  elevation: 16,
                  isExpanded: true,
                  style: TextStyle(color: Colors.blueGrey),
                  underline: Container(
                    height: 2,
                    color: Colors.blueGrey,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      homeViewModel.selectedReportDescription = newValue;
                    });
                    homeViewModel.getReport();
                  },
                  items: homeViewModel.reportsList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Center(
                          child: Text(
                        value,
                        style: TextStyle(fontSize: 20.0),
                      )),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
    });
  }
}
