import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nearfield/app_router.dart';
import 'package:flutter_nfc_hce/flutter_nfc_hce.dart';

void main() async {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Define the routes using go_router
    final appRouter = AppRouter();

    return MaterialApp.router(
      routerConfig: appRouter.router,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black, // Black background theme
        fontFamily: "CeraCompactCY",
        fontFamilyFallback: const ["Roboto"],
      ),
    );
  }
}
