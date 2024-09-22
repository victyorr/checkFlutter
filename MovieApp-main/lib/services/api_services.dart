import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie_app/models/movie_detail_model.dart';
import 'package:movie_app/models/movie_model.dart';

const baseUrl = 'https://api.themoviedb.org/3/';
const key = '?api_key=6e8c7098d29917fa240a533812505142';

class ApiServices {
  Future<Result> getTopRatedMovies() async {
    var endPoint = 'movie/top_rated';
    final url = '$baseUrl$endPoint$key';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return Result.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to load top rated movies');
  }

  Future<Result> getNowPlayingMovies() async {
    var endPoint = 'movie/now_playing';
    final url = '$baseUrl$endPoint$key';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return Result.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to load now playing movies');
  }

  Future<Result> getUpcomingMovies() async {
    var endPoint = 'movie/upcoming';
    final url = '$baseUrl$endPoint$key';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return Result.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to load upcoming movies');
  }

  Future<MovieDetailModel> getMovieDetail(int movieId) async {
    final endPoint = 'movie/$movieId';
    final url = '$baseUrl$endPoint$key';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return MovieDetailModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to load movie details');
  }

  Future<Result> getMovieRecommendations(int movieId) async {
    final endPoint = 'movie/$movieId/recommendations';
    final url = '$baseUrl$endPoint$key';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return Result.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to load movie recommendations');
  }

  Future<Result> getSearchedMovie(String searchText) async {
    final endPoint = 'search/movie?query=$searchText';
    final url = '$baseUrl$endPoint';
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2ZThjNzA5OGQyOTkxN2ZhMjQwYTUzMzgxMjUwNTE0MiIsIm5iZiI6MTcyNjc1MTQ2OC4wNjA0Miwic3ViIjoiNjZlYzBlM2RlNDNmMDdkZTgyZWI5N2IyIiwic2NvcGVzIjpbImFwaV9yZWFkIl0sInZlcnNpb24iOjF9.VvUcaWPmHNZQzLAKOgNFSLd48hWCn7zoW4pR-iY3Q0g'
    });
    if (response.statusCode == 200) {
      final movies = Result.fromJson(jsonDecode(response.body));
      return movies;
    }
    throw Exception('failed to load searched movie');
  }

  Future<Result> getPopularMovies() async {
    const endPoint = 'movie/popular';
    const url = '$baseUrl$endPoint$key';

    final response = await http.get(Uri.parse(url), headers: {});
    if (response.statusCode == 200) {
      return Result.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to load popular movies');
  }

Future<Result> getMoviesByGenre(int genreId) async {
  final endPoint = 'discover/movie?with_genres=$genreId';
  final url = '$baseUrl$endPoint$key';

  final response = await http.get(Uri.parse(url), headers: {
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2ZThjNzA5OGQyOTkxN2ZhMjQwYTUzMzgxMjUwNTE0MiIsIm5iZiI6MTcyNjc1MTQ2OC4wNjA0Miwic3ViIjoiNjZlYzBlM2RlNDNmMDdkZTgyZWI5N2IyIiwic2NvcGVzIjpbImFwaV9yZWFkIl0sInZlcnNpb24iOjF9.VvUcaWPmHNZQzLAKOgNFSLd48hWCn7zoW4pR-iY3Q0g'
  });

  if (response.statusCode == 200) {
    return Result.fromJson(jsonDecode(response.body));
  }
  throw Exception('failed to load movies by genre');
}

}
