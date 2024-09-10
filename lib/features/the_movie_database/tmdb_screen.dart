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
    });
  }

  Future<void> _showSaveApiKeyDialog() async {
    TextEditingController apiKeyController = TextEditingController();

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Enter API Key'),
        content: TextField(
          controller: apiKeyController,
          decoration: const InputDecoration(hintText: 'Enter API Key'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final apiKey = apiKeyController.text;
              await TmdbService.saveApiKey(apiKey);
              setState(() {
                _apiKeySaved = true;
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
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
            onPressed: () {
              // _searchMovies();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_apiKeySaved)
              // Display movie data or other content
              const Text('API keys are saved. Ready to fetch movies!'),
            if (!_apiKeySaved) const Text('Please save API keys to continue.'),
            ElevatedButton(
              onPressed: !_apiKeySaved ? _showSaveApiKeyDialog : null,
              child: const Text('Save API Keys'),
            ),
          ],
        ),
      ),
    );
  }
}
