import 'package:flutter/material.dart';
import 'package:movie_app/models/movie_model.dart';
import 'package:movie_app/pages/movie_detail/movie_detail_page.dart';

class NowPlayingList extends StatelessWidget {
  final Result result;
  final Function(Movie) onFavorite; // Definindo o parâmetro onFavorite
  final List<Movie> favoriteMovies; // Adicionando lista de favoritos

  const NowPlayingList({
    super.key,
    required this.result,
    required this.onFavorite,
    required this.favoriteMovies, // Adicionando a lista de favoritos
  });

  // Função que verifica se o filme está nos favoritos
  bool isFavorited(Movie movie) {
    return favoriteMovies.any((favMovie) => favMovie.id == movie.id);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: result.movies.length,
        itemBuilder: (context, index) {
          final movie = result.movies[index];

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navegar para a página de detalhes do filme
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MovieDetailPage(movieId: movie.id),
                        ));
                      },
                      child: Image.network(
                        'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      right: 10,
                      bottom: 10,
                      child: IconButton(
                        icon: Icon(
                          isFavorited(movie) ? Icons.favorite : Icons.favorite_border, 
                          color: Colors.red,
                        ),
                        onPressed: () {
                          onFavorite(movie); // Chamar a função de favoritar
                        },
                      ),
                    ),
                  ],
                ),
                Text(movie.title, style: const TextStyle(color: Colors.white)),
              ],
            ),
          );
        },
      ),
    );
  }
}
