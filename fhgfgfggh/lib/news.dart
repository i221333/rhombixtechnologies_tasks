import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class News extends StatefulWidget {
  const News({super.key});

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  final dio = Dio();

  // Source display names and their corresponding NewsAPI source IDs
  final Map<String, String> sourceMap = {
    'BBC': 'bbc-news',
    'ARY': 'ary-news',
    'ALJZERA': 'al-jazeera-english',
    'CNN': 'cnn',
  };

  final Map<String, String> sourceDomains = {
    'BBC': 'bbc.co.uk',
    'ARY': 'arynews.tv',
    'ALJZERA': 'aljazeera.com',
    'CNN': 'cnn.com',
  };

  // Initial dropdown value
  String dropdownValue = 'BBC';

  final Map<String, List<dynamic>> _cachedHeadlines = {};
  final Map<String, List<dynamic>> _cachedNews = {};

  Future<List<dynamic>> fetchHeadlines(String sourceId) async {
    if (_cachedHeadlines.containsKey(sourceId)) {
      return _cachedHeadlines[sourceId]!;
    }

    try {
      var response = await dio.get(
        'https://newsapi.org/v2/top-headlines?sources=$sourceId&apiKey=2ecdddebc4d847ddb3be72c181d60f08',
      );
      if (response.statusCode == 200) {
        final articles = response.data['articles'] as List;
        _cachedHeadlines[sourceId] = articles;
        return articles;
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<dynamic>> fetchNews(String sourceId) async {
    if (_cachedNews.containsKey(sourceId)) {
      return _cachedNews[sourceId]!;
    }

    try {
      var response = await dio.get(
        'https://newsapi.org/v2/everything?domains=$sourceId&apiKey=2ecdddebc4d847ddb3be72c181d60f08',
      );
      if (response.statusCode == 200) {
        final articles = response.data['articles'] as List;
        _cachedNews[sourceId] = articles;
        return articles;
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.push(context,  MaterialPageRoute(
              builder: (context) => NewsCat()
            ),
            );
          },
          icon: const Icon(Icons.menu),
        ),
        title: const Center(child: Text('News')),
        actions: [
          DropdownButton(
            padding: EdgeInsets.only(right: 10.0),
            borderRadius: BorderRadius.all(Radius.circular(10)),
            icon: const Icon(Icons.more_vert),
            items: sourceMap.keys.map((String source) {
              return DropdownMenuItem<String>(
                value: source,
                child: Text(source),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder<List<dynamic>>(
                future: fetchHeadlines(sourceMap[dropdownValue]!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No news available'));
                  }
          
                  final articles = snapshot.data!;
          
                  return SizedBox(
                    height: 450, // Set height for horizontal scroll area
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: articles.length,
                      itemBuilder: (context, index) {
                        final article = articles[index];
          
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewsDetailPage(article: article),
                              ),
                            );
                          },
                          child: Container(
                            width: 400,
                            margin: const EdgeInsets.all(5),
                            child: Card(
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  // Fill the card with the image
                                  Positioned.fill(
                                    child: article['urlToImage'] != null
                                        ? Image.network(
                                            article['urlToImage'],
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) =>
                                            const Center(child: Icon(Icons.broken_image)),
                                          )
                                        : Container(color: Colors.grey),
                                  ),
          
                                  // Dark overlay for better text readability
                                  Positioned.fill(
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [Colors.transparent, Colors.black54],
                                        ),
                                      ),
                                    ),
                                  ),
          
                                  // Text card at the bottom
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.8),
                                              borderRadius: BorderRadius.circular(12)
                                          ),
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                article['title'] ?? 'No title',
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    article['source']['name'] != null
                                                        ? '${(article['source']['name'])}'
                                                        : 'No source',
                                                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                                                  ),
                                                  Text(
                                                    article['publishedAt'] != null
                                                        ? '${DateTime.parse(article['publishedAt']).toLocal()}'.split(' ')[0]
                                                        : 'No date',
                                                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              FutureBuilder<List<dynamic>>(
                future: fetchNews(sourceDomains[dropdownValue]!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No news available'));
                  }
          
                  final articles = snapshot.data!;
          
                  return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: articles.length,
                      itemBuilder: (context, index) {
                        final article = articles[index];
          
                        return Container(
                          margin: const EdgeInsets.all(8),
                          child: Card(
                            elevation: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (article['urlToImage'] != null)
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => NewsDetailPage(article: article),
                                        ),
                                      );
                                    },
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                      child: Image.network(
                                        article['urlToImage'],
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) =>
                                        const Icon(Icons.broken_image),
                                      ),
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    article['title'] ?? 'No title',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        article['source']['name'] != null
                                            ? '${(article['source']['name'])}'
                                            : 'No source',
                                        style: const TextStyle(fontSize: 12, color: Colors.black87),
                                      ),
                                      Text(
                                        article['publishedAt'] != null
                                            ? '${DateTime.parse(article['publishedAt']).toLocal()}'.split(' ')[0]
                                            : 'No date',
                                        style: const TextStyle(fontSize: 12, color: Colors.black87),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewsCat extends StatefulWidget {
  const NewsCat({super.key});

  @override
  State<NewsCat> createState() => _NewsCatState();
}

class _NewsCatState extends State<NewsCat> with SingleTickerProviderStateMixin{
  final dio = Dio();
  final List<String> category = <String>['Business', 'Entertainment', 'General', 'Health', 'Science', 'Sports', 'Technology'];
  late TabController tabController;

  final Map<String, List<dynamic>> _cachedHeadlines = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: category.length, vsync: this, animationDuration: Duration.zero);
  }

  Future<List<dynamic>> fetchNews(String category) async {
    if (_cachedHeadlines.containsKey(category)) {
      return _cachedHeadlines[category]!;
    }

    try {
      var response = await dio.get(
        'https://newsapi.org/v2/top-headlines?category=$category&apiKey=2ecdddebc4d847ddb3be72c181d60f08',
      );
      if (response.statusCode == 200) {
        final articles = response.data['articles'] as List;
        _cachedHeadlines[category] = articles;
        return articles;
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
          child: Column(
            children: [
              TabBar(
                padding: const EdgeInsets.only(left: 15),
                controller: tabController,
                tabAlignment: TabAlignment.start,
                dividerColor: Colors.transparent,
                isScrollable: true,
                indicator: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                labelPadding: const EdgeInsets.symmetric(horizontal: 5),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                tabs: List.generate(category.length, (index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black87),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(category[index]),
                  );
                }),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: category.map((cat) {
                    return FutureBuilder<List<dynamic>>(
                      future: fetchNews(cat.toLowerCase()), // Category names must be lowercase
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('No news available'));
                        }

                        final articles = snapshot.data!;

                        return ListView.builder(
                          itemCount: articles.length,
                          itemBuilder: (context, index) {
                            final article = articles[index];
                            return Container(
                              margin: const EdgeInsets.all(8),
                              child: Card(
                                elevation: 4,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Left-side image
                                    if (article['urlToImage'] != null)
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => NewsDetailPage(article: article),
                                            ),
                                          );
                                        },
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                          child: Image.network(
                                            article['urlToImage'],
                                            width: 120,
                                            height: 125,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) =>
                                            const Icon(Icons.broken_image, size: 50),
                                          ),
                                        ),
                                      )
                                    else
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                        ),
                                        width: 120,
                                        height: 125,
                                        child: const Icon(Icons.broken_image, size: 50),
                                      ),

                                    // Right-side text
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              article['title'] ?? 'No title',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 30),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      article['source']['name'] != null
                                                          ? '${(article['source']['name'])}'
                                                          : 'No source',
                                                      maxLines: 1,
                                                      overflow:TextOverflow.ellipsis,
                                                      style: const TextStyle(fontSize: 12, color: Colors.black87),
                                                    ),
                                                  ),
                                                  Text(
                                                    article['publishedAt'] != null
                                                        ? '${DateTime.parse(article['publishedAt']).toLocal()}'.split(' ')[0]
                                                        : 'No date',
                                                    maxLines: 1,
                                                    overflow:TextOverflow.ellipsis,
                                                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
      ),
    );
  }
}

class NewsDetailPage extends StatelessWidget {
  final Map<String, dynamic> article;

  const NewsDetailPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article['urlToImage'] != null)
              Stack(
                children: [
                  SizedBox(
                    height: 400,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      child: Image.network(
                        article['urlToImage'],
                        width: double.infinity,
                        fit: BoxFit.fill,
                        isAntiAlias: false,
                        errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, size: 100),
                      ),
                    ),
                  ),

                  // Dark overlay for better text readability
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.transparent, Colors.white54, Colors.white],
                        ),
                      ),
                    ),
                  ),
                ]
              ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article['title'] ?? 'No title',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        article['source']?['name'] ?? 'No source',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        article['publishedAt'] != null
                            ? DateTime.parse(article['publishedAt'])
                            .toLocal()
                            .toString()
                            .split(' ')[0]
                            : 'No date',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    article['description'] ?? 'No description available',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


