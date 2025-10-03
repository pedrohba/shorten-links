import 'package:flutter/material.dart';
import 'package:shorten_links/network/api_client.dart';
import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initilizeDependencies();
  runApp(const MyApp());
}

void initilizeDependencies() {
  ApiClient.init(baseUrl: 'https://url-shortener-server.onrender.com/api');
}
