import 'dart:math';

import 'package:app_adaptive_widgets/app_adaptive_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hex_search_bloc/hex_search_bloc.dart';
import 'package:mobile_hex_pm/destination.dart';
import 'package:mobile_hex_pm/screens/home/home_result_screen.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'Home Screen';
  static const path = '/home';

  const HomeScreen({super.key});

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
            title: Text('HEX Packages'),
          ),
          SliverFillRemaining(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Text(
                    'The package manager for the Erlang and Elixir ecosystem',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                FormBlocListener<HexSearchFormBloc, String, String>(
                  formBloc: formBloc,
                  onSuccess: (context, state) {
                    final name = state.successResponse!;
                    hexSearchBloc.add(HexSearchEventSearch(name));
                    context.goNamed(
                      HomeResultScreen.name,
                      pathParameters: {
                        'package_name': name,
                      },
                    );
                  },
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    runAlignment: WrapAlignment.center,
                    children: [
                      SizedBox(
                        width: max(w * 0.5, 400),
                        height: 84,
                        child: TextFieldBlocBuilder(
                          onSubmitted: (v) => formBloc.submit(),
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
                        height: 84,
                        child: Center(
                          child: TextButton(
                            onPressed: formBloc.submit,
                            child: Text('Search'),
                          ),
                        ),
                      ),
                    ],
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
