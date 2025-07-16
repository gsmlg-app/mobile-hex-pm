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
            FavoritePackageEventGetPackage(packageName),
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
              final releases =
                  state.favoritePackages[packageName]?.releases ?? [];

              return SliverList.builder(
                itemCount: releases.length,
                itemBuilder: (context, idx) {
                  final r = releases[idx];
                  final release =
                      state.favoriteReleases['$packageName-${r.version}'];

                  if (release == null) {
                    if (r.version != null) {
                      context.read<FavoritePackageBloc>().add(
                            FavoritePackageEventGetRelease(
                              packageName,
                              r.version!,
                            ),
                          );
                    }
                    return ListTile(
                      title: Text(r.version ?? 'Unknown version'),
                      subtitle: const Text('Loading...'),
                    );
                  }

                  return ListTile(
                    leading: Text('${release.downloads}'),
                    title: SelectableText.rich(
                      TextSpan(
                        text: release.version,
                        children: [
                          const TextSpan(text: '   '),
                          TextSpan(
                              text: '${release.meta.buildTools?.join(",")}'),
                        ],
                      ),
                    ),
                    subtitle: SelectableText.rich(
                      TextSpan(
                        children: [
                          for (final entry
                              in (release.requirements ?? {}).entries)
                            TextSpan(
                              text:
                                  '{:${entry.key}, "${entry.value.requirement}", ${entry.value.optional == true ? "optional: true" : ""}},',
                            )
                        ],
                      ),
                    ),
                    trailing: release.hasDocs
                        ? IconButton(
                            onPressed: () {
                              context.goNamed(
                                FavoriteReleaseDocsScreen.name,
                                pathParameters: {
                                  'package_name': packageName,
                                  'package_version': release.version,
                                },
                                queryParameters: {
                                  'parentName': FavoriteScreen.name,
                                },
                              );
                            },
                            icon: const Icon(Icons.description),
                          )
                        : const Icon(Icons.cancel_outlined),
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
