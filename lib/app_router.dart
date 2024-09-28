// app_router.dart
import 'package:go_router/go_router.dart';
import 'package:nearfield/screen/cart_screen.dart';
import 'package:nearfield/screen/payment_sources_screen.dart';
import 'package:nearfield/screen/login_screen.dart';
import 'package:nearfield/screen/categories_screen.dart';
import 'package:nearfield/screen/items_screen.dart';

class AppRouter {
  final GoRouter router;

  AppRouter()
      : router = GoRouter(
          initialLocation: '/login',
          routes: [
            GoRoute(
              path: '/login',
              builder: (context, state) => const LoginScreen(),
            ),
            GoRoute(
              path: "/payment-sources",
              builder: (context, state) => const PaymentSourcesScreen(),
              routes: [
                GoRoute(
                  path: ":paymentSourceName",
                  builder: (context, state) {
                    final paymentSourceName =
                        state.pathParameters['paymentSourceName']!;

                    return CategoriesScreen(
                      paymentSourceName: paymentSourceName,
                    );
                  },
                  routes: [
                    GoRoute(
                      path: ":categoryName",
                      builder: (context, state) {
                        final paymentSourceName =
                            state.pathParameters['paymentSourceName']!;
                        final categoryName =
                            state.pathParameters['categoryName']!;

                        return ItemsScreen(
                          paymentSourceName: paymentSourceName,
                          categoryName: categoryName,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            GoRoute(
              path: "/cart",
              builder: (context, state) {
                return const CartScreen();
              },
            )
          ],
        );
}
