import 'package:flutter/material.dart';

import 'tmdb_service.dart';

/// The Movie Database
class TmdbScreen extends StatefulWidget {
  const TmdbScreen({super.key});

  @override
  State<TmdbScreen> createState() => _TmdbScreenState();
}

class _TmdbScreenState extends State<TmdbScreen> {
  bool _apiKeySaved = false;
  String _savedApiKey = '';
  List<dynamic> _trendingMovies = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkSavedApiKey();
    // _fetchMovies();
  }

  Future<void> _checkSavedApiKey() async {
    final apiKey = await TmdbService.getApiKey();
    setState(() {
      _apiKeySaved = apiKey.isNotEmpty;
      _savedApiKey = apiKey;
      if (_apiKeySaved) {
        _fetchTrendingMovies();
      }
    });
  }

  Future<void> _fetchTrendingMovies() async {
    setState(() {
      _isLoading = true;
    });
    final movies = await TmdbService.fetchTrendingMovies();
    setState(() {
      _trendingMovies = movies;
      _isLoading = false;
    });
  }

  Future<void> _showSaveApiKeyDialog() async {
    TextEditingController apiKeyController = TextEditingController(text: _savedApiKey);

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Manage API Key'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: apiKeyController,
              decoration: const InputDecoration(hintText: 'Enter API Key'),
            ),
            const SizedBox(height: 16),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              apiKeyController.clear();
            },
            child: const Text('Clear', style: TextStyle(color: Colors.orange)),
          ),
          TextButton(
            onPressed: () async {
              final apiKey = apiKeyController.text;
              await TmdbService.saveApiKey(apiKey);
              setState(() {
                _apiKeySaved = true;
                _savedApiKey = apiKey;
              });
              Navigator.pop(context);
              _checkSavedApiKey();
            },
            child: const Text('Save', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            'The Movie Database',
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.token,
                color: _apiKeySaved ? Colors.greenAccent : Colors.redAccent,
              ),
              onPressed: () => _showSaveApiKeyDialog(),
            ),
          ],
        ),
        // if (!_apiKeySaved) const Text('Please save API keys to continue.'),
        body: Center(
          child: Column(
            children: [
              if (_isLoading) const Center(child: CircularProgressIndicator()),
              if (_apiKeySaved && !_isLoading)
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _trendingMovies.length,
                    itemBuilder: (context, index) {
                      final movie = _trendingMovies[index];
                      return ListTile(
                        title: Text(movie['title']),
                        onTap: () {
                          // Navigate to a movie details screen
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => MovieDetailsScreen(movieId: movie['id'])));
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        ));
  }
}
