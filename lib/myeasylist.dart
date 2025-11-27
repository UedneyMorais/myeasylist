// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './infrastructure/infrastructure.dart';
import './provider/provider.dart';
import './ui/ui.dart';

class Myeasylist extends StatelessWidget {
  EnvironmentConfig environmentConfig;
  Myeasylist({Key? key, required this.environmentConfig}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HomeProvider>(
          create: (_) => HomeProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: environmentConfig.appMode == AppMode.dev ||
                environmentConfig.appMode == AppMode.qa
            ? true
            : false,
        theme: ThemeData(
          primarySwatch: environmentConfig.appMode == AppMode.dev
              ? Colors.green
              : environmentConfig.appMode == AppMode.qa
                  ? Colors.yellow
                  : Colors.deepPurple,
        ),
        home: HomePage(environmentConfig: environmentConfig),
      ),
    );
  }
}
