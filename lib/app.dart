import 'package:flutter/material.dart';
import 'package:shorten_links/network/api_client.dart';
import 'package:shorten_links/pages/home_view_model.dart';
import 'package:shorten_links/repositories/link_repository_remote.dart';
import 'pages/home_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shorten Links',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomeScreen(HomeViewModel(LinkRepositoryRemote(ApiClient()))),
    );
  }
}
