import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LocalHtmlViewer extends StatefulWidget {
  const LocalHtmlViewer({
    super.key,
    required this.indexFile,
    required this.setSize,
  });

  final String indexFile;

  final Function(Size size) setSize;

  @override
  State<LocalHtmlViewer> createState() => _LocalHtmlViewerState();
}

class _LocalHtmlViewerState extends State<LocalHtmlViewer> {
  late final WebViewController _controller;
  double _webViewHeight = 300;
  double _webViewWidth = 300;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'WidthChannel',
        onMessageReceived: (JavaScriptMessage message) {
          final newWidth = double.tryParse(message.message);
          if (newWidth != null && newWidth != _webViewWidth) {
            setState(() {
              _webViewWidth = newWidth;
              widget.setSize(Size(_webViewWidth, _webViewHeight));
              print('size: $_webViewHeight x $_webViewWidth');
            });
          }
        },
      )
      ..addJavaScriptChannel(
        'HeightChannel',
        onMessageReceived: (JavaScriptMessage message) {
          final newHeight = double.tryParse(message.message);
          if (newHeight != null && newHeight != _webViewHeight) {
            setState(() {
              _webViewHeight = newHeight;
              widget.setSize(Size(_webViewWidth, _webViewHeight));
              print('size: $_webViewHeight x $_webViewWidth');
            });
          }
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) async {
            await _controller.runJavaScript(_getHeightScript());
          },
          onUrlChange: (url) async {
            await _controller.runJavaScript(_getHeightScript());
          },
        ),
      )
      ..loadFile(widget.indexFile);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(
      controller: _controller,
    );
  }

  String _getHeightScript() => '''
    function sendSize() {
      const height = document.body.scrollHeight;
      HeightChannel.postMessage(height.toString());
      const width = document.body.scrollWidth;
      WidthChannel.postMessage(width.toString());
    }

    window.addEventListener('load', sendSize);
    window.addEventListener('resize', sendSize);
    setTimeout(sendSize, 100); // fallback
  ''';
}
