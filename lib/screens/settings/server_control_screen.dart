import 'dart:convert';
import 'dart:io';

import 'package:app_adaptive_widgets/app_adaptive_widgets.dart';
import 'package:app_locale/app_locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_hex_pm/destination.dart';
import 'package:mobile_hex_pm/screens/settings/settings_screen.dart';
import 'package:offline_docs_server/offline_docs_server_bloc.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ServerControlScreen extends StatelessWidget {
  static const name = 'Server Control Screen';
  static const path = 'control';

  const ServerControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppAdaptiveScaffold(
      selectedIndex: Destinations.indexOf(const Key(SettingsScreen.name), context),
      onSelectedIndexChange: (idx) => Destinations.changeHandler(idx, context),
      destinations: Destinations.navs(context),
      body: (context) => Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.serverControl),
        ),
        body: BlocProvider(
          create: (context) => OfflineDocsServerBloc(
            context.read(),
          )..add(const OfflineDocsServerConfigRequested()),
          child: BlocConsumer<OfflineDocsServerBloc, OfflineDocsServerState>(
            listener: (context, state) {
              if (state is OfflineDocsServerLoadSuccess) {
                // Show messages based on state changes
                if (state.status == ServerStatus.running) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(context.l10n.serverStartedSuccessfully)),
                  );
                } else if (state.status == ServerStatus.stopped) {
                  // Only show stopped message if it was caused by a user action
                  final currentState = context.findAncestorStateOfType<_ServerControlContentState>();
                  final previousState = currentState?._previousState;
                  if (previousState != null &&
                      previousState is OfflineDocsServerLoadSuccess &&
                      previousState.status == ServerStatus.running) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(context.l10n.serverStoppedSuccessfully)),
                    );
                  }
                } else if (state.status == ServerStatus.error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage ?? context.l10n.serverError),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            builder: (context, state) {
              return ServerControlContent(
                state: state,
                onStartServer: () {
                  context.read<OfflineDocsServerBloc>().add(
                    const OfflineDocsServerStarted(),
                  );
                },
                onStopServer: () {
                  context.read<OfflineDocsServerBloc>().add(
                    const OfflineDocsServerStopped(),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class ServerControlContent extends StatefulWidget {
  final OfflineDocsServerState state;
  final VoidCallback onStartServer;
  final VoidCallback onStopServer;

  const ServerControlContent({
    super.key,
    required this.state,
    required this.onStartServer,
    required this.onStopServer,
  });

  @override
  State<ServerControlContent> createState() => _ServerControlContentState();
}

class _ServerControlContentState extends State<ServerControlContent> {
  OfflineDocsServerState? _previousState;

  @override
  void didUpdateWidget(ServerControlContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state) {
      _previousState = oldWidget.state;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while in initial state
    if (widget.state is OfflineDocsServerInitial) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Show error message if in failure state
    if (widget.state is OfflineDocsServerFailure) {
      final failureState = widget.state as OfflineDocsServerFailure;
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Failed to load server status',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                failureState.error,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context.read<OfflineDocsServerBloc>().add(const OfflineDocsServerConfigRequested());
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    // Show loading indicator while in progress state
    if (widget.state is OfflineDocsServerLoadInProgress) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final isRunning = widget.state is OfflineDocsServerLoadSuccess &&
        (widget.state as OfflineDocsServerLoadSuccess).status == ServerStatus.running;

    final isEnabled = widget.state is OfflineDocsServerLoadSuccess &&
        (widget.state as OfflineDocsServerLoadSuccess).config.enabled;

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Server Status Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      context.l10n.serverStatus,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(width: 8),
                    _buildStatusIndicator(widget.state),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _getStatusText(context, widget.state),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: (!isEnabled || isRunning)
                            ? null
                            : widget.onStartServer,
                        icon: const Icon(Icons.play_arrow),
                        label: Text(context.l10n.startServer),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: (!isRunning) ? null : widget.onStopServer,
                        icon: const Icon(Icons.stop),
                        label: Text(context.l10n.stopServer),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    if (isRunning) ...[
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () {
                          widget.onStopServer();
                          Future.delayed(const Duration(milliseconds: 500), () {
                            widget.onStartServer();
                          });
                        },
                        icon: const Icon(Icons.refresh),
                        tooltip: context.l10n.restartServer,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 16),
                // Debug Info (only shown when server is running)
                if (isRunning) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue[300]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Server Info:',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Colors.blue[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Host: ${(widget.state as OfflineDocsServerLoadSuccess).config.host}',
                          style: TextStyle(color: Colors.blue[700], fontSize: 12),
                        ),
                        Text(
                          'Port: ${(widget.state as OfflineDocsServerLoadSuccess).config.port}',
                          style: TextStyle(color: Colors.blue[700], fontSize: 12),
                        ),
                        Text(
                          'Server Address: ${(widget.state as OfflineDocsServerLoadSuccess).serverAddress ?? "Not set"}',
                          style: TextStyle(color: Colors.blue[700], fontSize: 12),
                        ),
                        Text(
                          'Config URL: ${(widget.state as OfflineDocsServerLoadSuccess).config.serverUrl}',
                          style: TextStyle(color: Colors.blue[700], fontSize: 12),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _checkServerContent(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[600],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            ),
                            child: const Text('Check Server Content'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                // Server Address (only shown when server is running)
                if (isRunning) ...[
                  _buildModernServerAddressSection(context, widget.state as OfflineDocsServerLoadSuccess),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusIndicator(OfflineDocsServerState state) {
    Color color;
    IconData icon;

    if (state is OfflineDocsServerLoadSuccess) {
      switch (state.status) {
        case ServerStatus.running:
          color = Colors.green;
          icon = Icons.check_circle;
          break;
        case ServerStatus.starting:
        case ServerStatus.stopping:
          color = Colors.orange;
          icon = Icons.refresh;
          break;
        case ServerStatus.error:
          color = Colors.red;
          icon = Icons.error;
          break;
        case ServerStatus.stopped:
          color = Colors.grey;
          icon = Icons.stop_circle;
          break;
      }
    } else {
      color = Colors.grey;
      icon = Icons.help_outline;
    }

    return Icon(icon, color: color);
  }

  String _getStatusText(BuildContext context, OfflineDocsServerState state) {
    if (state is OfflineDocsServerLoadSuccess) {
      switch (state.status) {
        case ServerStatus.running:
          return context.l10n.serverRunning;
        case ServerStatus.stopped:
          return context.l10n.serverStopped;
        case ServerStatus.starting:
          return context.l10n.serverStarting;
        case ServerStatus.stopping:
          return context.l10n.serverStopping;
        case ServerStatus.error:
          return state.errorMessage ?? context.l10n.serverError;
      }
    }
    return context.l10n.serverStopped;
  }

  void _openUrl(BuildContext context, String url) async {
    // First verify the server is actually serving content
    await _verifyServerContent(context, url);
  }

  Future<void> _verifyServerContent(BuildContext context, String url) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verifying server content...'),
          duration: Duration(seconds: 1),
        ),
      );

      final uri = Uri.parse(url);
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 3);

      final request = await client.getUrl(uri);
      final response = await request.close();

      final responseBody = await response.transform(utf8.decoder).join();
      final isSuccess = response.statusCode >= 200 && response.statusCode < 300;

      client.close();

      if (isSuccess && responseBody.isNotEmpty) {
        // Server is responding with content, proceed to open
        if (context.mounted) {
          await _launchUrlWithFallback(context, url);
        }
      } else {
        // Server responded but with no content or error
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Server responded but with no content (Status: ${response.statusCode})',
              ),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 3),
            ),
          );

          // Still try to open the URL as it might work in browser
          if (context.mounted) {
            await _launchUrlWithFallback(context, url);
          }
        }
      }
    } catch (e) {
      // debugPrint('Server verification failed: $e');
      // If verification fails, still try to open the URL
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not verify server content: $e'),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 2),
          ),
        );
        await _launchUrlWithFallback(context, url);
      }
    }
  }

  Future<void> _launchUrlWithFallback(BuildContext context, String url) async {
    try {
      final uri = Uri.parse(url);

      // Log the URL for debugging
      // debugPrint('Opening URL: $url');
      // debugPrint('Parsed URI: $uri');

      // Try different launch modes for better compatibility
      bool launched = false;

      // First try external application mode
      try {
        launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (e) {
        // debugPrint('External application mode failed: $e');
      }

      // If external mode fails, try platform default
      if (!launched) {
        try {
          launched = await launchUrl(uri, mode: LaunchMode.platformDefault);
        } catch (e) {
          // debugPrint('Platform default mode failed: $e');
        }
      }

      // If both modes fail, try in-app web view as fallback
      if (!launched) {
        try {
          launched = await launchUrl(uri, mode: LaunchMode.inAppWebView);
        } catch (e) {
          // debugPrint('In-app web view mode failed: $e');
        }
      }

      if (!launched) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Could not launch browser for: $url'),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } else {
        // Success - show brief confirmation
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Opening: $url'),
              duration: const Duration(seconds: 1),
            ),
          );
        }
      }
    } catch (e) {
      // debugPrint('Error opening URL: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening URL: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _checkServerContent(BuildContext context) async {
    try {
      final appSupportDir = await getApplicationSupportDirectory();
      final docsDir = Directory('${appSupportDir.path}/hex_docs');

      debugPrint('Checking server content in: ${docsDir.path}');

      if (await docsDir.exists()) {
        final files = await docsDir.list().toList();
        final fileCount = files.whereType<File>().length;
        final dirCount = files.whereType<Directory>().length;

        // Detailed analysis
        final packageDirs = files.whereType<Directory>().toList();
        final packageNames = packageDirs.map((d) => p.basename(d.path)).toList();

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Found: $dirCount packages, $fileCount files\\nPackages: ${packageNames.take(3).join(', ')}${packageNames.length > 3 ? '...' : ''}',
              ),
              backgroundColor: Colors.blue,
              duration: const Duration(seconds: 4),
            ),
          );
        }

        // Show detailed info in a dialog
        if (context.mounted) {
          _showDetailedContentDialog(context, docsDir, packageDirs, fileCount, dirCount);
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Server directory not found'),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error checking server content: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _showDetailedContentDialog(
    BuildContext context,
    Directory docsDir,
    List<Directory> packageDirs,
    int fileCount,
    int dirCount,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Server Content Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('📁 Base Directory: ${docsDir.path}'),
              Text('📊 Total: $dirCount packages, $fileCount files'),
              const SizedBox(height: 16),
              const Text('📦 Available Packages:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...packageDirs.map((dir) => FutureBuilder<List<FileSystemEntity>>(
                future: dir.list().toList(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final versions = snapshot.data!.whereType<Directory>().length;
                    final files = snapshot.data!.whereType<File>().length;
                    return Padding(
                      padding: const EdgeInsets.only(left: 8, bottom: 4),
                      child: Text(
                        '  • ${p.basename(dir.path)}: $versions versions, $files files',
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              )),
              const SizedBox(height: 16),
              const Text('🔍 Debug Info:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('  • Directory exists: ${docsDir.existsSync()}'),
              Text('  • Directory readable: ${_isDirectoryReadableSync(docsDir)}'),
              Text('  • Has index.html: ${File('${docsDir.path}/index.html').existsSync()}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  bool _isDirectoryReadableSync(Directory dir) {
    try {
      dir.listSync().take(1).toList();
      return true;
    } catch (e) {
      return false;
    }
  }

  Widget _buildModernServerAddressSection(BuildContext context, OfflineDocsServerLoadSuccess state) {
    final serverUrl = state.serverAddress ?? state.config.serverUrl;
    final isLocalhost = serverUrl.contains('localhost') || serverUrl.contains('127.0.0.1');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              isLocalhost ? Icons.computer : Icons.public,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              context.l10n.serverAddress,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const Spacer(),
            if (isLocalhost)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Local',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),

        // Modern URL Display Card
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.surface,
                Theme.of(context).colorScheme.surface.withValues(alpha: 0.95),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // URL Display Section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.link,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Server URL',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            serverUrl,
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Copy Button
                    _buildActionButton(
                      context,
                      icon: Icons.copy,
                      label: 'Copy',
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: () => _copyToClipboard(context, serverUrl),
                    ),
                  ],
                ),
              ),

              // Divider
              Container(
                height: 1,
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
              ),

              // Action Buttons Section
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        context,
                        icon: Icons.open_in_browser,
                        label: 'Open',
                        color: Colors.blue,
                        onPressed: () => _openUrl(context, serverUrl),
                        isExpanded: true,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildActionButton(
                        context,
                        icon: Icons.network_check,
                        label: 'Test',
                        color: Colors.green,
                        onPressed: () => _testServerConnection(context, serverUrl),
                        isExpanded: true,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Connection Status Chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.green.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.circle,
                size: 8,
                color: Colors.green,
              ),
              const SizedBox(width: 6),
              Text(
                'Server Active',
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
    bool isExpanded = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: color,
              ),
              if (isExpanded) ...[
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _copyToClipboard(BuildContext context, String text) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Copied to clipboard: $text',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green.withValues(alpha: 0.1),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to copy: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _testServerConnection(BuildContext context, String url) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Testing server connection...'),
          duration: Duration(seconds: 2),
        ),
      );

      final uri = Uri.parse(url);
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 5);

      final request = await client.getUrl(uri);
      final response = await request.close();

      await response.transform(utf8.decoder).join(); // Read response to complete request
      final isSuccess = response.statusCode >= 200 && response.statusCode < 300;

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isSuccess
                ? '✅ Server is responding! (${response.statusCode})'
                : '❌ Server returned error: ${response.statusCode}',
            ),
            backgroundColor: isSuccess ? Colors.green : Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }

      client.close();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Server connection failed: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}