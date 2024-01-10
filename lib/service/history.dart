import 'package:flutter/material.dart';
class HistoryPage extends StatelessWidget {
  final List<String> allChanges;

  const HistoryPage({Key? key, required this.allChanges}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: ListView(
        children: allChanges.map((change) => ListTile(title: Text(change))).toList(),
      ),
    );
  }
}
