import 'dart:io';

import 'package:app_adaptive_widgets/app_adaptive_widgets.dart';
import 'package:app_feedback/app_feedback.dart';
import 'package:app_locale/app_locale.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hex_auth_bloc/hex_auth_bloc.dart';
import 'package:mobile_hex_pm/destination.dart';
import 'package:mobile_hex_pm/screens/settings/settings_screen.dart';
import 'package:settings_ui/settings_ui.dart';

class HexSettingsScreen extends StatelessWidget {
  static const name = 'Hex Settings';
  static const path = '/settings/hex';

  HexSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppAdaptiveScaffold(
      selectedIndex: Destinations.indexOf(
        const Key(SettingsScreen.name),
        context,
      ),
      onSelectedIndexChange: (idx) => Destinations.changeHandler(
        idx,
        context,
      ),
      destinations: Destinations.navs(context),
      body: (context) {
        final bloc = context.read<HexAuthBloc>();
        final user = bloc.state.currenUser;
        final token = bloc.state.apiKey;

        return SafeArea(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                title: Text(context.l10n.settingsTitle),
              ),
              SliverFillRemaining(
                child: BlocBuilder<HexAuthBloc, HexAuthState>(
                  builder: (context, state) {
                    return SettingsList(
                      sections: [
                        SettingsSection(
                          title: Text('Hex API'),
                          tiles: <SettingsTile>[
                            SettingsTile(
                              leading: const Icon(Icons.api),
                              title: Center(
                                child: Text(
                                  'HEX_API_KEY',
                                ),
                              ),
                              trailing: token == null
                                  ? Text('Not set')
                                  : Text('******'),
                              onPressed: (context) {
                                showSetApiDialog(context);
                              },
                              description: state.error != null
                                  ? Text(
                                      state.error.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error,
                                          ),
                                    )
                                  : null,
                            ),
                            if (token != null)
                              SettingsTile(
                                leading: const Icon(
                                  Icons.delete_forever_rounded,
                                  color: Colors.red,
                                ),
                                title: Center(
                                  child: Text(
                                    'Remove API Key',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                                onPressed: (context) {
                                  showRemoveApiDialog(context);
                                },
                              ),
                          ],
                        ),
                        if (user != null)
                          SettingsSection(
                            title: Text('Hex User'),
                            tiles: <SettingsTile>[
                              SettingsTile(
                                leading: const Icon(Icons.account_box),
                                title: Center(
                                  child: Text(
                                    'Username',
                                  ),
                                ),
                                trailing: Text(user.username),
                              ),
                              SettingsTile(
                                leading: const Icon(Icons.email_rounded),
                                title: Center(
                                  child: Text(
                                    'Email',
                                  ),
                                ),
                                trailing: Text(user.email),
                              ),
                              SettingsTile(
                                leading: const Icon(Icons.link_sharp),
                                title: Center(
                                  child: Text(
                                    'URL',
                                  ),
                                ),
                                trailing: Text(user.url),
                              ),
                              SettingsTile(
                                leading: const Icon(Icons.group_rounded),
                                title: Center(
                                  child: Text(
                                    'Organization',
                                  ),
                                ),
                                trailing: Column(
                                  children: [
                                    for (var org in user.organizations)
                                      Text(org.name)
                                  ],
                                ),
                              ),
                            ],
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
      smallSecondaryBody: AdaptiveScaffold.emptyBuilder,
    );
  }

  final TextEditingController controller = TextEditingController(text: '');

  void showSetApiDialog(BuildContext context) {
    showAppDialog(
      context: context,
      title: Text('Set hex.pm API Key'),
      content: Column(
        children: [
          SizedBox(
            height: 18,
          ),
          Platform.isIOS || Platform.isMacOS
              ? CupertinoTextField(
                  controller: controller,
                  placeholder: 'HEX_API_KEY',
                )
              : TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'HEX_API_KEY',
                  ),
                ),
          SizedBox(
            height: 18,
          ),
        ],
      ),
      actions: [
        AppDialogAction(
          onPressed: (context) {
            final apkKey = controller.text.trim();
            if (apkKey.isNotEmpty) {
              context.read<HexAuthBloc>().add(
                    HexAuthEventLogin(apkKey),
                  );
              Navigator.of(context).pop();
            }
          },
          child: Text(
            context.l10n.ok,
          ),
        ),
        AppDialogAction(
          onPressed: (context) {
            Navigator.of(context).pop();
          },
          child: Text(
            context.l10n.cancel,
          ),
        ),
      ],
    );
  }

  void showRemoveApiDialog(BuildContext context) {
    showAppDialog(
      context: context,
      title: Text('Remove API Key'),
      content: Text('Are you sure you want to remove the API key?'),
      actions: [
        AppDialogAction(
          onPressed: (context) {
            context.read<HexAuthBloc>().add(HexAuthEventLogout());
            Navigator.of(context).pop();
          },
          child: Text(
            context.l10n.ok,
          ),
        ),
        AppDialogAction(
          onPressed: (context) {
            Navigator.of(context).pop();
          },
          child: Text(
            context.l10n.cancel,
          ),
        ),
      ],
    );
  }
}

