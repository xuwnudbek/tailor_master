import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tailor_master/ui/splash/splash_page.dart';
import 'package:tailor_master/utils/theme/app_theme.dart';

void main() async {
  await GetStorage.init("tailorMaster");
  runApp(App());
}

/// [App] - bu class asosiy klass hisoblanadi.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tikuv Master',
      theme: AppTheme.lightTheme,
      home: SplashPage(),
    );
  }
}
