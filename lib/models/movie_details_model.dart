class MovieDetailsModel {
  String? status;
  MovieDetails? movie;

  MovieDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    final data = json['data'];
    movie = data?['movie'] != null ? MovieDetails.fromJson(data['movie']) : null;
  }
}

class MovieDetails {
  int? id;
  String? titleLong;
  int? year;
  double? rating;
  int? runtime;
  int? likeCount;
  String? descriptionFull;
  String? ytTrailerCode;
  String? backgroundImageOriginal;
  String? mediumCoverImage;
  List<String> genres = [];
  List<String> screenshots = [];
  List<Cast> cast = [];

  MovieDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titleLong = json['title_long'];
    year = json['year'];
    rating = (json['rating'] as num?)?.toDouble();
    runtime = json['runtime'];
    likeCount = json['like_count'];
    descriptionFull = json['description_full'];
    ytTrailerCode = json['yt_trailer_code'];
    backgroundImageOriginal = json['background_image_original'];
    mediumCoverImage = json['medium_cover_image'];

    genres = (json['genres'] as List?)?.map((g) => g.toString()).toList() ?? [];

    screenshots = [
      json['large_screenshot_image1'],
      json['large_screenshot_image2'],
      json['large_screenshot_image3'],
    ].whereType<String>().toList();

    cast = (json['cast'] as List?)?.map((c) => Cast.fromJson(c)).toList() ?? [];
  }
}

class Cast {
  String? name;
  String? characterName;
  String? urlSmallImage;

  Cast.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    characterName = json['character_name'];
    urlSmallImage = json['url_small_image'];
  }
}