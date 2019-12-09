import 'package:bahia_app/services/reports_fetcher.dart';
import 'package:bahia_app/ui/viewmodels/base_viewmodel.dart';

class HomeViewModel extends BaseViewModel {
  HomeViewModel() {
    fetchReportsList();
  }

  final IReportFetcher _reportFetcher = ReportFetcher();
  List<String> reportsList;
  String selectedReportDescription;
  dynamic reportTable;

  void fetchReportsList() async {
    setState(ViewState.Busy);
    reportsList = await _reportFetcher.listReports();
    setState(ViewState.Idle);
  }

  void getReport([String description]) async {
    reportTable = "LOADING";
    notifyListeners();
    var json = await _reportFetcher
        .getReport(description ?? selectedReportDescription);
    reportTable = json;
    notifyListeners();
  }
}
