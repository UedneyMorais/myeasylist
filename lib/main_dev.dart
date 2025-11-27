import 'package:flutter/material.dart';

import 'package:myeasylist/myeasylist.dart';
import './infrastructure/infrastructure.dart';

void main() {
  EnvironmentConfig environmentConfig = EnvironmentConfig(appMode: AppMode.dev);
  runApp(Myeasylist(
    environmentConfig: environmentConfig,
  ));
}
