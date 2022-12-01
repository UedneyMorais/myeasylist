import 'package:flutter/material.dart';
import 'package:myeasylist/infrastructure/infrastructure.dart';

class AppModeBanner extends StatelessWidget {
  final AppMode appMode;
  final Widget child;
  late bool? visible;
  late Color color;
  AppModeBanner({Key? key, required this.appMode, required this.child, this.visible}) : super(key: key) {
    color = appMode == AppMode.dev
        ? Colors.green
        : appMode == AppMode.qa
            ? Colors.yellow
            : Colors.red;
    if (appMode == AppMode.prod || visible == null) {
      visible = false;
    } else {
      visible = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return visible == true
        ? Banner(
            key: const ValueKey('appModeBanner'),
            message: appMode.toString(),
            location: BannerLocation.topEnd,
            color: color,
            child: child,
          )
        : child;
  }
}