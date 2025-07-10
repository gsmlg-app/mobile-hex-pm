import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_hex_pm/screens/app/error_screen.dart';
import 'package:mobile_hex_pm/screens/app/splash_screen.dart';
import 'package:mobile_hex_pm/screens/home/home_result_screen.dart';
import 'package:mobile_hex_pm/screens/home/home_screen.dart';
import 'package:mobile_hex_pm/screens/settings/hex_settings_screen.dart';
import 'package:mobile_hex_pm/screens/settings/settings_screen.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> key =
      GlobalKey<NavigatorState>(debugLabel: 'routerKey');

  static GoRouter router = GoRouter(
    navigatorKey: key,
    debugLogDiagnostics: true,
    initialLocation: SplashScreen.path,
    routes: routes,
    errorBuilder: (context, state) {
      return ErrorScreen(routerState: state);
    },
  );

  static List<GoRoute> routes = [
    GoRoute(
      name: SplashScreen.name,
      path: SplashScreen.path,
      pageBuilder: (context, state) {
        return NoTransitionPage<void>(
          key: state.pageKey,
          restorationId: state.pageKey.value,
          child: const SplashScreen(),
        );
      },
    ),
    GoRoute(
        name: HomeScreen.name,
        path: HomeScreen.path,
        pageBuilder: (context, state) {
          return NoTransitionPage<void>(
            key: state.pageKey,
            restorationId: state.pageKey.value,
            child: HomeScreen(),
          );
        },
        routes: [
          GoRoute(
            name: HomeResultScreen.name,
            path: HomeResultScreen.path,
            pageBuilder: (context, state) {
              return NoTransitionPage<void>(
                key: state.pageKey,
                restorationId: state.pageKey.value,
                child: HomeResultScreen(
                    packageName: state.pathParameters['package_name']!),
              );
            },
          ),
        ]),
    GoRoute(
      name: SettingsScreen.name,
      path: SettingsScreen.path,
      pageBuilder: (context, state) {
        return NoTransitionPage<void>(
          key: state.pageKey,
          restorationId: state.pageKey.value,
          child: const SettingsScreen(),
        );
      },
      routes: [
        GoRoute(
          name: HexSettingsScreen.name,
          path: HexSettingsScreen.path,
          pageBuilder: (context, state) {
            return NoTransitionPage<void>(
              key: state.pageKey,
              restorationId: state.pageKey.value,
              child: HexSettingsScreen(),
            );
          },
        ),
      ],
    ),
  ];
}
