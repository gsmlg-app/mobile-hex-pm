import 'package:app_adaptive_widgets/app_adaptive_widgets.dart';
import 'package:app_locale/app_locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hex_doc_bloc/hex_doc_bloc.dart';
import 'package:mobile_hex_pm/destination.dart';
import 'package:mobile_hex_pm/screens/favorite/favorite_release_docs_screen.dart';

class OfflineDocsScreen extends StatefulWidget {
  static const name = 'Offline Docs Screen';
  static const path = '/offline-docs';

  const OfflineDocsScreen({super.key});

  @override
  State<OfflineDocsScreen> createState() => _OfflineDocsScreenState();
}

class _OfflineDocsScreenState extends State<OfflineDocsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HexDocBloc>().add(const HexDocEventList());
  }

  @override
  Widget build(BuildContext context) {
    return AppAdaptiveScaffold(
      selectedIndex:
          Destinations.indexOf(const Key(OfflineDocsScreen.name), context),
      onSelectedIndexChange: (idx) => Destinations.changeHandler(idx, context),
      destinations: Destinations.navs(context),
      body: (context) => CustomScrollView(
        key: const PageStorageKey('offline_docs_scroll_view'),
        slivers: [
          SliverAppBar(
            title: Text(context.l10n.navDownloads),
          ),
          BlocBuilder<HexDocBloc, HexDocState>(
            builder: (context, state) {
              final docs = state.docs;
              final packageNames = docs.keys.toList()..sort();

              return SliverToBoxAdapter(
                child: ExpansionPanelList(
                  expansionCallback: (int index, bool isExpanded) {
                    context.read<HexDocBloc>().add(
                          HexDocEventToggleExpanded(packageNames[index]),
                        );
                  },
                  children:
                      packageNames.map<ExpansionPanel>((String packageName) {
                    return ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return ListTile(
                          title: Text(packageName),
                        );
                      },
                      body: Column(
                        children: docs[packageName]!.map((doc) {
                          return ListTile(
                            title: Text(doc.packageVersion),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.preview),
                                  onPressed: () {
                                    context.goNamed(
                                      FavoriteReleaseDocsScreen.name,
                                      pathParameters: {
                                        'package_name': doc.packageName,
                                        'package_version': doc.packageVersion,
                                      },
                                      queryParameters: {
                                        'parentName': OfflineDocsScreen.name,
                                      },
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title:
                                              Text(context.l10n.deleteDocument),
                                          content: Text(context.l10n
                                              .confirmDeleteDocument(
                                                  doc.packageName,
                                                  doc.packageVersion)),
                                          actions: [
                                            TextButton(
                                              child: Text(context.l10n.cancel),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: Text(context.l10n.delete),
                                              onPressed: () {
                                                context.read<HexDocBloc>().add(
                                                      HexDocEventDelete(
                                                        packageName:
                                                            doc.packageName,
                                                        packageVersion:
                                                            doc.packageVersion,
                                                      ),
                                                    );
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      isExpanded: state.expandedState[packageName] ?? false,
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
