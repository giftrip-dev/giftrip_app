import 'package:flutter/widgets.dart';

class RouteObserverService extends RouteObserver<PageRoute<dynamic>> {
  String? previousRoute;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (previousRoute is PageRoute) {
      this.previousRoute = previousRoute.settings.name;
    }
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (previousRoute is PageRoute) {
      this.previousRoute = previousRoute.settings.name;
    }
    super.didPop(route, previousRoute);
  }
}

// 전역 RouteObserver 인스턴스
final RouteObserverService routeObserver = RouteObserverService();
