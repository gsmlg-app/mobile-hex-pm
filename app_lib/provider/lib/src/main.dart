import 'dart:io';

import 'package:app_database/app_database.dart';
import 'package:app_secure_storage/app_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:favorite_package_bloc/favorite_package_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hex_api/hex_api.dart';
import 'package:hex_auth_bloc/hex_auth_bloc.dart';
import 'package:hex_doc_bloc/hex_doc_bloc.dart';
import 'package:hex_search_bloc/hex_search_bloc.dart';
import 'package:offline_docs_server/offline_docs_server_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_bloc/theme_bloc.dart';

class MainProvider extends StatelessWidget {
  const MainProvider({
    super.key,
    required this.child,
    required this.sharedPrefs,
    required this.vault,
    required this.database,
    required this.appSupportDir,
    required this.tmpDir,
  });

  final Widget child;
  final SharedPreferences sharedPrefs;
  final VaultRepository vault;
  final AppDatabase database;
  final Directory appSupportDir;
  final Directory tmpDir;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<SharedPreferences>(
          create: (BuildContext context) => sharedPrefs,
        ),
        RepositoryProvider<AppDatabase>(
          create: (BuildContext context) => database,
        ),
        RepositoryProvider<VaultRepository>(
          create: (BuildContext context) => vault,
        ),
        RepositoryProvider<Dio>(
          create: (BuildContext context) => Dio(
            BaseOptions(baseUrl: 'https://hex.pm/api'),
          ),
        ),
        RepositoryProvider<HexApi>(
          create: (BuildContext context) => HexApi(context.read<Dio>()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeBloc>(
            create: (BuildContext context) => ThemeBloc(
              context.read<SharedPreferences>(),
            ),
          ),
          BlocProvider<HexAuthBloc>(
            create: (context) => HexAuthBloc(
              context.read<Dio>(),
              context.read<HexApi>(),
              context.read<VaultRepository>(),
            ),
          ),
          BlocProvider<HexSearchFormBloc>(
            create: (context) => HexSearchFormBloc(),
          ),
          BlocProvider<HexSearchBloc>(
            create: (context) => HexSearchBloc(
              context.read<HexApi>(),
            ),
          ),
          BlocProvider<FavoritePackageBloc>(
            create: (context) => FavoritePackageBloc(
              context.read<AppDatabase>(),
              context.read<HexApi>(),
            ),
          ),
          BlocProvider<HexDocBloc>(
            create: (context) => HexDocBloc(appSupportDir, tmpDir),
          ),
          BlocProvider<OfflineDocsServerBloc>(
            create: (context) => OfflineDocsServerBloc(
              context.read<AppDatabase>(),
            ),
          ),
        ],
        child: child,
      ),
    );
  }
}
