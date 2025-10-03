import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LocalHtmlViewer extends StatefulWidget {
  const LocalHtmlViewer({
    super.key,
    required this.indexFile,
  });

  final String indexFile;

  @override
  State<LocalHtmlViewer> createState() => _LocalHtmlViewerState();
}

class _LocalHtmlViewerState extends State<LocalHtmlViewer> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..enableZoom(true)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            // Inject CSS to improve scrolling behavior
            _controller.runJavaScript('''
              document.body.style.overflow = 'auto';
              document.body.style.webkitOverflowScrolling = 'touch';
              document.documentElement.style.overflow = 'auto';
              document.documentElement.style.webkitOverflowScrolling = 'touch';
            ''');
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
      gestureRecognizers: {
        Factory<VerticalDragGestureRecognizer>(
          () => VerticalDragGestureRecognizer(),
        ),
        Factory<HorizontalDragGestureRecognizer>(
          () => HorizontalDragGestureRecognizer(),
        ),
        Factory<ScaleGestureRecognizer>(
          () => ScaleGestureRecognizer(),
        ),
        Factory<TapGestureRecognizer>(
          () => TapGestureRecognizer(),
        ),
      },
    );
  }
}
