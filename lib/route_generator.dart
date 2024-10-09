import 'package:clean_architecture/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'package:flutter/material.dart';
import 'package:clean_architecture/main.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return _routeArgsHandler(
            ({required params, settings}) => MaterialPageRoute(
                settings: settings,
                builder: (context) => const NumberTriviaPage()),
            args,
            settings);

      case '/second':
        return _routeArgsHandler<String>(
            ({required params, settings}) => MaterialPageRoute(
                settings: settings,
                builder: (context) => SecondPage(
                      data: params,
                    )),
            args,
            settings);

      default:
        return errorRoute();
    }
  }

  static Route<dynamic> _routeArgsHandler<T>(
      Route<dynamic> Function({required T params, RouteSettings? settings})
          routeCaller,
      Object? args,
      RouteSettings? settings) {
    if (args is T) {
      return routeCaller(params: args, settings: settings);
    } else {
      return errorRoute();
    }
  }

  static Route<dynamic> errorRoute() {
    return MaterialPageRoute(
      builder: (_) => const SecondPage(data: "Error",),
    );
  }
}
