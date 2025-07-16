import 'package:app_adaptive_widgets/app_adaptive_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hex_doc_bloc/hex_doc_bloc.dart';
import 'package:mobile_hex_pm/destination.dart';
import 'package:mobile_hex_pm/screens/favorite/favorite_release_docs_screen.dart';

class DownloadsScreen extends StatefulWidget {
  static const name = 'Downloads Screen';
  static const path = '/downloads';

  const DownloadsScreen({super.key});

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HexDocBloc>().add(const HexDocEventList());
  }

  @override
  Widget build(BuildContext context) {
    return AppAdaptiveScaffold(
      selectedIndex: Destinations.indexOf(const Key(DownloadsScreen.name), context),
      onSelectedIndexChange: (idx) => Destinations.changeHandler(idx, context),
      destinations: Destinations.navs(context),
      body: (context) => CustomScrollView(
        key: const PageStorageKey('downloads_scroll_view'),
        slivers: [
          SliverAppBar(
            title: const Text('Downloads'),
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
                                        'parentName': DownloadsScreen.name,
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
                                              const Text('Delete Document'),
                                          content: Text(
                                              'Are you sure you want to delete the document for ${doc.packageName} (${doc.packageVersion})?'),
                                          actions: [
                                            TextButton(
                                              child: const Text('Cancel'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: const Text('Delete'),
                                              onPressed: () {
                                                context
                                                    .read<HexDocBloc>()
                                                    .add(
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
