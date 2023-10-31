import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sbc_league/core/constants/logos.dart';
import 'package:sbc_league/core/utils/initial_bindings.dart';
import 'package:sbc_league/core/utils/theme/dark_theme.dart';
import 'package:sbc_league/widgets/custom_circular_image.dart';

import 'core/utils/theme/light_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SBC League',
      initialBinding: InitialBindings(),
      themeMode: ThemeMode.system,
      theme: light,
      darkTheme: dark,
      home: Scaffold(
        body: Center(
          child: CustomCircularImage(
            image: ClubLogos.leagueLogo,
            selected: false,
            size: 100,
          ),
        ),
      ),
    );
  }
}
