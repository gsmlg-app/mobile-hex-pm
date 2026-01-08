import 'package:app_adaptive_widgets/app_adaptive_widgets.dart';
import 'package:app_locale/app_locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hex_doc_bloc/hex_doc_bloc.dart';
import 'package:mobile_hex_pm/destination.dart';
import 'package:mobile_hex_pm/screens/favorite/favorite_release_docs_screen.dart';
import 'package:offline_docs_server/offline_docs_server_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

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
    context.read<OfflineDocsServerBloc>().add(const OfflineDocsServerConfigRequested());
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
          // Server Control Panel
          SliverToBoxAdapter(
            child: _ServerControlPanel(),
          ),
          BlocBuilder<HexDocBloc, HexDocState>(
            builder: (context, state) {
              final docs = state.docs;
              final packageNames = docs.keys.toList()..sort();

              if (packageNames.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.download_outlined,
                          size: 64,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          context.l10n.noDownloadedDocs,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          context.l10n.downloadDocsInstruction,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }

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

class _ServerControlPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<OfflineDocsServerBloc, OfflineDocsServerState>(
      builder: (context, state) {
        if (state is! OfflineDocsServerLoadSuccess) {
          return const SizedBox.shrink();
        }

        final isRunning = state.status == ServerStatus.running;
        final isStarting = state.status == ServerStatus.starting;
        final isStopping = state.status == ServerStatus.stopping;
        final serverUrl = state.serverAddress ?? state.config.serverUrl;

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isRunning
                    ? [
                        colorScheme.primaryContainer,
                        colorScheme.tertiaryContainer,
                      ]
                    : [
                        colorScheme.surfaceContainerHighest,
                        colorScheme.surfaceContainerHigh,
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isRunning
                    ? colorScheme.primary.withAlpha(50)
                    : colorScheme.outline.withAlpha(50),
              ),
            ),
            child: Column(
              children: [
                // Header Row
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isRunning
                              ? Colors.green.withAlpha(30)
                              : colorScheme.onSurface.withAlpha(20),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          isRunning ? Icons.dns : Icons.dns_outlined,
                          color: isRunning ? Colors.green : colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.l10n.docsServer,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isRunning
                                        ? Colors.green
                                        : isStarting || isStopping
                                            ? Colors.orange
                                            : colorScheme.outline,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  _getStatusText(context, state.status),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: isRunning
                                        ? Colors.green.shade700
                                        : colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Start/Stop Button
                      if (isStarting || isStopping)
                        const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      else
                        FilledButton.icon(
                          onPressed: () {
                            if (isRunning) {
                              context.read<OfflineDocsServerBloc>().add(
                                    const OfflineDocsServerStopped(),
                                  );
                            } else {
                              context.read<OfflineDocsServerBloc>().add(
                                    const OfflineDocsServerStarted(),
                                  );
                            }
                          },
                          icon: Icon(isRunning ? Icons.stop : Icons.play_arrow),
                          label: Text(isRunning
                              ? context.l10n.stopServer
                              : context.l10n.startServer),
                          style: FilledButton.styleFrom(
                            backgroundColor:
                                isRunning ? Colors.red : colorScheme.primary,
                          ),
                        ),
                    ],
                  ),
                ),
                // Server URL (only when running)
                if (isRunning) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.surface.withAlpha(200),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.link,
                          size: 18,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            serverUrl,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontFamily: 'monospace',
                              color: colorScheme.onSurface,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy, size: 20),
                          tooltip: context.l10n.copy,
                          onPressed: () async {
                            await Clipboard.setData(ClipboardData(text: serverUrl));
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(context.l10n.copiedToClipboard),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.open_in_browser, size: 20),
                          tooltip: context.l10n.openInBrowser,
                          onPressed: () async {
                            final uri = Uri.parse(serverUrl);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  String _getStatusText(BuildContext context, ServerStatus status) {
    switch (status) {
      case ServerStatus.running:
        return context.l10n.serverRunning;
      case ServerStatus.stopped:
        return context.l10n.serverStopped;
      case ServerStatus.starting:
        return context.l10n.serverStarting;
      case ServerStatus.stopping:
        return context.l10n.serverStopping;
      case ServerStatus.error:
        return context.l10n.serverError;
    }
  }
}
