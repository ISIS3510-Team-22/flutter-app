import 'package:flutter/material.dart';
import '../constants/constants.dart';
import './web_view.dart';

class NewsView extends StatelessWidget {
  NewsView({super.key});

  final List<NewsItem> newsItems = [
    NewsItem(
      title: "Planear Movilidad Académica",
      subtitle:
          "A continuación, encontrarás la información general para postularte...",
      url: "https://internacionalizacion.uniandes.edu.co/movilidad-academica",
    ),
    NewsItem(
      title: "Intercambio Internacional y Doble Titulación",
      subtitle:
          "Consulta la oferta académica internacional en el Departamento de Ingeniería Mecánica.",
      url:
          "https://mecanica.uniandes.edu.co/estudiantes/pregrado/intercambio-internacional",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkBlueColor,
        foregroundColor: Colors.white,
        title: const Text(
          'NEWS',
          style: headerTextStyle,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: newsItems.length,
          itemBuilder: (context, index) {
            final news = newsItems[index];
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WebView(url: news.url),
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
                      Text(
                        news.subtitle,
                        style: subBodyTextStyle,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
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
