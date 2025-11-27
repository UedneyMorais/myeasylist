import 'package:flutter/material.dart';
import 'package:myeasylist/myeasylist.dart';
import './infrastructure/infrastructure.dart';

void main() {
  EnvironmentConfig environmentConfig =
      EnvironmentConfig(appMode: AppMode.prod);
  runApp(Myeasylist(
    environmentConfig: environmentConfig,
  ));
}
