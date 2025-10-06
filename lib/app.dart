import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shorten_links/network/api_client.dart';
import 'package:shorten_links/pages/home_view_model.dart';
import 'package:shorten_links/repositories/link_repository_remote.dart';
import 'pages/home_screen.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shorten Links',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Provider(
        create: (context) => HomeViewModel(LinkRepositoryRemote(ApiClient())),
        child: HomeScreen(),
      ),
    );
  }
}
