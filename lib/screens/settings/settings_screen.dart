import 'package:app_adaptive_widgets/app_adaptive_widgets.dart';
import 'package:app_feedback/app_feedback.dart';
import 'package:app_locale/app_locale.dart';
import 'package:duskmoon_theme/duskmoon_theme.dart';
import 'package:duskmoon_theme_bloc/duskmoon_theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_hex_pm/destination.dart';
import 'package:mobile_hex_pm/screens/settings/hex_data_screen.dart';
import 'package:mobile_hex_pm/screens/settings/hex_settings_screen.dart';
import 'package:mobile_hex_pm/screens/settings/server_control_screen.dart';
import 'package:mobile_hex_pm/screens/settings/server_config_screen.dart';
import 'package:duskmoon_settings/duskmoon_settings.dart';

class SettingsScreen extends StatelessWidget {
  static const name = 'Settings';
  static const path = '/settings';

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppAdaptiveScaffold(
      selectedIndex: Destinations.indexOf(const Key(name), context),
      onSelectedIndexChange: (idx) => Destinations.changeHandler(
        idx,
        context,
      ),
      destinations: Destinations.navs(context),
      body: (context) {
        final themeBloc = context.read<DmThemeBloc>();
        final isLight = Theme.of(context).brightness == Brightness.light;
        return SafeArea(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                title: Text(context.l10n.settingsTitle),
                centerTitle: true,
                floating: true,
                snap: true,
              ),
              SliverFillRemaining(
                child: BlocBuilder<DmThemeBloc, DmThemeState>(
                  bloc: themeBloc,
                  builder: (context, state) {
                    final entry = state.entry;
                    final colorScheme = isLight
                        ? entry.light.colorScheme
                        : entry.dark.colorScheme;
                    return SettingsList(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      sections: [
                        SettingsSection(
                          title: Text(context.l10n.hexSection),
                          tiles: <SettingsTile>[
                            SettingsTile.navigation(
                              leading: const Icon(Icons.api),
                              title: Text(context.l10n.hexAPI),
                              onPressed: (context) {
                                context.goNamed(HexSettingsScreen.name);
                              },
                            ),
                            SettingsTile.navigation(
                              leading: const Icon(Icons.storage),
                              title: Text(context.l10n.hexData),
                              onPressed: (context) {
                                context.goNamed(HexDataScreen.name);
                              },
                            ),
                          ],
                        ),
                        SettingsSection(
                          title: Text(context.l10n.serverSettings),
                          tiles: <SettingsTile>[
                            SettingsTile.navigation(
                              leading: const Icon(Icons.power_settings_new),
                              title: Text(context.l10n.serverControl),
                              onPressed: (context) {
                                context.goNamed(ServerControlScreen.name);
                              },
                            ),
                            SettingsTile.navigation(
                              leading: const Icon(Icons.settings),
                              title: Text(context.l10n.serverConfiguration),
                              onPressed: (context) {
                                context.goNamed(ServerConfigScreen.name);
                              },
                            )
                          ],
                        ),
                        SettingsSection(
                          title: Text(context.l10n.smenuTheme),
                          tiles: <SettingsTile>[
                            SettingsTile.navigation(
                              leading: const Icon(Icons.brightness_medium),
                              title: Text(context.l10n.appearance),
                              value: state.themeMode.icon,
                              onPressed: (context) {
                                showBottomSheetActionList(
                                  context: context,
                                  actions: [
                                    BottomSheetAction(
                                      title: ThemeMode.light.icon,
                                      onTap: () {
                                        themeBloc.add(
                                          const DmSetThemeMode(
                                            ThemeMode.light,
                                          ),
                                        );
                                      },
                                    ),
                                    BottomSheetAction(
                                      title: ThemeMode.dark.icon,
                                      onTap: () {
                                        themeBloc.add(
                                          const DmSetThemeMode(
                                            ThemeMode.dark,
                                          ),
                                        );
                                      },
                                    ),
                                    BottomSheetAction(
                                      title: ThemeMode.system.icon,
                                      onTap: () {
                                        themeBloc.add(
                                          const DmSetThemeMode(
                                            ThemeMode.system,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                            SettingsTile.navigation(
                              leading: const Icon(Icons.format_paint),
                              title: Text(context.l10n.accentColor),
                              value: SizedBox(
                                width: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .fontSize! *
                                    6,
                                height: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .fontSize,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .fontSize,
                                        decoration: BoxDecoration(
                                          color: colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .fontSize,
                                        decoration: BoxDecoration(
                                          color: colorScheme.secondary,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .fontSize,
                                        decoration: BoxDecoration(
                                          color: colorScheme.tertiary,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .fontSize,
                                    )
                                  ],
                                ),
                              ),
                              onPressed: (context) {
                                showBottomSheetActionList(
                                  context: context,
                                  actions:
                                      DmThemeData.themes.map((themeEntry) {
                                    return BottomSheetAction(
                                      title: Text(themeEntry.name),
                                      onTap: () {
                                        themeBloc.add(
                                          DmSetTheme(themeEntry.name),
                                        );
                                      },
                                    );
                                  }).toList(),
                                );
                              },
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
      smallSecondaryBody: DmAdaptiveScaffold.emptyBuilder,
    );
  }
}
