import 'package:flutter/material.dart';
import 'package:tomato_record/screens/start/address_page.dart';
import 'package:tomato_record/screens/start/auth_page.dart';
import 'package:tomato_record/screens/start/intro_page.dart';
import 'package:provider/provider.dart';

class StartScreen extends StatelessWidget {
  StartScreen({Key? key}) : super(key: key);

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: _pageController,
      child: Scaffold(
        body: PageView(
          // physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: [
            IntroPage(),
            AddressPage(),
            AuthPage(),
          ],
        ),
      ),
    );
  }
}
