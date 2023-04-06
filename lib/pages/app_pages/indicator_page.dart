import 'package:flutter/material.dart';

class IndicatorPage extends StatefulWidget {
  const IndicatorPage({super.key});

  @override
  State<IndicatorPage> createState() => _IndicatorPageState();
}

class _IndicatorPageState extends State<IndicatorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("IndicatorPage"),
      ),
      body: Column(
        children: const [
          Center(
            child: Text("IndicatorPage"),
          ),
        ],
      ),
    );
  }
}
