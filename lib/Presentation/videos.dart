import 'dart:convert';
import 'package:flutter/material.dart';
import '../movie_datamodel.dart';
import 'package:http/http.dart' as http;
import 'movie_details.dart';

class Videos extends StatefulWidget {
  const Videos({super.key});

  @override
  State<Videos> createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  late Future<MovieDatamodel> movieData;

  @override
  void initState() {
    super.initState();
    movieData = fetchMovies();
  }

  Future<MovieDatamodel> fetchMovies() async {
    final url = 'https://api.themoviedb.org/3/tv/top_rated?api_key=0cb8553727794316c0640fab343cfc04&la';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        return MovieDatamodel.fromJson(decodedData);
      } else {
        throw Exception('Failed to load movie data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to load movie data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<MovieDatamodel>(
        future: movieData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.results.length,
              itemBuilder: (context, index) {
                final movie = snapshot.data!.results[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>MovieDetails(poster: movie.posterPath,)));

                    },
                    child: Row(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                            width: 200,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 20,),
                        Expanded(child: Container(
                          height: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${movie.name}",maxLines: 5),
                              ElevatedButton(
                                onPressed: () {
                                  // Add your button onPressed logic here
                                },
                                child: Text("Action"),
                              ),
                              Text("DT prime"),
                            ],
                          ),
                        )),
                        Container(
                          height: 100,
                          width: 20,
                          alignment: Alignment.bottomRight,
                          child: Icon(
                            Icons.more_vert,
                            size: 40,
                          ),
                        ),
                        SizedBox(width: 20,)
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Center(child: Text('Unknown error occurred'));
          }
        },
      ),
    );
  }
}
