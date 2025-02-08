import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tailor_master/services/storage_service.dart';
import 'package:tailor_master/ui/auth/login_page.dart';
import 'package:tailor_master/ui/home/home_page.dart';
import 'package:tailor_master/utils/theme/app_colors.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future<void> _splashTime() async {
    await Future.delayed(const Duration(milliseconds: 10));

    String token = StorageService.read('token') ?? '';
    Map user = StorageService.read('user') ?? {};

    bool isLoggedOut = token.isNotEmpty && user.isNotEmpty;

    if (!isLoggedOut) {
      Get.offAll(() => const LoginPage());
    } else {
      Get.offAll(() => const HomePage());
    }
  }

  @override
  void initState() {
    super.initState();
    _splashTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 150,
          height: 150,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: AppColors.secondary.withValues(alpha: 0.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: LoadingAnimationWidget.inkDrop(
            color: AppColors.primary,
            size: 50,
          ),
        ),
      ),
    );
  }
}
