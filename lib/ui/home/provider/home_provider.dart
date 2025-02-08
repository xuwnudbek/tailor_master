import 'package:flutter/material.dart';
import 'package:tailor_master/ui/fastening/fastening_page.dart';
import 'package:tailor_master/ui/order/order_page.dart';

class HomeProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  set selectedIndex(int value) {
    _selectedIndex = value;
    notifyListeners();
  }

  List<Map<String, dynamic>> menu = [
    {
      'title': 'Buyurtmalar',
      'icon': Icons.home_outlined,
      'active_icon': Icons.home_rounded,
      "page": OrderPage(),
    },
    {
      'title': 'Biriktirish',
      'icon': Icons.merge_outlined,
      'active_icon': Icons.merge_rounded,
      "page": FasteningPage(),
    },
  ];
}
