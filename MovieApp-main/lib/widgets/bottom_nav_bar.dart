import 'package:flutter/material.dart';
import 'package:movie_app/pages/favorite/movie_favorite.dart';
import 'package:movie_app/pages/home/home_page.dart';
import 'package:movie_app/pages/search/search_page.dart';
import 'package:movie_app/pages/top_rated/top_rated_page.dart';
import 'package:movie_app/models/movie_model.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int paginaAtual = 0;
  PageController pc = PageController(initialPage: 0);

  List<Movie> favoriteMovies = [];

  // Verificar se o filme já está nos favoritos usando o ID
  bool isFavorite(Movie movie) {
    return favoriteMovies.any((favMovie) => favMovie.id == movie.id);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Alterado para 4 abas (Home, Search, Top Rated, Favoritos)
      child: Scaffold(
        body: PageView(
          controller: pc,
          onPageChanged: (page) {
            setState(() {
              paginaAtual = page;
            });
          },
          children: [
            HomePage(
              onFavorite: (movie) {
                setState(() {
                  if (!isFavorite(movie)) {
                    favoriteMovies.add(movie); // Adicionar filme aos favoritos apenas se não estiver na lista
                  }
                });
              },
              favoriteMovies: favoriteMovies, // Passar a lista de favoritos
            ),
            SearchPage(
              onFavorite: (movie) {
                setState(() {
                  if (!isFavorite(movie)) {
                    favoriteMovies.add(movie); // Adicionar filme aos favoritos apenas se não estiver na lista
                  }
                });
              },
              favoriteMovies: favoriteMovies, // Passar a lista de filmes favoritos
            ),
            const TopRatedPage(),
            MovieFavorite(
              favoriteMovies: favoriteMovies,
              onFavorite: (movie) {
                setState(() {
                  favoriteMovies.removeWhere((favMovie) => favMovie.id == movie.id); // Remover filme dos favoritos pelo ID
                });
              },
            ), // Aba de favoritos
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: paginaAtual,
          iconSize: 30,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          backgroundColor: Colors.black,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(
                icon: Icon(Icons.trending_up), label: 'Top Rated'),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite), label: 'Favorites'),
          ],
          onTap: (pagina) {
            pc.animateToPage(
              pagina,
              duration: const Duration(milliseconds: 400),
              curve: Curves.ease,
            );
          },
        ),
      ),
    );
  }
}
