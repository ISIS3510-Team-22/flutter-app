import 'package:flutter/material.dart';
import '../constants/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebView extends StatelessWidget {
  final String url;
  final bool appbar;

  const WebView({super.key, required this.url, required this.appbar});

  @override
  Widget build(BuildContext context) {
    var controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));

    return Scaffold(
      appBar: appbar
          ? AppBar(
              backgroundColor: darkBlueColor,
              foregroundColor: Colors.white,
              title: const Text(
                'WEBPAGE',
                style: headerTextStyle,
              ),
              centerTitle: true,
            )
          : null,
      body: WebViewWidget(controller: controller),
    );
  }
}
