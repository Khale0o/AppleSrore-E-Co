import 'package:flutter/material.dart';
import 'router/app_router.dart';
import 'theme/store_theme_v2.dart';

class AppleStoreApp extends StatelessWidget {
  const AppleStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'AppleStore Concept',
      debugShowCheckedModeBanner: false,
      theme: StoreThemeV2.light,
      routerConfig: appRouter,
    );
  }
}
