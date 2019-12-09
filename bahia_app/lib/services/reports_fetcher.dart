import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

abstract class IReportFetcher {
  Future<List<String>> listReports();
  Future<dynamic> getReport(String description);
}

class ReportFetcher implements IReportFetcher {
  final String _apiUrl = 'https://bahiaapi.azurewebsites.net/api/reports/';

  @override
  Future<List<String>> listReports() async {
    final response = await http.get(_apiUrl);
    List<String> reportsList;

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      reportsList =
          (json.decode(response.body) as List<dynamic>).cast<String>();
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load reporst List');
    }
    return reportsList;
  }

  @override
  Future<dynamic> getReport(String description) async {
    final response = await http.get(_apiUrl + description);
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      return (json.decode(response.body));
    } else if (response.statusCode == 404) {
      return "NOTFOUND";
    } else {
      // If that response was not OK, throw an error.
      throw Exception('ERROR');
    }
  }
}
