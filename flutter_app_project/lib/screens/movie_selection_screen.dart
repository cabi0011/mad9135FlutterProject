import 'package:flutter/material.dart';
import 'package:flutter_app_project/utils/app_state.dart';
import 'package:flutter_app_project/utils/http_helper.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MovieSelectionScreen extends StatefulWidget {
  const MovieSelectionScreen({super.key});

  @override
  _MovieSelectionScreenState createState() => _MovieSelectionScreenState();
}

class _MovieSelectionScreenState extends State<MovieSelectionScreen> {
  List<Map<String, dynamic>> _movies = [];
  int _currentIndex = 0;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  Future<void> _fetchMovies() async {
    final response = await http.get(Uri.parse(
        '${HttpHelper.tmdbBaseUrl}/movie/upcoming?api_key=${HttpHelper.tmdbApiKey}&page=$_currentPage'));
    final data = json.decode(response.body);
    setState(() {
      _movies.addAll(List<Map<String, dynamic>>.from(data['results']));
      _currentPage++;
    });
  }

  Future<void> _voteMovie(bool vote) async {
    final deviceId = Provider.of<AppState>(context, listen: false).deviceId;
    final sessionId = Provider.of<AppState>(context, listen: false).sessionId;
    final movieId = _movies[_currentIndex]['id'];

    final response = await http.post(
      Uri.parse('${HttpHelper.movieNightBaseUrl}/vote-movie'),
      body: json.encode({
        'device_id': deviceId,
        'session_id': sessionId,
        'movie_id': movieId,
        'vote': vote,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    final result = json.decode(response.body);
    if (result['match'] == true) {
      _showMatchDialog(result['movie_id']);
    } else {
      _nextMovie();
    }
  }

  void _nextMovie() {
    setState(() {
      _currentIndex++;
      if (_currentIndex >= _movies.length) {
        _fetchMovies();
      }
    });
  }

  void _showMatchDialog(int movieId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Match Found!'),
        content: Text('You have matched on movie ID: $movieId'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pushReplacementNamed('/welcome');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_movies.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Movie Night'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final movie = _movies[_currentIndex];
    final posterPath = movie['poster_path'];
    final posterUrl = posterPath != null
        ? 'https://image.tmdb.org/t/p/w500$posterPath'
        : 'assets/images/no_image_placeholder.png';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Night'),
      ),
      body: Center(
        child: Dismissible(
          key: Key(movie['id'].toString()),
          direction: DismissDirection.horizontal,
          onDismissed: (direction) {
            final vote = direction == DismissDirection.endToStart ? false : true;
            _voteMovie(vote);
          },
          background: Container(
            color: Colors.green,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20),
            child: const Icon(Icons.thumb_up, color: Colors.white),
          ),
          secondaryBackground: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.thumb_down, color: Colors.white),
          ),
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(
                  posterUrl,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset('assets/images/no_image_placeholder.png');
                  },
                ),
                ListTile(
                  title: Text(movie['title']),
                  subtitle: Text(movie['overview']),
                ),
                Text('Release Date: ${movie['release_date']}'),
                Text('Rating: ${movie['vote_average']}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}