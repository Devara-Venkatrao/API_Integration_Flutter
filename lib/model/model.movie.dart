class MovieData {
  final String? title;
  final String? poster;
  final String? plot;
  final String? rating;
  final String? year;
  final String? length;


  MovieData({
    this.title,
    this.poster,
    this.plot,
    this.rating,
    this.year,
    this.length,

  });

  factory MovieData.fromJson(Map<String, dynamic> json) {
    return MovieData(
      title: json['primaryTitle'],  // ✅ Updated key for title
      poster: json['primaryImage'],  // ✅ Updated key for poster
      plot: json['description'],  // ✅ Updated key for plot
      rating: json['averageRating']?.toString(),  // ✅ Fixed rating extraction
      year: json['startYear']?.toString(),  // ✅ Fixed release year
      length: json['runtimeMinutes']?.toString(),  // ✅ Fixed duration (previously wrong key)

    );
  }
}