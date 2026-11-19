import 'package:flutter/material.dart';
import '../widgets/menu.dart'; // Llama a tu diseño modular

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Menu();
  }
}