import 'package:app_adaptive_widgets/app_adaptive_widgets.dart';
import 'package:app_locale/app_locale.dart';
import 'package:app_database/app_database.dart';
import 'package:app_feedback/app_feedback.dart';
import 'package:favorite_package_bloc/favorite_package_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:hex_api/hex_api.dart';
import 'package:hex_search_bloc/hex_search_bloc.dart';
import 'package:mobile_hex_pm/destination.dart';
import 'package:mobile_hex_pm/screens/home/home_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeResultScreen extends StatelessWidget {
  static const name = 'Home Screen Search Result';
  static const path = 'search/:package_name/result';
  static const fullPath = '${HomeScreen.path}/$path';

  HomeResultScreen({super.key, required this.packageName});

  final String packageName;

  @override
  Widget build(BuildContext context) {
    final formBloc = context.read<HexSearchFormBloc>();
    final hexSearchBloc = context.read<HexSearchBloc>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppAdaptiveScaffold(
      selectedIndex: Destinations.indexOf(const Key(HomeScreen.name), context),
      onSelectedIndexChange: (idx) => Destinations.changeHandler(
        idx,
        context,
      ),
      destinations: Destinations.navs(context),
      body: (context) => CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text(context.l10n.search),
            centerTitle: true,
            floating: true,
            snap: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: FormBlocListener<HexSearchFormBloc, String, String>(
                formBloc: formBloc,
                onSuccess: (context, state) {
                  final name = state.successResponse!;
                  hexSearchBloc.add(HexSearchEventSearch(name));
                },
                child: Card(
                  color: colorScheme.surfaceContainerLow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFieldBlocBuilder(
                            textFieldBloc: formBloc.searchName,
                            onSubmitted: (value) => formBloc.submit(),
                            suffixButton: SuffixButton.clearText,
                            autofillHints: const [AutofillHints.name],
                            obscureText: false,
                            autocorrect: false,
                            enableSuggestions: false,
                            decoration: InputDecoration(
                              hintText: context.l10n.searchPackages,
                              prefixIcon: const Icon(Icons.search),
                              border: InputBorder.none,
                              filled: false,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        FilledButton.icon(
                          onPressed: formBloc.submit,
                          icon: const Icon(Icons.search),
                          label: Text(context.l10n.search),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          BlocBuilder<HexSearchBloc, HexSearchState>(
            builder: (context, state) {
              if (state.isLoading) {
                return SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                );
              }

              // Handle error state
              if (state.error != null) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        SizedBox(height: 16),
                        Text(
                          context.l10n.searchError,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          context.l10n.failedToLoadPackages,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.6),
                                  ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          context.l10n.pleaseTryAgain,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.5),
                                  ),
                        ),
                        SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: () {
                            final currentSearch = context
                                .read<HexSearchFormBloc>()
                                .searchName
                                .value;
                            if (currentSearch.isNotEmpty) {
                              context.read<HexSearchBloc>().add(
                                    HexSearchEventSearch(currentSearch),
                                  );
                            }
                          },
                          icon: const Icon(Icons.refresh),
                          label: Text(context.l10n.retry),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final List<Package> results = state.results;

              // Handle empty results
              if (results.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        SizedBox(height: 16),
                        Text(
                          context.l10n.noResultsFound,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        SizedBox(height: 8),
                        Text(
                          context.l10n.noPackagesFound,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.6),
                                  ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          context.l10n.tryDifferentSearch,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.5),
                                  ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SliverList.builder(
                itemBuilder: (context, idx) {
                  final Package pkg = results[idx];
                  final description = pkg.meta.description;

                  if (pkg.releases.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      child: Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: pkg.private == true
                                ? colorScheme.errorContainer
                                : colorScheme.primaryContainer,
                            foregroundColor: pkg.private == true
                                ? colorScheme.onErrorContainer
                                : colorScheme.onPrimaryContainer,
                            child: Icon(
                              pkg.private == true ? Icons.lock : Icons.public,
                            ),
                          ),
                          title: Text(pkg.name),
                          subtitle: Text(context.l10n.packageHasNoReleases),
                          trailing: Icon(
                            Icons.info_outline,
                            color: colorScheme.secondary,
                          ),
                        ),
                      ),
                    );
                  }

                  final lastVersion = pkg.releases.first;
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    child: Card(
                      child: ListTile(
                        onTap: () {
                          showPackage(pkg: pkg, context: context);
                        },
                        leading: CircleAvatar(
                          backgroundColor: pkg.private == true
                              ? colorScheme.errorContainer
                              : colorScheme.primaryContainer,
                          foregroundColor: pkg.private == true
                              ? colorScheme.onErrorContainer
                              : colorScheme.onPrimaryContainer,
                          child: Icon(
                            pkg.private == true ? Icons.lock : Icons.public,
                          ),
                        ),
                        title: Text(
                          pkg.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (description != null && description.isNotEmpty)
                              Text(
                                description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            const SizedBox(height: 4),
                            Text(
                              lastVersion.version ?? '',
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: colorScheme.secondary,
                              ),
                            ),
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${pkg.downloads.all}',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              context.l10n.downloads,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount: results.length,
              );
            },
          ),
        ],
      ),
    );
  }

  void showPackage({required Package pkg, required BuildContext context}) {
    context.read<HexSearchBloc>().add(
          HexSearchEventGetPackageOwner(
            pkg.name,
          ),
        );
    context.read<HexSearchBloc>().add(
          HexSearchEventGetPackageRelease(
            pkg.name,
            pkg.releases.first.version!,
          ),
        );

    showFullScreenDialog(
      context: context,
      title: SelectableText.rich(
        TextSpan(
          children: [
            TextSpan(
              text: pkg.name,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            TextSpan(text: ' '),
            TextSpan(
              text: pkg.releases.first.version,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
          ],
        ),
      ),
      builder: (context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 32,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(),
                Text(
                  '${pkg.meta.description}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
                Divider(),
                Wrap(
                  spacing: 32,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: 'Created at: '),
                          TextSpan(text: pkg.insertedAt.toIso8601String()),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 24,
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: 'Updated at: '),
                          TextSpan(text: pkg.updatedAt.toIso8601String()),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 24,
                    ),
                    BlocBuilder<FavoritePackageBloc, FavoritePackageState>(
                      builder: (context, state) {
                        final favorites = state.favorites;
                        final isSaved = favorites.any((element) {
                          return element.name == pkg.name;
                        });

                        return FilledButton(
                          onPressed: isSaved
                              ? null
                              : () async {
                                  try {
                                    final database =
                                        context.read<AppDatabase>();
                                    await database
                                        .into(database.favoritePackage)
                                        .insert(
                                          FavoritePackageCompanion.insert(
                                            name: pkg.name,
                                            description:
                                                pkg.meta.description ?? '',
                                            licenses: pkg.meta.licenses ?? [],
                                          ),
                                        );
                                    context.read<FavoritePackageBloc>().add(
                                          FavoritePackageEventInit(),
                                        );
                                  } catch (e) {
                                    debugPrint(e.toString());
                                  }
                                },
                          child: isSaved
                              ? Text(context.l10n.favorite)
                              : Text(context.l10n.addToFavorites),
                        );
                      },
                    ),
                  ],
                ),
                Divider(),
                BlocBuilder<HexSearchBloc, HexSearchState>(
                  buildWhen: (previous, current) =>
                      previous.owners[pkg.name] != current.owners[pkg.name],
                  builder: (context, state) {
                    final ownersMap = state.owners;
                    final owners = ownersMap[pkg.name] ?? <Owner>[];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Owners',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final owner in owners)
                              Chip(
                                label: Text(owner.username),
                                backgroundColor: colorScheme.secondaryContainer,
                                labelStyle:
                                    theme.textTheme.labelLarge?.copyWith(
                                  color: colorScheme.onSecondaryContainer,
                                ),
                              ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                Divider(),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Links',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                          ),
                          TextButton.icon(
                            onPressed: () async {
                              final Uri url = Uri.parse(pkg.docsHtmlUrl ?? '');
                              if (!await launchUrl(url)) {
                                throw 'Could not launch $url';
                              }
                            },
                            icon: const Icon(Icons.cloud_download),
                            label: const Text('Online documentation'),
                          ),
                          for (var entry
                              in pkg.meta.links?.entries ?? {}.entries)
                            TextButton.icon(
                              onPressed: () async {
                                final Uri url = Uri.parse(entry.value ?? '');
                                if (!await launchUrl(url)) {
                                  throw 'Could not launch $url';
                                }
                              },
                              icon: const Icon(Icons.link),
                              label: Text(entry.key ?? ''),
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'License',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                          ),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              for (var license
                                  in pkg.meta.licenses ?? <String>[])
                                Chip(
                                  label: Text(license),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Offline Docs',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${pkg.downloads.day}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                              ),
                              Text(context.l10n.yesterday),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${pkg.downloads.week}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                              ),
                              Text(context.l10n.last7Days),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${pkg.downloads.all}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                              ),
                              Text(context.l10n.allTime),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Versions',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (var release in pkg.releases)
                            Chip(
                              label: Text(release.version ?? ''),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(),
                BlocBuilder<HexSearchBloc, HexSearchState>(
                  buildWhen: (previous, current) =>
                      previous.releases[pkg.name] != current.releases[pkg.name],
                  builder: (context, state) {
                    final releaseMap = state.releases;
                    final release = releaseMap[pkg.name];
                    final requirements =
                        release?.requirements ?? <String, ReleaseRequirement>{};
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Dependencies',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final d in requirements.entries)
                              Chip(
                                label: Text(
                                  "${d.key} ${d.value.requirement}${d.value.optional == true ? ' (optional)' : ''}",
                                ),
                              ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
