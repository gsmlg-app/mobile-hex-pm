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
      body: (context) => BlocBuilder<HexDocBloc, HexDocState>(
        builder: (context, state) {
          final docs = state.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              return ListTile(
                title: Text(doc.packageName),
                subtitle: Text(doc.packageVersion),
                trailing: IconButton(
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
              );
            },
          );
        },
      ),
    );
  }
}
