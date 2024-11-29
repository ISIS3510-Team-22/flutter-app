import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:studyglide/widgets/customAppBar.dart';
import '../constants/constants.dart';
import './web_view.dart';

class NewsView extends StatefulWidget {
  const NewsView({super.key});

  @override
  State<NewsView> createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> {
  final List<NewsItem> newsItems = [
    NewsItem(
      title: "Academic Mobility",
      subtitle:
          "A continuación, encontrarás la información general para postularte...",
      url: "https://internacionalizacion.uniandes.edu.co/movilidad-academica",
    ),
    NewsItem(
      title: "Mechanical Engineering International Exchanges",
      subtitle:
          "Consulta la oferta académica internacional en el Departamento de Ingeniería Mecánica.",
      url:
          "https://mecanica.uniandes.edu.co/estudiantes/pregrado/intercambio-internacional",
    ),
  ];

  bool hasInternet = true;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
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
      appBar: const CustomAppBar(
        title: 'NEWS',
        actions: [
          IconButton(
            icon: Icon(Icons.newspaper),
            onPressed: null,
            color: Colors.white,
          ),
        ],
      ),
      body: hasInternet
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: newsItems.length,
                itemBuilder: (context, index) {
                  final news = newsItems[index];
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WebView(
                          url: news.url,
                          appbar: true,
                        ),
                      ),
                    ),
                    child: Card(
                      color: grayBlueColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              news.title,
                              style: bodyTextStyle,
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: 400,
                              height: 300,
                              child: hasInternet
                                  ? WebView(url: news.url, appbar: false)
                                  : const Center(
                                      child: Text(
                                        "No Internet Connection",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        showUnselectedLabels: true,
        unselectedItemColor: darkBlueColor,
        selectedItemColor: darkBlueColor,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/information');
              break;
            case 1:
              Navigator.pushNamed(context, '/chat');
              break;
            case 2:
              Navigator.pushNamed(context, '/news');
              break;
            case 3:
              Navigator.pushNamed(context, '/ai_helper');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: 'Information',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.public),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy),
            label: 'AI Helper',
          ),
        ],
      ),
    );
  }
}

class NewsItem {
  final String title;
  final String subtitle;
  final String url;

  NewsItem({
    required this.title,
    required this.subtitle,
    required this.url,
  });
}
