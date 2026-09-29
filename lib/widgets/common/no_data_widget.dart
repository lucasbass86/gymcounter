import 'package:flutter/material.dart';

class NoDataWidget extends StatelessWidget {
  final String title;
  const NoDataWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Text(title, style: TextStyle(fontSize: 17, color: Colors.white)),
            ),
          ),
        ),
      ],
    );
  }
}
