// app_router.dart
import 'package:go_router/go_router.dart';
import 'welcome_screen.dart';
import 'merchant_main_screen.dart';
import 'n_pay_screen.dart';

class AppRouter {
  final GoRouter router;

  AppRouter()
      : router = GoRouter(
          initialLocation: '/',
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const WelcomeScreen(),
            ),
            GoRoute(
              path: '/merchant',
              builder: (context, state) => const MerchantMainScreen(),
              routes: [
                GoRoute(
                  path: 'n-pay',
                  builder: (context, state) => const NPayScreen(),
                ),
              ],
            ),
          ],
        );
}
