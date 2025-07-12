import 'package:app_adaptive_widgets/app_adaptive_widgets.dart';
import 'package:favorite_package_bloc/favorite_package_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:mobile_hex_pm/destination.dart';
import 'package:mobile_hex_pm/screens/favorite/favorite_releases_screen.dart';
import 'package:mobile_hex_pm/screens/favorite/favorite_screen.dart';

class FavoriteReleaseDocsScreen extends StatelessWidget {
  static const name = 'Favorite Release Document Screen';
  static const path = ':package_version/docs';
  static const fullPath = '${FavoriteReleasesScreen.fullPath}/$path';

  FavoriteReleaseDocsScreen({
    super.key,
    required this.packageName,
    required this.packageVersion,
  });

  final String packageName;
  final String packageVersion;

  @override
  Widget build(BuildContext context) {
    return AppAdaptiveScaffold(
      selectedIndex:
          Destinations.indexOf(const Key(FavoriteScreen.name), context),
      onSelectedIndexChange: (idx) => Destinations.changeHandler(
        idx,
        context,
      ),
      destinations: Destinations.navs(context),
      body: (context) => CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text('$packageName($packageVersion) Document'),
          ),
          BlocBuilder<FavoritePackageBloc, FavoritePackageState>(
            builder: (context, state) {
              return SliverFillRemaining(
                child: Text('docs: $packageName ($packageVersion)'),
              );
            },
          ),
        ],
      ),
    );
  }
}
