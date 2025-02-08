import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tailor_master/ui/fastening/provider/fastening_provider.dart';
import 'package:tailor_master/ui/home/provider/home_provider.dart';
import 'package:tailor_master/ui/order/provider/order_provider.dart';
import 'package:tailor_master/utils/widgets/app/custom_navbar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HomeProvider>(
          create: (context) => HomeProvider(),
        ),
        ChangeNotifierProvider<OrderProvider>(
          create: (context) => OrderProvider()..initialize(),
        ),
        ChangeNotifierProvider<FasteningProvider>(
          create: (context) => FasteningProvider()..initialize(),
        ),
      ],
      child: Consumer<HomeProvider>(
        builder: (context, provider, _) {
          final Map page = provider.menu[provider.selectedIndex];

          return Scaffold(
            appBar: AppBar(
              title: Text(
                '${page['title']}',
              ),
            ),
            body: page['page'],
            bottomNavigationBar: CustomNavbar(),
          );
        },
      ),
    );
  }
}
