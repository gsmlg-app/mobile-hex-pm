import 'package:app_adaptive_widgets/app_adaptive_widgets.dart';
import 'package:app_web_view/app_web_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hex_doc_bloc/hex_doc_bloc.dart';
import 'package:mobile_hex_pm/destination.dart';
import 'package:mobile_hex_pm/screens/downloads/downloads_screen.dart';
import 'package:mobile_hex_pm/screens/favorite/favorite_releases_screen.dart';
import 'package:mobile_hex_pm/screens/favorite/favorite_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class FavoriteReleaseDocsScreen extends StatefulWidget {
  static const name = 'Favorite Release Document Screen';
  static const path = ':package_version/docs';
  static const fullPath = '${FavoriteReleasesScreen.fullPath}/$path';

  const FavoriteReleaseDocsScreen({
    super.key,
    required this.packageName,
    required this.packageVersion,
    this.parentName,
  });

  final String packageName;
  final String packageVersion;
  final String? parentName;

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
      selectedIndex: widget.parentName == FavoriteScreen.name
          ? Destinations.indexOf(const Key(FavoriteScreen.name), context)
          : Destinations.indexOf(const Key(DownloadsScreen.name), context),
      onSelectedIndexChange: (idx) => Destinations.changeHandler(
        idx,
        context,
      ),
      destinations: Destinations.navs(context),
      body: (context) {
        if (Breakpoint.isDesktop(context)) {
          return BlocBuilder<HexDocBloc, HexDocState>(
            builder: (context, state) {
              if (state.stats == DocStats.ok && state.indexFile.isNotEmpty) {
                return Center(
                  child: ElevatedButton(
                    onPressed: () =>
                        launchUrl(Uri.parse('file://${state.indexFile}')),
                    child: Text(
                        'Document ${widget.packageName} (${widget.packageVersion}) is ready. Click to open.'),
                  ),
                );
              }

              String message;
              switch (state.stats) {
                case DocStats.downloading:
                  message =
                      'Document ${widget.packageName} (${widget.packageVersion}) is downloading';
                  break;
                case DocStats.extracting:
                  message =
                      'Document ${widget.packageName} (${widget.packageVersion}) is extracting';
                  break;
                case DocStats.error:
                  message =
                      'Document ${widget.packageName} (${widget.packageVersion}) setup error';
                  break;
                default:
                  message =
                      'Document ${widget.packageName} (${widget.packageVersion}) is preparing...';
              }

              return Center(
                child: Text(message),
              );
            },
          );
        }
        
        // Mobile layout with proper scrolling
        return Column(
          children: [
            AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    if (widget.parentName == FavoriteScreen.name) {
                      context.goNamed(FavoriteScreen.name);
                    } else {
                      context.goNamed(DownloadsScreen.name);
                    }
                  }
                },
              ),
              title: Text(
                  '${widget.packageName}(${widget.packageVersion}) Document'),
            ),
            Expanded(
              child: BlocBuilder<HexDocBloc, HexDocState>(
                builder: (context, state) {
                  if (state.stats == DocStats.ok && state.indexFile.isNotEmpty) {
                    return LocalHtmlViewer(
                      indexFile: state.indexFile,
                    );
                  }

                  String message;
                  switch (state.stats) {
                    case DocStats.downloading:
                      message =
                          'Document ${widget.packageName} (${widget.packageVersion}) is downloading';
                      break;
                    case DocStats.extracting:
                      message =
                          'Document ${widget.packageName} (${widget.packageVersion}) is extracting';
                      break;
                    case DocStats.error:
                      message =
                          'Document ${widget.packageName} (${widget.packageVersion}) setup error';
                      break;
                    default:
                      message =
                          'Document ${widget.packageName} (${widget.packageVersion}) is preparing...';
                  }

                  return Center(
                    child: Text(message),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
