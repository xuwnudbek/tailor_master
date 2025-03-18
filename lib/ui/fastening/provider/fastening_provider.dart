import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tailor_master/services/http_service.dart';
import 'package:tailor_master/utils/widgets/custom_snackbars.dart';

class FasteningProvider extends ChangeNotifier {
  List<ExpansionTileController> expansionControllers = [];

  List orders = [];
  List groups = [];

  Map<int, Map?> fasteningGroups = {};

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  bool _isUpdating = false;
  bool get isUpdating => _isUpdating;
  set isUpdating(bool val) {
    _isUpdating = val;
    notifyListeners();
  }

  FasteningProvider();

  void initialize() async {
    isLoading = true;

    await getOrders();
    await getGroups();

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

  Future<void> getGroups() async {
    var res = await HttpService.get(Api.groups);

    if (res['status'] == Result.success) {
      groups = res['data'] ?? [];
      notifyListeners();
    }
  }

  Future<void> updateFasteningGroups(
    BuildContext context,
    int orderId,
  ) async {
    Map<String, dynamic> data = {
      "data": [
        ...fasteningGroups.entries.where((e) => e.value != null).map((entry) {
          return {
            "submodel_id": entry.key,
            "group_id": entry.value?['id'],
            "order_id": orderId,
          };
        }),
      ]
    };

    if (data['data'].isEmpty) {
      CustomSnackbars(context).warning('Guruhlar tanlanmagan');
      return;
    }

    isUpdating = true;

    var res = await HttpService.post(
      Api.fasteningOrderToGroup,
      data,
    );

    if (res['status'] == Result.success) {
      inspect(res);
      CustomSnackbars(context).success('Guruhlar muvaffaqiyatli saqlandi');
      await getOrders();
    } else {
      CustomSnackbars(context).error('Guruhlar saqlashda xatolik yuz berdi');
    }

    isUpdating = false;
  }

  void onSelectGroup(int key, int groupId) {
    var group = groups.firstWhere((group) => group['id'] == groupId, orElse: () => null);
    if (group == null) return;

    fasteningGroups[key] = group;
    notifyListeners();
  }

  void prepareFasteningGroups(List orderSubmodels) {
    fasteningGroups.clear();

    for (var submodel in orderSubmodels) {
      fasteningGroups[submodel['id']] = groups.firstWhere(
        (group) => group['id'] == submodel['group']?['id'],
        orElse: () => null,
      );
    }

    notifyListeners();
  }
}
