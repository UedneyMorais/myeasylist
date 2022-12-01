import 'package:flutter/material.dart';
import 'package:myeasylist/infrastructure/environment_config/entities/entities.dart';
import '/myeasylist.dart';

void main() {
  EnvironmentConfig environmentConfig =  EnvironmentConfig(appMode: AppMode.qa);
  runApp( Myeasylist(environmentConfig: environmentConfig,));
}


