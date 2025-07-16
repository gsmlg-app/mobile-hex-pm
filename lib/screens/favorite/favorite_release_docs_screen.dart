import 'package:app_adaptive_widgets/app_adaptive_widgets.dart';
import 'package:app_web_view/app_web_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:hex_doc_bloc/hex_doc_bloc.dart';
import 'package:mobile_hex_pm/destination.dart';
import 'package:mobile_hex_pm/screens/favorite/favorite_releases_screen.dart';
import 'package:mobile_hex_pm/screens/favorite/favorite_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class FavoriteReleaseDocsScreen extends StatefulWidget {
  static const name = 'Favorite Release Document Screen';
  static const path = ':package_version/docs';
  static const fullPath = '${FavoriteReleasesScreen.fullPath}/$path';

  FavoriteReleaseDocsScreen({
    super.key,
    required this.packageName,
    required this.packageVersion,
  });

  final String packageName;
  final String packageVersion;

  @override
  State<FavoriteReleaseDocsScreen> createState() =>
      _FavoriteReleaseDocsScreenState();
}

class _FavoriteReleaseDocsScreenState extends State<FavoriteReleaseDocsScreen> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      context.read<HexDocBloc>().add(HexDocEventSetup(
            packageName: widget.packageName,
            packageVersion: widget.packageVersion,
          ));
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
            title: Text(
                '${widget.packageName}(${widget.packageVersion}) Document'),
          ),
          BlocBuilder<HexDocBloc, HexDocState>(
            builder: (context, state) {
              if (state.stats == DocStats.unset) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'Document ${widget.packageName} (${widget.packageVersion}) is not exists',
                    ),
                  ),
                );
              }
              if (state.stats == DocStats.downloading) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'Document ${widget.packageName} (${widget.packageVersion}) is downloading',
                    ),
                  ),
                );
              }
              if (state.stats == DocStats.extracting) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'Document ${widget.packageName} (${widget.packageVersion}) is extracting',
                    ),
                  ),
                );
              }
              if (state.stats == DocStats.error) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'Document ${widget.packageName} (${widget.packageVersion}) setup error',
                    ),
                  ),
                );
              }
              if (Breakpoint.isDesktop(context)) {
                return SliverFillRemaining(
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () =>
                          launchUrl(Uri.parse('file://${state.indexFile}')),
                      child: Text(
                          'Document ${widget.packageName} (${widget.packageVersion}) setup error'),
                    ),
                  ),
                );
              }

              return SliverFillRemaining(
                child: LocalHtmlViewer(
                  indexFile: state.indexFile,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
