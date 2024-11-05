import 'package:flutter/material.dart';
import 'package:studyglide/widgets/customAppBar.dart';
import '../constants/constants.dart';
import './web_view.dart';

class NewsView extends StatelessWidget {
  NewsView({super.key});

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
                  builder: (context) => WebView(url: news.url, appbar: true),
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
                        child: WebView(url: news.url, appbar: false),
                      )
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
