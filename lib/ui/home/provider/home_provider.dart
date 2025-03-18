import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailor_master/services/storage_service.dart';
import 'package:tailor_master/ui/fastening/fastening_page.dart';
import 'package:tailor_master/ui/order/order_page.dart';
import 'package:tailor_master/ui/splash/splash_page.dart';
import 'package:tailor_master/utils/theme/app_colors.dart';

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

  Future<void> logout(BuildContext context) async {
    var res = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tizimdan chiqish'),
          content: Text('Tizimdan chiqmoqchimisiz?'),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: AppColors.light.withValues(alpha: 0.2),
                foregroundColor: AppColors.dark,
              ),
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text('Yoq'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: AppColors.danger.withValues(alpha: 0.2),
                foregroundColor: AppColors.danger,
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text('Ha, albatta'),
            ),
          ],
        );
      },
    );

    if (res == true) {
      StorageService.clear();
      Get.offAll(() => SplashPage());
    }
  }
}
