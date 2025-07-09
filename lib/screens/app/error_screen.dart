import 'package:app_locale/app_locale.dart';
import 'package:flutter/material.dart';
import 'package:mobile_hex_pm/screens/app/splash_screen.dart';
import 'package:go_router/go_router.dart';

class ErrorScreen extends StatelessWidget {
  static const name = 'Error';
  static const path = '/error';

  const ErrorScreen({super.key, required this.routerState});

  final GoRouterState routerState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              alignment: Alignment.topLeft,
              child: Text(context.l10n.errorOccurred,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Theme.of(context).colorScheme.error)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: Text(routerState.error.toString(),
                  style: Theme.of(context).textTheme.bodyLarge),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 32,
              ),
              child: ElevatedButton(
                onPressed: () {
                  context.go(SplashScreen.path);
                },
                child: Text(context.l10n.backToHome),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
