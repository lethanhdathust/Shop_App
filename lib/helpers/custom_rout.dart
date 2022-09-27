

import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/order_screen.dart';

class CustomRoute<T> extends PageRouteBuilder {
  final Widget child;

  CustomRoute({required this.child})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: Duration(seconds: 1),
        );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    Tween<Offset> tween = Tween<Offset>(begin: Offset(-1, 0), end: Offset.zero);
    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }
}
