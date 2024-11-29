import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../constants/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ExchangesView extends StatefulWidget {
  const ExchangesView({super.key});

  @override
  State<ExchangesView> createState() => _ExchangesViewState();
}

class _ExchangesViewState extends State<ExchangesView> {
  final String url1 =
      "https://erasmus-plus.ec.europa.eu/opportunities/opportunities-for-individuals/students/studying-abroad";

  late WebViewController controller;
  bool hasInternet = true;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar if needed
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
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      hasInternet = !connectivityResult.contains(ConnectivityResult.none);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkBlueColor,
        foregroundColor: Colors.white,
        title: const Text(
          'EXCHANGES',
          style: headerTextStyle,
        ),
        centerTitle: true,
      ),
      body: hasInternet
          ? WebViewWidget(controller: controller)
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.wifi_off,
                    size: 64.0,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'No Internet Connection',
                    style: simpleText,
                  ),
                  const SizedBox(height: 8.0),
                  ElevatedButton(
                    onPressed: _checkConnectivity,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
    );
  }
}
