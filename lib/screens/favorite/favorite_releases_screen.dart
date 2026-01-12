import 'package:app_adaptive_widgets/app_adaptive_widgets.dart';
import 'package:app_locale/app_locale.dart';
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

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
            title: Text(context.l10n.releasesTitle(packageName)),
            centerTitle: true,
            floating: true,
            snap: true,
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
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      child: Card(
                        child: ListTile(
                          leading: const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          title: Text(
                            r.version ?? context.l10n.noReleasesAvailable,
                          ),
                          subtitle: Text(context.l10n.loading),
                        ),
                      ),
                    );
                  }

                  final buildTools = release.meta.buildTools ?? <String>[];
                  final requirements = release.requirements ?? {};

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    child: Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: colorScheme.secondaryContainer,
                          foregroundColor: colorScheme.onSecondaryContainer,
                          child: Text(
                            '${release.downloads}',
                            style: theme.textTheme.labelMedium,
                          ),
                        ),
                        title: Text(
                          release.version,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (buildTools.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: [
                                  for (final tool in buildTools)
                                    Chip(
                                      label: Text(tool),
                                    ),
                                ],
                              ),
                            ],
                            if (requirements.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: [
                                  for (final entry in requirements.entries)
                                    Chip(
                                      label: Text(
                                        "${entry.key} ${entry.value.requirement}",
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ],
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
                      ),
                    ),
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
