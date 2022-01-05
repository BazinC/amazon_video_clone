import 'package:demo_app/constants.dart';
import 'package:demo_app/movie.dart';
import 'package:demo_app/movie_service.dart';
import 'package:flutter/material.dart';

/// We modified in live the flutter sample project to clone amazon prime video app
/// It's just having fun with flutter, no complex concept like state management are involved here. Just Vanilla Flutter.
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          colorScheme: const ColorScheme.dark(),
          scaffoldBackgroundColor: amazonBodyBackgroundColor),
      home: const AmazonPrimeMainPage(),
    );
  }
}

class AmazonPrimeMainPage extends StatefulWidget {
  const AmazonPrimeMainPage({Key? key}) : super(key: key);

  @override
  _AmazonPrimeMainPageState createState() => _AmazonPrimeMainPageState();
}

class _AmazonPrimeMainPageState extends State<AmazonPrimeMainPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(
        index: _selectedIndex,
      ),
      floatingActionButton: RawMaterialButton(
        shape: const CircleBorder(),
        child: const Icon(Icons.cast),
        onPressed: () {},
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: amazonUnselectedColor,
        selectedItemColor: amazonPrimaryColor,
        backgroundColor: amazonBackgroundColor,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Store'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.download), label: 'Download'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
        currentIndex: _selectedIndex,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
      ),
    );
  }
}

/// Display content depending on bottom navigation bar index
class Body extends StatelessWidget {
  const Body({Key? key, required this.index}) : super(key: key);
  final int index;

  @override
  Widget build(BuildContext context) {
    switch (index) {
      case 0:
        return const HomePage();
      default:
    }

    return const SafeArea(child: Center(child: Text('not available yet')));
  }
}

/// First tab of the clone app
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Movie> trendingMovies = [];
  List<Movie> topMovies = [];

  @override
  void initState() {
    loadData();
    super.initState();
  }

  void loadData() async {
    final trendingMovies = await MovieService.getTrendingMovies();
    final topMovies = await MovieService.getTopRatedMovies();

    if (mounted) {
      setState(() {
        this.trendingMovies = trendingMovies;
        this.topMovies = topMovies;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(slivers: [
        MovieSection(
          movies: trendingMovies,
          label: 'Trending',
        ),
        MovieSection(
          label: 'Top Rated',
          movies: topMovies,
        ),
      ]),
    );
  }
}

class MovieSection extends StatelessWidget {
  const MovieSection(
      {Key? key,
      required this.movies,
      required this.label,
      this.isPrime = true})
      : super(key: key);
  final List<Movie> movies;
  final String label;
  final bool isPrime;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          MovieSectionHeader(label: label, isPrime: isPrime),
          MoviesList(
            movies: movies,
          )
        ],
      ),
    );
  }
}

/// A section header displaying "Included with Prime" and the section label
class MovieSectionHeader extends StatelessWidget {
  const MovieSectionHeader(
      {Key? key, required this.label, required this.isPrime})
      : super(key: key);
  final String label;
  final bool isPrime;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isPrime)
          const Text(
            'Included with Prime',
            style: TextStyle(
              color: amazonPrimaryColor,
              fontSize: 15,
            ),
          ),
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Icon(Icons.navigate_next)
          ],
        ),
      ],
    );
  }
}

///an horizontal scrollable list showing movies
class MoviesList extends StatelessWidget {
  const MoviesList({
    Key? key,
    required this.movies,
  }) : super(key: key);

  final List<Movie> movies;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];

          return InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MovieDetailScreen(movie: movie),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Hero(
                tag: 'image_${movie.id}',
                child: MovieCard(movie: movie),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// A movie card showing its poster picture
class MovieCard extends StatelessWidget {
  const MovieCard({
    Key? key,
    required this.movie,
  }) : super(key: key);

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      movie.imagePath,
    );
  }
}

/// The detail page for a movie
class MovieDetailScreen extends StatelessWidget {
  const MovieDetailScreen({Key? key, required this.movie}) : super(key: key);
  final Movie movie;

  static const double _appBarHeight = 256.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(movie.title),
            expandedHeight: _appBarHeight,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'image_${movie.id}',
                child: Image.network(
                  movie.imagePath,
                  fit: BoxFit.cover,
                  height: _appBarHeight,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: Text(movie.overview)),
        ],
      ),
    );
  }
}
