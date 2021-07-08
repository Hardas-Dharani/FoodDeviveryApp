import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_restaurant/navigation_bloc/navigation_bloc.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/view/screens/dashboard/dashboard.dart';
import 'package:flutter_restaurant/view/screens/dashboard/dashboard_screen.dart';
import 'package:flutter_restaurant/view/screens/home/home_screen.dart';
import 'package:flutter_restaurant/view/screens/menu/menu_screen.dart';

class DashBoardLayOut extends StatefulWidget {

  @override
  _DashBoardLayOutState createState() => _DashBoardLayOutState();
}

class _DashBoardLayOutState extends State<DashBoardLayOut> {
  double xOffset = 0;

  double yOffset = 0;

  double scaleFactor = 1;

  bool isMenuOpened = false;

  @override
  Widget build(BuildContext context) {
    // final bool _isLoggedIn =
    //     Provider.of<AuthProvider>(context, listen: false).isLoggedIn();

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider<NavigationBloc>(
        create: (context) => NavigationBloc(onMenuTap: isMenuTapped),
        child: Stack(
          children: [
            MenuScreen(),
            DashBoardLayout(
              xOffset: xOffset,
              yOffset: yOffset,
              scaleFactor: scaleFactor,
              isMenuOpened: isMenuOpened,
              onMenuTap: isMenuTapped,
              child: BlocBuilder<NavigationBloc, NavigationStates>(
                builder: (context, NavigationStates navigationState) {
                  print("navigationState");
                  print(navigationState);

                  if (navigationState is NavigationStates) {
                    print("if condtion");



                    return navigationState as Widget;

                  } else {
                    return DashboardScreen(
                      isMenuTapped: isMenuTapped,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void isMenuTapped() {

    print("hi");
    Locale _locale;

    setState(() {
      if (isMenuOpened) {
        xOffset = 0;
        yOffset = 0;
        scaleFactor = 1;
      } else {
        // xOffset=250;
        // yOffset=150;
        xOffset =  AppConstants.selectedLanguage == "English" ? 250 : -50;
        yOffset =  AppConstants.selectedLanguage == "English"
            ? 150
            : MediaQuery.of(context).size.height * 0.2;
        scaleFactor = 0.6;
      }

      isMenuOpened = !isMenuOpened;
    });
  }
}
