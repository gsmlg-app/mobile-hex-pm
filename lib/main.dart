import 'package:app_database/app_database.dart';
import 'package:app_locale/app_locale.dart';
import 'package:app_provider/app_provider.dart';
import 'package:app_secure_storage/app_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart' as logging;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  logging.hierarchicalLoggingEnabled = true;

  final sharedPrefs = await SharedPreferences.getInstance();
  final vault = SecureStorageVaultRepository();
  final database = AppDatabase();
  final appSupportDir = await getApplicationSupportDirectory();
  final tmpDir = await getTemporaryDirectory();

  runApp(MainProvider(
    sharedPrefs: sharedPrefs,
    vault: vault,
    database: database,
    appSupportDir: appSupportDir,
    tmpDir: tmpDir,
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocale.localizationsDelegates,
      supportedLocales: AppLocale.supportedLocales,
      home: const App(),
    ),
  ));
}
