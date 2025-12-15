import 'package:app_adaptive_widgets/app_adaptive_widgets.dart';
import 'package:app_feedback/app_feedback.dart';
import 'package:app_locale/app_locale.dart';
import 'package:favorite_package_bloc/favorite_package_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hex_doc_bloc/hex_doc_bloc.dart';
import 'package:mobile_hex_pm/destination.dart';
import 'package:mobile_hex_pm/screens/settings/settings_screen.dart';
import 'package:settings_ui/settings_ui.dart';

class HexDataScreen extends StatelessWidget {
  static const name = 'Hex Data';
  static const path = 'hex-data';

  const HexDataScreen({super.key});

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
        return SafeArea(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                title: Text(context.l10n.hexData),
              ),
              SliverFillRemaining(
                child: SettingsList(
                  sections: [
                    SettingsSection(
                      title: Text(context.l10n.hexData),
                      tiles: <SettingsTile>[
                        SettingsTile(
                          leading: const Icon(
                            Icons.delete_sweep,
                            color: Colors.orange,
                          ),
                          title: Text(context.l10n.resetDownloadedDocs),
                          onPressed: (context) {
                            _showResetDocsDialog(context);
                          },
                        ),
                        SettingsTile(
                          leading: const Icon(
                            Icons.delete_forever,
                            color: Colors.red,
                          ),
                          title: Text(context.l10n.resetFavoritePackages),
                          onPressed: (context) {
                            _showResetFavoritesDialog(context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      smallSecondaryBody: AdaptiveScaffold.emptyBuilder,
    );
  }

  void _showResetDocsDialog(BuildContext context) {
    showAppDialog(
      context: context,
      title: Text(context.l10n.resetDownloadedDocs),
      content: Text(context.l10n.confirmResetDownloadedDocs),
      actions: [
        AppDialogAction(
          onPressed: (ctx) {
            context.read<HexDocBloc>().add(const HexDocEventDeleteAll());
            Navigator.of(ctx).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.l10n.resetSuccessful)),
            );
          },
          child: Text(
            context.l10n.ok,
            style: const TextStyle(color: Colors.red),
          ),
        ),
        AppDialogAction(
          onPressed: (ctx) {
            Navigator.of(ctx).pop();
          },
          child: Text(context.l10n.cancel),
        ),
      ],
    );
  }

  void _showResetFavoritesDialog(BuildContext context) {
    showAppDialog(
      context: context,
      title: Text(context.l10n.resetFavoritePackages),
      content: Text(context.l10n.confirmResetFavoritePackages),
      actions: [
        AppDialogAction(
          onPressed: (ctx) {
            context
                .read<FavoritePackageBloc>()
                .add(const FavoritePackageEventResetAll());
            Navigator.of(ctx).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.l10n.resetSuccessful)),
            );
          },
          child: Text(
            context.l10n.ok,
            style: const TextStyle(color: Colors.red),
          ),
        ),
        AppDialogAction(
          onPressed: (ctx) {
            Navigator.of(ctx).pop();
          },
          child: Text(context.l10n.cancel),
        ),
      ],
    );
  }
}
