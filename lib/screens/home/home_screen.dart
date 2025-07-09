import 'dart:math';

import 'package:app_adaptive_widgets/app_adaptive_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hex_api/hex_api.dart';
import 'package:mobile_hex_pm/destination.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'Home Screen';
  static const path = '/home';

  HomeScreen({super.key});

  final TextEditingController controller = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double w = screenWidth;
    if (screenHeight < screenWidth) {
      w = screenHeight;
    }

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
            title: Text('HEX Packages'),
          ),
          SliverFillRemaining(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Text(
                    'The package manager for the Erlang and Elixir ecosystem',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                SizedBox(
                  width: max(w * 0.5, 300),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Find packages',
                      border: OutlineInputBorder(),
                      prefixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () async {
                          final search = controller.text;
                          print('search $search');
                          final hexApi = context.read<HexApi>();
                          final api = hexApi.getPackagesApi();
                          final resp = await api.listPackages(search: search);
                          final data = resp.data;
                          print(data);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
