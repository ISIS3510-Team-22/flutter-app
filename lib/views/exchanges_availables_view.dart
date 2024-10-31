import 'package:flutter/material.dart';
import '../constants/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ExchangesView extends StatelessWidget {
  const ExchangesView({super.key});
  final String url1 =
      "https://erasmus-plus.ec.europa.eu/opportunities/opportunities-for-individuals/students/studying-abroad";

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
      ..loadRequest(Uri.parse(url1));
    // Accessing the RecipeViewModel
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkBlueColor,
        foregroundColor: Colors.white,
        title: const Text(
          'EXCHANGES',
          style: headerTextStyle,
        ),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
