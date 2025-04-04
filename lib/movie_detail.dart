import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

import '../model/model.movie.dart';

class MovieDetail extends StatefulWidget {
  @override
  _MovieDetailState createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  Future<MovieData?> getResponse() async {
    try {
      final response = await http.get(
        Uri.parse('https://imdb236.p.rapidapi.com/imdb/tt0816692'),
        headers: {
          'x-rapidapi-key': '588e158a43mshf2377654ff4ec3fp16a1f1jsn2d8bb49339d7',
          'x-rapidapi-host': 'imdb236.p.rapidapi.com',
        },
      );

      print("API Response: ${response.body}");

      if (response.statusCode == 200) {
        return MovieData.fromJson(json.decode(response.body));
      } else {
        print("API Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Network Error: $e");
      return null;
    }
  }

  final String trailerLink = "https://youtu.be/1hWKoPTazMw?si=GrGLo7QO6xKuOTZD"; // ✅ Your Given YouTube Trailer Link

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Movie Detail"),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<MovieData?>(
        future: getResponse(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            return Center(child: Text("Failed to load data"));
          } else {
            var data = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      // Movie Poster
                      Container(
                        height: MediaQuery.of(context).size.height / 1.5,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          image: data.poster != null
                              ? DecorationImage(
                            image: NetworkImage(data.poster!),
                            fit: BoxFit.cover,
                          )
                              : DecorationImage(
                            image: AssetImage('assets/images/placeholder.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      // Overlay for Better Text Visibility
                      Container(
                        height: MediaQuery.of(context).size.height / 1.5,
                        color: Colors.black.withOpacity(0.4),
                      ),

                      Column(
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height / 1.8),

                          // Movie Info Container
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40.0),
                                topRight: Radius.circular(40.0),
                              ),
                              child: Container(
                                color: Colors.white,
                                height: MediaQuery.of(context).size.height,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Movie Title
                                      Text(
                                        data.title ?? "No Title",
                                        style: TextStyle(
                                          fontSize: 24.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      // Movie Details (Year, Rating, Runtime)
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(data.year ?? "Unknown"),
                                            Text("Rating: ${data.rating ?? "N/A"}"),
                                            Row(
                                              children: [
                                                Icon(Icons.access_time_outlined),
                                                Text(data.length ?? "Unknown"),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Plot Section
                                      Text(
                                        "PLOT",
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 10.0),
                                      Text(
                                        data.plot ?? "No plot available",
                                        style: TextStyle(fontSize: 16.0),
                                      ),
                                      SizedBox(height: 20.0),

                                      // ✅ Watch Trailer Button (Opens YouTube)
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width,
                                        height: 60.0,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red, // YouTube Red
                                          ),
                                          onPressed: () async {
                                            final Uri url = Uri.parse(trailerLink);

                                            // Try opening in YouTube app first, fallback to browser
                                            if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                                              if (!await launchUrl(url, mode: LaunchMode.inAppWebView)) {
                                                print("Failed to launch trailer.");
                                              }
                                            }
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.play_circle_fill, color: Colors.white),
                                              SizedBox(width: 8),
                                              Text(
                                                "Watch Trailer",
                                                style: TextStyle(color: Colors.white, fontSize: 18),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}