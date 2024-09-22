import 'package:flutter/material.dart';
import 'package:movie_app/models/movie_model.dart';
import 'package:movie_app/pages/movie_detail/movie_detail_page.dart';
import 'package:movie_app/services/api_services.dart';

class HomePage extends StatefulWidget {
  final Function(Movie) onFavorite;
  final List<Movie> favoriteMovies;

  const HomePage({
    super.key,
    required this.onFavorite,
    required this.favoriteMovies,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ApiServices apiServices = ApiServices();

  late Future<Result> popular;
  late Future<Result> nowPlaying;
  late Future<Result> upcomingFuture;

  @override
  void initState() {
    popular = apiServices.getPopularMovies();
    nowPlaying = apiServices.getNowPlayingMovies();
    upcomingFuture = apiServices.getUpcomingMovies();
    super.initState();
  }

  // Função que verifica se o filme já está nos favoritos
  bool isFavorite(Movie movie) {
    return widget.favoriteMovies.any((favMovie) => favMovie.id == movie.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fundo preto
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Destaque de um filme na parte superior
              _buildFeaturedMovie(),

              // Lista Horizontal: Now Playing
              _buildMovieSection(
                title: "Now Playing",
                futureMovies: nowPlaying,
              ),

              // Lista Horizontal: Populares
              _buildMovieSection(
                title: "Popular Movies",
                futureMovies: popular,
              ),

              // Lista Horizontal: Upcoming Movies
              _buildMovieSection(
                title: "Upcoming Movies",
                futureMovies: upcomingFuture,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget para o filme em destaque no topo
  Widget _buildFeaturedMovie() {
    return FutureBuilder<Result>(
      future: popular, // Exibir um filme popular como destaque
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Movie featuredMovie = snapshot.data!.movies.first;

          return Stack(
            children: [
              Container(
                height: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://image.tmdb.org/t/p/w500${featuredMovie.posterPath}'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                height: 300,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.black.withOpacity(0.1),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      featuredMovie.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.yellow, size: 20),
                        const SizedBox(width: 5),
                        Text(
                          "${featuredMovie.voteAverage.toStringAsFixed(1)}/10",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        // Ação quando clicar no botão de assistir agora
                      },
                      child: const Text("Watch Now"),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
        return const SizedBox(); // Exibir nada enquanto carrega
      },
    );
  }

  // Widget para seções de filmes (listas horizontais)
  Widget _buildMovieSection({
    required String title,
    required Future<Result> futureMovies,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 250, // Altura maior para incluir os detalhes e o botão de favorito
          child: FutureBuilder<Result>(
            future: futureMovies,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.movies.length,
                  itemBuilder: (context, index) {
                    Movie movie = snapshot.data!.movies[index];
                    return _buildMovieCard(movie);
                  },
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.red),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  // Widget para construir cada cartão de filme nas listas horizontais
  Widget _buildMovieCard(Movie movie) {
    return GestureDetector(
      onTap: () {
        // Navegar para a página de detalhes do filme
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MovieDetailPage(movieId: movie.id),
          ),
        );
      },
      child: Container(
        width: 150, // Ajustando largura para comportar a imagem e o botão de favorito
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                    height: 200, // Altura maior para exibir mais detalhes
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  right: 5,
                  top: 5,
                  child: IconButton(
                    icon: Icon(
                      isFavorite(movie)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: isFavorite(movie) ? Colors.red : Colors.white,
                    ),
                    onPressed: () {
                      widget.onFavorite(movie); // Chamar função de favoritar
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              movie.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.yellow, size: 14),
                const SizedBox(width: 5),
                Text(
                  movie.voteAverage.toStringAsFixed(1),
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
