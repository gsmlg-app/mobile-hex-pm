import 'dart:math';

import 'package:app_adaptive_widgets/app_adaptive_widgets.dart';
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

  HomeResultScreen({super.key, required this.packageName})
      : controller = TextEditingController(text: packageName);

  final String packageName;

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double w = screenWidth;
    if (screenHeight < screenWidth) {
      w = screenHeight;
    }
    final formBloc = context.read<HexSearchFormBloc>();
    final hexSearchBloc = context.read<HexSearchBloc>();

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
            title: FormBlocListener<HexSearchFormBloc, String, String>(
              formBloc: formBloc,
              onSuccess: (context, state) {
                final name = state.successResponse!;
                hexSearchBloc.add(HexSearchEventSearch(name));
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('hex'),
                  SizedBox(
                    width: 12,
                  ),
                  SizedBox(
                    width: max(w * 0.5, 300),
                    height: 84,
                    child: TextFieldBlocBuilder(
                      textFieldBloc: formBloc.searchName,
                      suffixButton: SuffixButton.clearText,
                      autofillHints: const [AutofillHints.name],
                      obscureText: false,
                      autocorrect: false,
                      enableSuggestions: false,
                      decoration: InputDecoration(
                        hintText: 'Find packages',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    height: 54,
                    child: TextButton(
                      onPressed: formBloc.submit,
                      child: Text('Search'),
                    ),
                  ),
                ],
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
              final List<Package> results = state.results;
              return SliverList.builder(
                itemBuilder: (context, idx) {
                  final Package pkg = results[idx];
                  final lastVersion = pkg.releases.first;
                  return ListTile(
                    leading: pkg.private == true
                        ? Icon(Icons.lock)
                        : Icon(Icons.public),
                    title: Text.rich(
                      TextSpan(
                        children: [
                          WidgetSpan(
                            baseline: TextBaseline.alphabetic,
                            alignment: PlaceholderAlignment.middle,
                            child: TextButton(
                              onPressed: () {
                                showPackage(pkg: pkg, context: context);
                              },
                              child: Text(
                                pkg.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                              ),
                            ),
                          ),
                          TextSpan(text: ' '),
                          TextSpan(
                            text: lastVersion.version,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                          ),
                        ],
                      ),
                    ),
                    subtitle: Text('${pkg.meta.description}'),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('${pkg.downloads.all}'),
                        Text('downloads'),
                      ],
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

                        return ElevatedButton(
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
                                    print(e);
                                  }
                                },
                          child: isSaved
                              ? Text('Favorite')
                              : Text('Add to Favorites'),
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
                          spacing: 32,
                          children: [
                            for (final owner in owners)
                              Text(
                                owner.username,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
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
                          TextButton(
                            onPressed: () async {
                              final Uri url = Uri.parse(pkg.docsHtmlUrl ?? '');
                              if (!await launchUrl(url)) {
                                throw 'Could not launch $url';
                              }
                            },
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Online documentation',
                                  ),
                                  TextSpan(text: ' '),
                                  WidgetSpan(child: Icon(Icons.cloud_download)),
                                ],
                              ),
                            ),
                          ),
                          for (var entry
                              in pkg.meta.links?.entries ?? {}.entries)
                            TextButton(
                              onPressed: () async {
                                final Uri url = Uri.parse(entry.value ?? '');
                                if (!await launchUrl(url)) {
                                  throw 'Could not launch $url';
                                }
                              },
                              child: Text(entry.key ?? ''),
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
                          for (var license in pkg.meta.licenses ?? <String>[])
                            Text(license),
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
                        'Downloads',
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
                              Text('yesterday'),
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
                              Text('last 7 days'),
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
                              Text('all time'),
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
                        children: [
                          for (var release in pkg.releases)
                            TextButton(
                              onPressed: () async {},
                              child: Text(
                                release.version ?? '',
                              ),
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
                    final requirements = release?.requirements ??
                        <String, ReleaseRequirementsValue>{};
                    print('requirements: $requirements');
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
                          spacing: 32,
                          children: [
                            for (final d in requirements.entries)
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: d.key,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                    ),
                                    TextSpan(text: ' '),
                                    TextSpan(
                                      text: d.value.requirement,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                    ),
                                  ],
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
