import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_hex_pm/screens/app/error_screen.dart';
import 'package:mobile_hex_pm/screens/app/splash_screen.dart';
import 'package:mobile_hex_pm/screens/offline_docs/offline_docs_screen.dart';
import 'package:mobile_hex_pm/screens/favorite/favorite_release_docs_screen.dart';
import 'package:mobile_hex_pm/screens/favorite/favorite_releases_screen.dart';
import 'package:mobile_hex_pm/screens/favorite/favorite_screen.dart';
import 'package:mobile_hex_pm/screens/home/home_result_screen.dart';
import 'package:mobile_hex_pm/screens/home/home_screen.dart';
import 'package:mobile_hex_pm/screens/settings/hex_settings_screen.dart';
import 'package:mobile_hex_pm/screens/settings/server_control_screen.dart';
import 'package:mobile_hex_pm/screens/settings/server_config_screen.dart';
import 'package:mobile_hex_pm/screens/settings/server_settings_screen.dart';
import 'package:mobile_hex_pm/screens/settings/settings_screen.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>(
    debugLabel: 'routerKey',
  );

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
            child: const HomeScreen(),
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
                  packageName: state.pathParameters['package_name']!,
                ),
              );
            },
          ),
        ]),
    GoRoute(
      name: FavoriteScreen.name,
      path: FavoriteScreen.path,
      pageBuilder: (context, state) {
        return NoTransitionPage<void>(
          key: state.pageKey,
          restorationId: state.pageKey.value,
          child: FavoriteScreen(),
        );
      },
      routes: [
        GoRoute(
          name: FavoriteReleasesScreen.name,
          path: FavoriteReleasesScreen.path,
          pageBuilder: (context, state) {
            return NoTransitionPage<void>(
              key: state.pageKey,
              restorationId: state.pageKey.value,
              child: FavoriteReleasesScreen(
                packageName: state.pathParameters['package_name']!,
              ),
            );
          },
          routes: [],
        ),
      ],
    ),
    GoRoute(
      name: OfflineDocsScreen.name,
      path: OfflineDocsScreen.path,
      pageBuilder: (context, state) {
        return NoTransitionPage<void>(
          key: state.pageKey,
          restorationId: state.pageKey.value,
          child: const OfflineDocsScreen(),
        );
      },
      routes: [],
    ),
    GoRoute(
      name: FavoriteReleaseDocsScreen.name,
      path: '/docs/:package_name/:package_version',
      pageBuilder: (context, state) {
        return NoTransitionPage<void>(
          key: state.pageKey,
          restorationId: state.pageKey.value,
          child: FavoriteReleaseDocsScreen(
            packageName: state.pathParameters['package_name']!,
            packageVersion: state.pathParameters['package_version']!,
            parentName: state.uri.queryParameters['parentName'],
          ),
        );
      },
    ),
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
        GoRoute(
          name: ServerSettingsScreen.name,
          path: ServerSettingsScreen.path,
          pageBuilder: (context, state) {
            return NoTransitionPage<void>(
              key: state.pageKey,
              restorationId: state.pageKey.value,
              child: const ServerSettingsScreen(),
            );
          },
        ),
        GoRoute(
          name: ServerControlScreen.name,
          path: ServerControlScreen.path,
          pageBuilder: (context, state) {
            return NoTransitionPage<void>(
              key: state.pageKey,
              restorationId: state.pageKey.value,
              child: const ServerControlScreen(),
            );
          },
        ),
        GoRoute(
          name: ServerConfigScreen.name,
          path: ServerConfigScreen.path,
          pageBuilder: (context, state) {
            return NoTransitionPage<void>(
              key: state.pageKey,
              restorationId: state.pageKey.value,
              child: const ServerConfigScreen(),
            );
          },
        ),
      ],
    ),
  ];
}
