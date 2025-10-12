import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Flutter App Template'**
  String get appName;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'Error Occurred'**
  String get errorOccurred;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @welcomeHome.
  ///
  /// In en, this message translates to:
  /// **'Wellcom to my app'**
  String get welcomeHome;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navFavorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get navFavorite;

  /// No description provided for @navDownloads.
  ///
  /// In en, this message translates to:
  /// **'Offline Docs'**
  String get navDownloads;

  /// No description provided for @navSetting.
  ///
  /// In en, this message translates to:
  /// **'Setting'**
  String get navSetting;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Setting'**
  String get settingsTitle;

  /// No description provided for @smenuTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get smenuTheme;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @accentColor.
  ///
  /// In en, this message translates to:
  /// **'Accent Color'**
  String get accentColor;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'HEX Packages'**
  String get appTitle;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @hex.
  ///
  /// In en, this message translates to:
  /// **'hex'**
  String get hex;

  /// No description provided for @favoritePackages.
  ///
  /// In en, this message translates to:
  /// **'Favorite Packages'**
  String get favoritePackages;

  /// No description provided for @releasesTitle.
  ///
  /// In en, this message translates to:
  /// **'{packageName} Releases'**
  String releasesTitle(Object packageName);

  /// No description provided for @downloads.
  ///
  /// In en, this message translates to:
  /// **'downloads'**
  String get downloads;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'yesterday'**
  String get yesterday;

  /// No description provided for @last7Days.
  ///
  /// In en, this message translates to:
  /// **'last 7 days'**
  String get last7Days;

  /// No description provided for @allTime.
  ///
  /// In en, this message translates to:
  /// **'all time'**
  String get allTime;

  /// No description provided for @favorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get favorite;

  /// No description provided for @addToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Add to Favorites'**
  String get addToFavorites;

  /// No description provided for @hexAPI.
  ///
  /// In en, this message translates to:
  /// **'Hex API'**
  String get hexAPI;

  /// No description provided for @hexAPIKey.
  ///
  /// In en, this message translates to:
  /// **'HEX_API_KEY'**
  String get hexAPIKey;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @hidden.
  ///
  /// In en, this message translates to:
  /// **'******'**
  String get hidden;

  /// No description provided for @hexUser.
  ///
  /// In en, this message translates to:
  /// **'Hex User'**
  String get hexUser;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @setAPIKey.
  ///
  /// In en, this message translates to:
  /// **'Set hex.pm API Key'**
  String get setAPIKey;

  /// No description provided for @removeAPIKey.
  ///
  /// In en, this message translates to:
  /// **'Remove API Key'**
  String get removeAPIKey;

  /// No description provided for @confirmRemoveAPIKey.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove the API key?'**
  String get confirmRemoveAPIKey;

  /// No description provided for @deleteDocument.
  ///
  /// In en, this message translates to:
  /// **'Delete Document'**
  String get deleteDocument;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @confirmDeleteDocument.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the document for {packageName} ({packageVersion})?'**
  String confirmDeleteDocument(Object packageName, Object packageVersion);

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @howToUseApp.
  ///
  /// In en, this message translates to:
  /// **'How to use this app:'**
  String get howToUseApp;

  /// No description provided for @searchPackages.
  ///
  /// In en, this message translates to:
  /// **'Search packages'**
  String get searchPackages;

  /// No description provided for @viewPackageDetails.
  ///
  /// In en, this message translates to:
  /// **'View package details'**
  String get viewPackageDetails;

  /// No description provided for @addToFavorite.
  ///
  /// In en, this message translates to:
  /// **'Add to favorite'**
  String get addToFavorite;

  /// No description provided for @downloadDocsInstruction.
  ///
  /// In en, this message translates to:
  /// **'In favorite, select package and download target version documents'**
  String get downloadDocsInstruction;

  /// No description provided for @viewOfflineDocsInstruction.
  ///
  /// In en, this message translates to:
  /// **'View offline docs in Offline Docs menu'**
  String get viewOfflineDocsInstruction;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// No description provided for @noPackagesFound.
  ///
  /// In en, this message translates to:
  /// **'No packages found for your search'**
  String get noPackagesFound;

  /// No description provided for @tryDifferentSearch.
  ///
  /// In en, this message translates to:
  /// **'Try a different search term'**
  String get tryDifferentSearch;

  /// No description provided for @searchError.
  ///
  /// In en, this message translates to:
  /// **'Search error occurred'**
  String get searchError;

  /// No description provided for @failedToLoadPackages.
  ///
  /// In en, this message translates to:
  /// **'Failed to load packages'**
  String get failedToLoadPackages;

  /// No description provided for @pleaseTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Please try again'**
  String get pleaseTryAgain;

  /// No description provided for @noReleasesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No releases available'**
  String get noReleasesAvailable;

  /// No description provided for @packageHasNoReleases.
  ///
  /// In en, this message translates to:
  /// **'This package has no releases'**
  String get packageHasNoReleases;

  /// No description provided for @serverSettings.
  ///
  /// In en, this message translates to:
  /// **'Server Settings'**
  String get serverSettings;

  /// No description provided for @serverStatus.
  ///
  /// In en, this message translates to:
  /// **'Server Status'**
  String get serverStatus;

  /// No description provided for @serverRunning.
  ///
  /// In en, this message translates to:
  /// **'Server Running'**
  String get serverRunning;

  /// No description provided for @serverStopped.
  ///
  /// In en, this message translates to:
  /// **'Server Stopped'**
  String get serverStopped;

  /// No description provided for @serverStarting.
  ///
  /// In en, this message translates to:
  /// **'Server Starting...'**
  String get serverStarting;

  /// No description provided for @serverStopping.
  ///
  /// In en, this message translates to:
  /// **'Server Stopping...'**
  String get serverStopping;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'Server Error'**
  String get serverError;

  /// No description provided for @startServer.
  ///
  /// In en, this message translates to:
  /// **'Start Server'**
  String get startServer;

  /// No description provided for @stopServer.
  ///
  /// In en, this message translates to:
  /// **'Stop Server'**
  String get stopServer;

  /// No description provided for @serverUrl.
  ///
  /// In en, this message translates to:
  /// **'Server URL'**
  String get serverUrl;

  /// No description provided for @serverHost.
  ///
  /// In en, this message translates to:
  /// **'Host'**
  String get serverHost;

  /// No description provided for @serverPort.
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get serverPort;

  /// No description provided for @autoStartServer.
  ///
  /// In en, this message translates to:
  /// **'Auto-start Server'**
  String get autoStartServer;

  /// No description provided for @enableServer.
  ///
  /// In en, this message translates to:
  /// **'Enable Server'**
  String get enableServer;

  /// No description provided for @serverConfig.
  ///
  /// In en, this message translates to:
  /// **'Server Configuration'**
  String get serverConfig;

  /// No description provided for @serverAddress.
  ///
  /// In en, this message translates to:
  /// **'Server Address'**
  String get serverAddress;

  /// No description provided for @shareServerUrl.
  ///
  /// In en, this message translates to:
  /// **'Share Server URL'**
  String get shareServerUrl;

  /// No description provided for @serverNotRunning.
  ///
  /// In en, this message translates to:
  /// **'Server is not running'**
  String get serverNotRunning;

  /// No description provided for @serverLogs.
  ///
  /// In en, this message translates to:
  /// **'Server Logs'**
  String get serverLogs;

  /// No description provided for @restartServer.
  ///
  /// In en, this message translates to:
  /// **'Restart Server'**
  String get restartServer;

  /// No description provided for @serverStartedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Server started successfully'**
  String get serverStartedSuccessfully;

  /// No description provided for @serverStoppedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Server stopped successfully'**
  String get serverStoppedSuccessfully;

  /// No description provided for @serverFailedToStart.
  ///
  /// In en, this message translates to:
  /// **'Failed to start server'**
  String get serverFailedToStart;

  /// No description provided for @serverFailedToStop.
  ///
  /// In en, this message translates to:
  /// **'Failed to stop server'**
  String get serverFailedToStop;

  /// No description provided for @serverConfigUpdated.
  ///
  /// In en, this message translates to:
  /// **'Server configuration updated'**
  String get serverConfigUpdated;

  /// No description provided for @serverConfigUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update server configuration'**
  String get serverConfigUpdateFailed;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
