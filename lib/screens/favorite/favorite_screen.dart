import 'package:app_adaptive_widgets/app_adaptive_widgets.dart';
import 'package:favorite_package_bloc/favorite_package_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:mobile_hex_pm/destination.dart';

class FavoriteScreen extends StatelessWidget {
  static const name = 'Favorite Screen';
  static const path = '/favorite';

  FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      context.read<FavoritePackageBloc>().add(FavoritePackageEventInit());
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
            title: Text('Favorite Packages'),
          ),
          BlocBuilder<FavoritePackageBloc, FavoritePackageState>(
            builder: (context, state) {
              final favorites = state.favorites;

              return SliverList.builder(
                itemCount: favorites.length,
                itemBuilder: (context, idx) {
                  final pkg = favorites[idx];
                  return ListTile(
                    leading: Text('${idx + 1}.'),
                    title: Text(pkg.name),
                    subtitle: Text(pkg.description),
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
