import 'package:app_adaptive_widgets/app_adaptive_widgets.dart';
import 'package:app_locale/app_locale.dart';
import 'package:favorite_package_bloc/favorite_package_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_hex_pm/destination.dart';
import 'package:mobile_hex_pm/screens/favorite/favorite_releases_screen.dart';

class FavoriteScreen extends StatelessWidget {
  static const name = 'Favorite Screen';
  static const path = '/favorite';

  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      context.read<FavoritePackageBloc>().add(FavoritePackageEventInit());
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
            title: Text(context.l10n.favoritePackages),
            centerTitle: true,
            floating: true,
            snap: true,
          ),
          BlocBuilder<FavoritePackageBloc, FavoritePackageState>(
            builder: (context, state) {
              final favorites = state.favorites;

              if (favorites.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite_border,
                          size: 64,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          context.l10n.noFavoritePackages,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          context.l10n.addToFavorite,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SliverList.builder(
                itemCount: favorites.length,
                itemBuilder: (context, idx) {
                  final pkg = favorites[idx];
                  return Slidable(
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            context.read<FavoritePackageBloc>().add(
                                  FavoritePackageEventRemove(pkg.name),
                                );
                          },
                          backgroundColor: colorScheme.error,
                          foregroundColor: colorScheme.onError,
                          icon: Icons.delete,
                          label: context.l10n.delete,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      child: Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: colorScheme.primaryContainer,
                            foregroundColor: colorScheme.onPrimaryContainer,
                            child: Text('${idx + 1}'),
                          ),
                          title: Text(pkg.name),
                          subtitle: Text(pkg.description),
                          onTap: () {
                            context.goNamed(
                              FavoriteReleasesScreen.name,
                              pathParameters: {'package_name': pkg.name},
                            );
                          },
                        ),
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
