import 'package:flutter/material.dart';

import '/infrastructure/infrastructure.dart';
import '/myeasylist.dart';


void main() {
  EnvironmentConfig environmentConfig =  EnvironmentConfig(appMode: AppMode.prod);
  runApp( Myeasylist(environmentConfig: environmentConfig,));
}


