import 'package:http/http.dart' as http;
import 'dart:convert';

class MyApi {
  final http.Client client;

  MyApi({required this.client});

  Future<List<Photo>> fetchPosts() async {
  final response = await client.get(
    Uri.parse('https://jsonplaceholder.typicode.com/photos'),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to fetch photo');
  }

  try {
    final List<dynamic> jsonData = json.decode(response.body);
    return jsonData.map((item) => Photo.fromJson(item)).toList();
  } catch (e) {
    throw Exception('Failed to parse photo data');
  }
  
  }
}

class Photo {
  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  Photo({
    required this.albumId,
    required this.id,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
  });

  // Factory method to create a Post from JSON
  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      albumId: json['albumId'],
      id: json['id'],
      title: json['title'],
      url: json['url'],
      thumbnailUrl: json['thumbnailUrl'],
    );
  }
}
