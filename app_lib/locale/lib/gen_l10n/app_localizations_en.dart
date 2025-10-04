// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Flutter App Template';

  @override
  String get errorOccurred => 'Error Occurred';

  @override
  String get backToHome => 'Back to Home';

  @override
  String get welcomeHome => 'Wellcom to my app';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get loading => 'Loading...';

  @override
  String get success => 'Success';

  @override
  String get error => 'Error';

  @override
  String get undo => 'Undo';

  @override
  String get navHome => 'Home';

  @override
  String get navFavorite => 'Favorite';

  @override
  String get navDownloads => 'Offline Docs';

  @override
  String get navSetting => 'Setting';

  @override
  String get settingsTitle => 'Setting';

  @override
  String get smenuTheme => 'Theme';

  @override
  String get appearance => 'Appearance';

  @override
  String get accentColor => 'Accent Color';

  @override
  String get language => 'Language';

  @override
  String get appTitle => 'HEX Packages';

  @override
  String get search => 'Search';

  @override
  String get hex => 'hex';

  @override
  String get favoritePackages => 'Favorite Packages';

  @override
  String releasesTitle(Object packageName) {
    return '$packageName Releases';
  }

  @override
  String get downloads => 'downloads';

  @override
  String get yesterday => 'yesterday';

  @override
  String get last7Days => 'last 7 days';

  @override
  String get allTime => 'all time';

  @override
  String get favorite => 'Favorite';

  @override
  String get addToFavorites => 'Add to Favorites';

  @override
  String get hexAPI => 'Hex API';

  @override
  String get hexAPIKey => 'HEX_API_KEY';

  @override
  String get notSet => 'Not set';

  @override
  String get hidden => '******';

  @override
  String get hexUser => 'Hex User';

  @override
  String get username => 'Username';

  @override
  String get setAPIKey => 'Set hex.pm API Key';

  @override
  String get removeAPIKey => 'Remove API Key';

  @override
  String get confirmRemoveAPIKey =>
      'Are you sure you want to remove the API key?';

  @override
  String get deleteDocument => 'Delete Document';

  @override
  String get delete => 'Delete';

  @override
  String confirmDeleteDocument(Object packageName, Object packageVersion) {
    return 'Are you sure you want to delete the document for $packageName ($packageVersion)?';
  }

  @override
  String get retry => 'Retry';

  @override
  String get howToUseApp => 'How to use this app:';

  @override
  String get searchPackages => 'Search packages';

  @override
  String get viewPackageDetails => 'View package details';

  @override
  String get addToFavorite => 'Add to favorite';

  @override
  String get downloadDocsInstruction =>
      'In favorite, select package and download target version documents';

  @override
  String get viewOfflineDocsInstruction =>
      'View offline docs in Offline Docs menu';

  @override
  String get noResultsFound => 'No results found';

  @override
  String get noPackagesFound => 'No packages found for your search';

  @override
  String get tryDifferentSearch => 'Try a different search term';

  @override
  String get searchError => 'Search error occurred';

  @override
  String get failedToLoadPackages => 'Failed to load packages';

  @override
  String get pleaseTryAgain => 'Please try again';

  @override
  String get noReleasesAvailable => 'No releases available';

  @override
  String get packageHasNoReleases => 'This package has no releases';
}
