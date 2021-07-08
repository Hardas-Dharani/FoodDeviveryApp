import 'package:bloc/bloc.dart';
import 'package:flutter_restaurant/view/screens/Example/orderHistory.dart';
import 'package:flutter_restaurant/view/screens/Example/trackOrder.dart';
import 'package:flutter_restaurant/view/screens/dashboard/dashboard_screen.dart';
import 'package:flutter_restaurant/view/screens/home/categoryPage.dart';
import 'package:flutter_restaurant/view/screens/home/detailPage.dart';
import 'package:flutter_restaurant/view/screens/payment/paymentPage.dart';

enum NavigationEvents {
  HomePageClickedEvent,
  TrackOrderClickedEvent,
  OrderHistoryClickedEvent,
  RestaurantCategoryClicked,
  CartClickedEvent,
  FavouritesClickedEvent,
  SerchClickedEvent,
  RestaurantPaymentClicked
}

abstract class NavigationStates {}

class NavigationBloc extends Bloc<NavigationEvents, NavigationStates> {
  final Function onMenuTap;

  NavigationBloc({this.onMenuTap}) : super(null);

  NavigationStates get initialState => DashboardScreen(
        isMenuTapped: onMenuTap,
      );

  @override
  Stream<NavigationStates> mapEventToState(NavigationEvents event) async* {
    switch (event) {
      case NavigationEvents.HomePageClickedEvent:
        yield DashboardScreen(
          isMenuTapped: onMenuTap,
          getPageIndex: 0,
        );
        break;
      case NavigationEvents.CartClickedEvent:
        yield DashboardScreen(
          isMenuTapped: onMenuTap,
          getPageIndex: 1,
        );
        break;
      case NavigationEvents.FavouritesClickedEvent:
        yield DashboardScreen(
          isMenuTapped: onMenuTap,
          getPageIndex: 2,
        );
        break;
      case NavigationEvents.SerchClickedEvent:
        yield DashboardScreen(
          isMenuTapped: onMenuTap,
          getPageIndex: 3,
        );
        break;
      case NavigationEvents.TrackOrderClickedEvent:
        yield TrackPrder(onMenuTap: onMenuTap);
        break;
      case NavigationEvents.OrderHistoryClickedEvent:
        yield OrderHistory(onMenuTap: onMenuTap);
        break;
      case NavigationEvents.RestaurantCategoryClicked:
        yield CategoryPage(
          isMenuTapped: onMenuTap,
        );
        break;
      case NavigationEvents.RestaurantPaymentClicked:
        yield PaymentPage(
          isMenuTapped: onMenuTap,
        );
        break;
    }
  }
}
