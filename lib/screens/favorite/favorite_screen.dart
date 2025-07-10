import 'package:app_adaptive_widgets/app_adaptive_widgets.dart';
import 'package:flutter/material.dart';
import 'package:mobile_hex_pm/destination.dart';

class FavoriteScreen extends StatelessWidget {
  static const name = 'Favorite Screen';
  static const path = '/favorite';

  FavoriteScreen({super.key});

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
            title: Text('Favorite Packages'),
          ),
          SliverList.list(children: [
            ListTile(
              leading: Text('1'),
              title: Text('nx'),
            ),
            ListTile(
              leading: Text('2'),
              title: Text('bumblebee'),
            ),
            ListTile(
              leading: Text('3'),
              title: Text('phoenix'),
            ),
            ListTile(
              leading: Text('4'),
              title: Text('elixir'),
            ),
          ]),
        ],
      ),
    );
  }
}
