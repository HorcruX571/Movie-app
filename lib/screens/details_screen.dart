import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final movie = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          movie['name'] ?? 'Movie Details',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.cast, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie Image
            if (movie['image'] != null)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    movie['image']['original'] ?? '',
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'lib/assets/logo.png',
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            SizedBox(height: 20),

            // Movie Name
            Center(
              child: Text(
                movie['name'] ?? 'No Title',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Summary
            _buildSectionTitle('Summary'),
            Text(
              movie['summary']?.replaceAll(RegExp(r'<[^>]*>'), '') ??
                  'No Summary Available',
              style: TextStyle(fontSize: 16, color: Colors.grey[400]),
            ),
            SizedBox(height: 20),

            // Official Site Button
            if (movie['officialSite'] != null)
              Center(
                child: GestureDetector(
                  onTap: () async {
                    final url = movie['officialSite'];
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Could not open link')),
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.language, color: Colors.black),
                        SizedBox(width: 5),
                        Text(
                          'Official Site',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            SizedBox(height: 20),

            // Genres
            if (movie['genres'] != null && movie['genres'].isNotEmpty)
              _buildKeyValue('Genres', movie['genres'].join(', ')),

            // Language
            if (movie['language'] != null)
              _buildKeyValue('Language', movie['language']),

            // Premiered
            if (movie['premiered'] != null)
              _buildKeyValue('Premiered', movie['premiered']),

            // Status
            if (movie['status'] != null)
              _buildKeyValue('Status', movie['status']),

            // Rating
            if (movie['rating'] != null && movie['rating']['average'] != null)
              _buildKeyValue('Rating', '${movie['rating']['average']} / 10'),

            // Runtime
            if (movie['runtime'] != null)
              _buildKeyValue('Runtime', '${movie['runtime']} minutes'),

            // Schedule
            if (movie['schedule'] != null &&
                movie['schedule']['days'] != null) ...[
              _buildKeyValue(
                  'Schedule', 'Time: ${movie['schedule']['time'] ?? 'N/A'}'),
              Text(
                'Days: ${movie['schedule']['days'].join(', ')}',
                style: TextStyle(fontSize: 16, color: Colors.grey[400]),
              ),
              SizedBox(height: 20),
            ],

            // Network
            if (movie['network'] != null) ...[
              _buildSectionTitle('Network'),
              Text(
                movie['network']['name'] ?? 'N/A',
                style: TextStyle(fontSize: 16, color: Colors.grey[400]),
              ),
              if (movie['network']['country'] != null)
                Text(
                  'Country: ${movie['network']['country']['name']}',
                  style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                ),
              SizedBox(height: 20),
            ],

            // Web Channel
            if (movie['webChannel'] != null)
              _buildKeyValue(
                  'Web Channel', movie['webChannel']['name'] ?? 'N/A'),

            // Previous Episode
            if (movie['_links'] != null &&
                movie['_links']['previousepisode'] != null)
              _buildKeyValue('Previous Episode',
                  movie['_links']['previousepisode']['name'] ?? 'N/A'),

            // Next Episode
            if (movie['_links'] != null &&
                movie['_links']['nextepisode'] != null)
              _buildKeyValue('Next Episode',
                  movie['_links']['nextepisode']['name'] ?? 'N/A'),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildKeyValue(String key, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(key),
          Text(
            value,
            style: TextStyle(fontSize: 16, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}
