import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_for_movie_with_api/movie_datamodel.dart';

class MovieReview {
  final String userName;
  final double rating;
  final String comment;

  MovieReview({
    required this.userName,
    required this.rating,
    required this.comment,
  });

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'rating': rating,
      'comment': comment,
    };
  }
}

class MovieDetails extends StatefulWidget {
  final String poster;

  const MovieDetails({Key? key, required this.poster}) : super(key: key);

  @override
  _MovieDetailsState createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  List<MovieReview> reviews = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final name = TextEditingController();
  final rating = TextEditingController();
  final review = TextEditingController();

  Result? movieData;
  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/tv/top_rated?api_key=0cb8553727794316c0640fab343cfc04&la'));

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        setState(() {
          // Access the 'results' key in decodedData, assuming it's a Map
          movieData = Result.fromJson(decodedData['results'][0]);
        });
      } else {
        throw Exception('Failed to load movie data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to load movie data: $error');
    }
  }

  double getAverageRating() {
    if (reviews.isEmpty) return 0.0;
    double sum = reviews.map((review) => review.rating).reduce((a, b) => a + b);
    return sum / reviews.length;
  }

  Future<void> submitReview(MovieReview newReview) async {
    try {
      User? user = _auth.currentUser;
      await _firestore.collection('MovieReviews').add(newReview.toMap());
      setState(() {
        reviews.add(newReview);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Review submitted successfully!')),
      );
    } catch (error) {
      print('Error submitting review: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit review. Please try again later.'),
        ),
      );
    }
  }

  Future<bool> isUserNameUnique(String userName) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('MovieReviews')
          .where('userName', isEqualTo: userName)
          .get();
      return querySnapshot.docs.isEmpty;
    } catch (error) {
      print('Error checking user name uniqueness: $error');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Details'),
      ),
      body: ListView(
        children: [
          Image.network(
            'https://image.tmdb.org/t/p/w500${widget.poster}',
            width: 200,
            height: 500,
            fit: BoxFit.contain,
          ),
          Container(
            color: Colors.green,
            margin: EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
              ),
              child: const Row(
                children: [
                  Icon(Icons.play_arrow, size: 40),
                  SizedBox(width: 8),
                  Text("Watch Now"),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.green,
                            width: 4.0,
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: IconButton(
                          color: Colors.white,
                          icon: Icon(Icons.play_arrow, color: Colors.green),
                          iconSize: 30,
                          onPressed: () {
                            print('Button Pressed!');
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    const Text(
                      "Trailer",
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                ),
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.green,
                            width: 4.0,
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: IconButton(
                          color: Colors.white,
                          icon: Icon(Icons.add, color: Colors.green),
                          iconSize: 30,
                          onPressed: () {
                            print('Button Pressed!');
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Text(
                      "Watch list",
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                ),
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.green,
                            width: 4.0,
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: IconButton(
                          color: Colors.black,
                          icon: Icon(Icons.more_vert, color: Colors.green),
                          iconSize: 30,
                          onPressed: () {
                            print('Button Pressed!');
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Text(
                      "More",
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(movieData?.overview ?? ''),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20,),
            child: Row(
              children: [
                ElevatedButton(onPressed: () {}, child: Text("IMDB")),
                SizedBox(width: 10,),
                Text(movieData?.voteAverage.toString() ?? ''),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(
              children: [
                Text("Categories :"),
                Text("Action, Drama"),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20,),
            child: Row(
              children: [
                Text("Languages :"),
                Text(movieData?.originalLanguage.toString() ?? ''),
              ],
            ),
          ),
          SizedBox(height: 20,),
          Container(
            padding: EdgeInsets.all(20),
            color: Colors.grey[200],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Submit a Review',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: name,
                  decoration: InputDecoration(labelText: 'Your Name'),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: rating,
                  decoration: InputDecoration(labelText: 'Rating (1-5)'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: review,
                  maxLines: 3,
                  decoration: InputDecoration(labelText: 'Review'),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    String userName = name.text.toString();
                    double userRating = double.parse(rating.text.toString());
                    String comment = review.text.toString();

                    if (await isUserNameUnique(userName)) {
                      MovieReview newReview = MovieReview(
                        userName: userName,
                        rating: userRating,
                        comment: comment,
                      );
                      submitReview(newReview);
                    } else {
                      print('User already exists. Cannot submit the review.');
                    }
                  },
                  child: Text('Submit Review'),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'User Reviews',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                    'Average Rating: ${getAverageRating().toStringAsFixed(1)}'),
                FutureBuilder<QuerySnapshot>(
                  future: _firestore.collection('MovieReviews').get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    if (snapshot.hasError) {
                      return Text('Error fetching reviews');
                    }

                    reviews = snapshot.data!.docs
                        .map((doc) =>
                        MovieReview(
                          userName: doc['userName'],
                          rating: doc['rating'],
                          comment: doc['comment'],
                        ))
                        .toList();

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: reviews.length,
                      itemBuilder: (context, index) {
                        MovieReview review = reviews[index];
                        return ListTile(
                          title: Text('${review.userName} - ${review.rating}'),
                          subtitle: Text(review.comment),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
