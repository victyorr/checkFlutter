import 'package:flutter/material.dart';
import 'package:movie_app/models/movie_model.dart';
import 'package:movie_app/services/api_services.dart';
import 'package:movie_app/pages/search/widgets/movie_search.dart';

class SearchPage extends StatefulWidget {
  final Function(Movie) onFavorite; // Defina o parâmetro no construtor
  final List<Movie> favoriteMovies; // Adicionar a lista de favoritos

  const SearchPage({
    super.key,
    required this.onFavorite,
    required this.favoriteMovies, // Adicionar a lista de favoritos
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  ApiServices apiServices = ApiServices();
  TextEditingController searchController = TextEditingController();
  late Future<Result> result;
  String selectedGenre = '';

  // Mapa dos gêneros para seus IDs correspondentes
  Map<String, int> genreMap = {
    'Action': 28,
    'Comedy': 35,
    'Drama': 18,
    'Horror': 27,
    'Romance': 10749,
    // Adicione outros gêneros conforme necessário
  };

  // Verificar se o filme já está nos favoritos usando o ID
  bool isFavorite(Movie movie) {
    return widget.favoriteMovies.any((favMovie) => favMovie.id == movie.id);
  }

  @override
  void initState() {
    result = apiServices.getPopularMovies(); // Carregar filmes populares ao iniciar
    super.initState();
  }

  // Função para pesquisar por gênero
  void searchByGenre(String genre) {
    setState(() {
      selectedGenre = genre;
      int genreId = genreMap[genre]!; // Obtém o ID do gênero
      result = apiServices.getMoviesByGenre(genreId); // Chamar a API para filmes por gênero usando o ID
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Movies'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'Search...',
                ),
                onChanged: (query) {
                  setState(() {
                    result = apiServices.getSearchedMovie(query);
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: DropdownButton<String>(
                value: selectedGenre.isEmpty ? null : selectedGenre,
                hint: const Text('Select Genre'),
                isExpanded: true,
                onChanged: (value) {
                  if (value != null) {
                    searchByGenre(value);
                  }
                },
                items: genreMap.keys.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: FutureBuilder<Result>(
                future: result,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var movies = snapshot.data!.movies;
                    return ListView.builder(
                      itemCount: movies.length,
                      itemBuilder: (context, index) {
                        return MovieSearch(
                          movie: movies[index],
                          isFavorited: isFavorite(movies[index]), // Verifica se o filme já está favoritado pelo ID
                          onFavorite: () {
                            if (!isFavorite(movies[index])) {
                              widget.onFavorite(movies[index]); // Adiciona apenas se não estiver nos favoritos
                            }
                          },
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text('Error loading movies'),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
