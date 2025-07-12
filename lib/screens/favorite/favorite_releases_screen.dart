import 'package:app_adaptive_widgets/app_adaptive_widgets.dart';
import 'package:favorite_package_bloc/favorite_package_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_hex_pm/destination.dart';
import 'package:mobile_hex_pm/screens/favorite/favorite_release_docs_screen.dart';
import 'package:mobile_hex_pm/screens/favorite/favorite_screen.dart';

class FavoriteReleasesScreen extends StatelessWidget {
  static const name = 'Favorite Releases Screen';
  static const path = ':package_name/releases';
  static const fullPath = '${FavoriteScreen.path}/$path';

  FavoriteReleasesScreen({super.key, required this.packageName});

  final String packageName;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      context.read<FavoritePackageBloc>().add(
            FavoritePackageEventGetReleases(packageName),
          );
    });

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
            title: Text('$packageName Releases'),
          ),
          BlocBuilder<FavoritePackageBloc, FavoritePackageState>(
            builder: (context, state) {
              final releases = state.favoriteReleases[packageName] ?? [];

              return SliverList.builder(
                itemCount: releases.length,
                itemBuilder: (context, idx) {
                  final r = releases[idx];

                  return ListTile(
                    leading: Text('${r.downloads}'),
                    title: SelectableText.rich(
                      TextSpan(
                        text: r.version,
                        children: [
                          TextSpan(text: '   '),
                          TextSpan(text: '${r.meta.buildTools?.join(",")}'),
                        ],
                      ),
                    ),
                    subtitle: SelectableText.rich(
                      TextSpan(
                        children: [
                          for (final entry in (r.requirements ?? {}).entries)
                            TextSpan(
                              text:
                                  '{:${entry.key}, "${entry.value.requirement}", ${entry.value.optional == true ? "optional: true" : ""}},',
                            )
                        ],
                      ),
                    ),
                    trailing: r.hasDocs
                        ? IconButton(
                            onPressed: () {
                              context.goNamed(
                                FavoriteReleaseDocsScreen.name,
                                pathParameters: {
                                  'package_name': packageName,
                                  'package_version': r.version,
                                },
                              );
                            },
                            icon: Icon(Icons.description),
                          )
                        : Icon(Icons.cancel_outlined),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
