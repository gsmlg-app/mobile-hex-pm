import 'package:app_adaptive_widgets/app_adaptive_widgets.dart';
import 'package:app_locale/app_locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_hex_pm/destination.dart';
import 'package:mobile_hex_pm/screens/settings/settings_screen.dart';
import 'package:offline_docs_server/offline_docs_server_bloc.dart';

class ServerConfigScreen extends StatelessWidget {
  static const name = 'Server Configuration Screen';
  static const path = 'config';

  const ServerConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppAdaptiveScaffold(
      selectedIndex: Destinations.indexOf(const Key(SettingsScreen.name), context),
      onSelectedIndexChange: (idx) => Destinations.changeHandler(idx, context),
      destinations: Destinations.navs(context),
      body: (context) => Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.serverConfiguration),
        ),
        body: BlocProvider(
          create: (context) => OfflineDocsServerBloc(
            context.read(),
          )..add(const OfflineDocsServerConfigRequested()),
          child: BlocConsumer<OfflineDocsServerBloc, OfflineDocsServerState>(
            listener: (context, state) {
              if (state is OfflineDocsServerLoadSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Configuration saved successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else if (state is OfflineDocsServerFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to save configuration: ${state.error}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              return ServerConfigContent(
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
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class ServerConfigContent extends StatefulWidget {
  final OfflineDocsServerState state;
  final Function(String host, int port, bool autoStart, bool enabled) onSaveConfig;

  const ServerConfigContent({
    super.key,
    required this.state,
    required this.onSaveConfig,
  });

  @override
  State<ServerConfigContent> createState() => _ServerConfigContentState();
}

class _ServerConfigContentState extends State<ServerConfigContent> {
  final _hostController = TextEditingController();
  final _portController = TextEditingController();
  bool _autoStart = false;
  bool _enabled = true;

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
  void didUpdateWidget(ServerConfigContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state) {
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
                'Failed to load server configuration',
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
                  enabled: !isRunning,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _portController,
                  decoration: InputDecoration(
                    labelText: context.l10n.serverPort,
                    border: const OutlineInputBorder(),
                  ),
                  enabled: !isRunning,
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
                    onPressed: (isRunning) ? null : () => _saveConfig(context),
                    child: const Text('Save Configuration'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
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
}