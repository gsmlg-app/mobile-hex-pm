import 'dart:io';

import 'package:app_adaptive_widgets/app_adaptive_widgets.dart';
import 'package:app_locale/app_locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_hex_pm/destination.dart';
import 'package:mobile_hex_pm/screens/settings/settings_screen.dart';
import 'package:offline_docs_server/offline_docs_server_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class ServerSettingsScreen extends StatelessWidget {
  static const name = 'Server Settings Screen';
  static const path = '/settings/server';

  const ServerSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppAdaptiveScaffold(
      selectedIndex: Destinations.indexOf(const Key(SettingsScreen.name), context),
      onSelectedIndexChange: (idx) => Destinations.changeHandler(idx, context),
      destinations: Destinations.navs(context),
      body: (context) => Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.serverSettings),
        ),
        body: BlocProvider(
          create: (context) => OfflineDocsServerBloc(
            context.read(),
          )..add(const OfflineDocsServerConfigRequested()),
          child: BlocConsumer<OfflineDocsServerBloc, OfflineDocsServerState>(
            listener: (context, state) {
              if (state is OfflineDocsServerLoadSuccess) {
                // Get reference to the current widget state to track previous state
                final currentState = context.findAncestorStateOfType<_ServerSettingsContentState>();

                // Show messages based on state changes
                if (state.status == ServerStatus.running) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(context.l10n.serverStartedSuccessfully)),
                  );
                } else if (state.status == ServerStatus.stopped) {
                  // Only show stopped message if it was caused by a user action
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
              return ServerSettingsContent(
                state: state,
                onSaveConfig: (host, port, autoStart, enabled) {
                  context.read<OfflineDocsServerBloc>().add(
                    OfflineDocsServerConfigUpdated(
                      host: host,
                      port: port,
                      autoStart: autoStart,
                      enabled: enabled,
                    ),
                  );
                  // Show save success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Configuration saved successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
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

class ServerSettingsContent extends StatefulWidget {
  final OfflineDocsServerState state;
  final Function(String host, int port, bool autoStart, bool enabled) onSaveConfig;
  final VoidCallback onStartServer;
  final VoidCallback onStopServer;

  const ServerSettingsContent({
    super.key,
    required this.state,
    required this.onSaveConfig,
    required this.onStartServer,
    required this.onStopServer,
  });

  @override
  State<ServerSettingsContent> createState() => _ServerSettingsContentState();
}

class _ServerSettingsContentState extends State<ServerSettingsContent> {
  final _hostController = TextEditingController();
  final _portController = TextEditingController();
  bool _autoStart = false;
  bool _enabled = true;
  OfflineDocsServerState? _previousState;

  @override
  void initState() {
    super.initState();
    // Initialize form fields with default values
    _initializeFormFields();
    _updateFormFields();
  }

  void _initializeFormFields() {
    // Set default values to prevent empty fields
    _hostController.text = 'localhost';
    _portController.text = '8080';
    _autoStart = false;
    _enabled = true;
  }

  @override
  void didUpdateWidget(ServerSettingsContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state) {
      _previousState = oldWidget.state;
      _updateFormFields();
    }
  }

  @override
  void dispose() {
    _hostController.dispose();
    _portController.dispose();
    super.dispose();
  }

  void _updateFormFields() {
    if (widget.state is OfflineDocsServerLoadSuccess) {
      final state = widget.state as OfflineDocsServerLoadSuccess;
      final config = state.config;

      // Only update if values are different to avoid unnecessary rebuilds
      if (_hostController.text != config.host) {
        _hostController.text = config.host;
      }
      if (_portController.text != config.port.toString()) {
        _portController.text = config.port.toString();
      }
      if (_autoStart != config.autoStart) {
        _autoStart = config.autoStart;
      }
      if (_enabled != config.enabled) {
        _enabled = config.enabled;
      }

      // Trigger a rebuild to update the UI
      if (mounted) {
        setState(() {});
      }
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
                'Failed to load server settings',
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
                        onPressed: (!_enabled || isRunning)
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
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Server Configuration Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.serverConfig,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _hostController,
                  decoration: InputDecoration(
                    labelText: context.l10n.serverHost,
                    border: const OutlineInputBorder(),
                  ),
                  enabled: !_enabled || !isRunning,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _portController,
                  decoration: InputDecoration(
                    labelText: context.l10n.serverPort,
                    border: const OutlineInputBorder(),
                  ),
                  enabled: !_enabled || !isRunning,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: Text(context.l10n.enableServer),
                  subtitle: Text(context.l10n.serverNotRunning),
                  value: _enabled,
                  onChanged: (!isRunning) ? (value) => setState(() => _enabled = value) : null,
                ),
                SwitchListTile(
                  title: Text(context.l10n.autoStartServer),
                  subtitle: Text('Start server automatically when app opens'),
                  value: _autoStart,
                  onChanged: (!isRunning && _enabled) ? (value) => setState(() => _autoStart = value) : null,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (isRunning || !_enabled) ? null : () => _saveConfig(context),
                    child: const Text('Save Configuration'),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Server Info Card (only shown when server is running)
        if (widget.state is OfflineDocsServerLoadSuccess &&
            (widget.state as OfflineDocsServerLoadSuccess).status == ServerStatus.running)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.serverAddress,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            (widget.state as OfflineDocsServerLoadSuccess).serverAddress ??
                            (widget.state as OfflineDocsServerLoadSuccess).config.serverUrl,
                            style: const TextStyle(fontFamily: 'monospace'),
                          ),
                        ),
                        IconButton(
                          onPressed: () => _copyToClipboard(
                            context,
                            (widget.state as OfflineDocsServerLoadSuccess).serverAddress ??
                            (widget.state as OfflineDocsServerLoadSuccess).config.serverUrl,
                          ),
                          icon: const Icon(Icons.copy),
                          tooltip: 'Copy URL',
                        ),
                        if (Platform.isAndroid || Platform.isIOS)
                          IconButton(
                            onPressed: () => _shareUrl(
                              context,
                              (widget.state as OfflineDocsServerLoadSuccess).serverAddress ??
                              (widget.state as OfflineDocsServerLoadSuccess).config.serverUrl,
                            ),
                            icon: const Icon(Icons.share),
                            tooltip: context.l10n.shareServerUrl,
                          ),
                        IconButton(
                          onPressed: () => _openUrl(
                            context,
                            (widget.state as OfflineDocsServerLoadSuccess).serverAddress ??
                            (widget.state as OfflineDocsServerLoadSuccess).config.serverUrl,
                          ),
                          icon: const Icon(Icons.open_in_browser),
                          tooltip: 'Open in browser',
                        ),
                      ],
                    ),
                  ),
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

  void _saveConfig(BuildContext context) {
    final port = int.tryParse(_portController.text);
    if (port == null || port < 1 || port > 65535) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid port number (1-65535)'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_hostController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid host'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    widget.onSaveConfig(
      _hostController.text.trim(),
      port,
      _autoStart,
      _enabled,
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    // TODO: Implement clipboard functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('URL copied to clipboard')),
    );
  }

  void _shareUrl(BuildContext context, String url) {
    // TODO: Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share functionality coming soon')),
    );
  }

  void _openUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $url')),
        );
      }
    }
  }
}