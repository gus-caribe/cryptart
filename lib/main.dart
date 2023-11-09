import 'package:cryptart/encrypter.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'CryptArt Caesar Cypher',
    theme: ThemeData.light(
      useMaterial3: true,
    ),
    home: const Encrypter(),
  );
}
