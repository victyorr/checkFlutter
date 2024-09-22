import 'package:flutter/material.dart';
import 'package:movie_app/models/movie_model.dart';
import 'package:movie_app/pages/search/widgets/movie_search.dart';

class MovieFavorite extends StatelessWidget {
  final List<Movie> favoriteMovies;
  final Function(Movie) onFavorite; // Adicionar função para remover dos favoritos

  const MovieFavorite({
    super.key,
    required this.favoriteMovies,
    required this.onFavorite, // Receber a função onFavorite para remover filmes
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Movies'),
      ),
      body: favoriteMovies.isEmpty
          ? const Center(
              child: Text(
                'No favorites yet!',
                style: TextStyle(color: Colors.white),
              ),
            )
          : ListView.builder(
              itemCount: favoriteMovies.length,
              itemBuilder: (context, index) {
                return MovieSearch(
                  movie: favoriteMovies[index],
                  isFavorited: true, // Filme já está favoritado
                  onFavorite: () => onFavorite(favoriteMovies[index]), // Chama a função para remover o favorito
                );
              },
            ),
    );
  }
}
