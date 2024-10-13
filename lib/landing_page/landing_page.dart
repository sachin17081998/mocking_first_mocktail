import 'package:flutter/material.dart';
import 'package:mocking_first_mocktail/api/api.dart';

import 'package:http/http.dart' as http;

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Landing Page'), actions: [
        IconButton.filled(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.logout_outlined))
      ]),
      body: FutureBuilder(
        future: MyApi(client: http.Client()).fetchPosts(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Photo> posts = snapshot.data!;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                Photo post = posts[index];
                return ListTile(
                  leading: Image.network(
                    post.thumbnailUrl,
                    width: 50,
                    height: 50,
                  ),
                  title: Text(post.title),
                  subtitle: Text('Album ID: ${post.albumId}'),
                  onTap: () {
                    // You can add functionality to open the full image here
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(post.title),
                        content: Image.network(post.url),
                      ),
                    );
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
