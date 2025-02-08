import 'package:flutter/material.dart';
import 'package:tailor_master/services/http_service.dart';

class OrderProvider extends ChangeNotifier {
  List<ExpansionTileController> expansionControllers = [];

  List orders = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  OrderProvider();

  void initialize() async {
    isLoading = true;

    await getOrders();

    isLoading = false;
  }

  Future<void> getOrders() async {
    var res = await HttpService.get(Api.orders);

    if (res['status'] == Result.success) {
      orders = res['data'] ?? [];
      notifyListeners();
    }

    expansionControllers = List.generate(orders.length, (index) => ExpansionTileController());
  }
}
