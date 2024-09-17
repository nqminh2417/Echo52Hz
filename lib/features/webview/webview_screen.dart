import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewScreen extends StatefulWidget {
  final String url;
  const WebviewScreen({super.key, required this.url});

  @override
  State<WebviewScreen> createState() => _WebviewScreenState();
}

class _WebviewScreenState extends State<WebviewScreen> {
  WebViewController? _webViewController;

  @override
  void initState() {
    super.initState();

    _webViewController = WebViewController()
      ..loadRequest(Uri.parse(widget.url))
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
  }
  // Future<String> _getValueFromJavascript() async {
  //   final result = await _webViewController?.evaluateJavascript('javascript:myJavascriptFunction()');

  //   return result ?? '';
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Webview'),
      ),
      body: WebViewWidget(controller: _webViewController!),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // final value = await _getValueFromJavascript();
          // print('Value from JavaScript: $value');
          print('Value from JavaScript');
        },
        child: const Icon(Icons.get_app),
      ),
    );
  }
}
