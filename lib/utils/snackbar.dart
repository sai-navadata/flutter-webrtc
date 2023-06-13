import 'package:flutter/material.dart';

class SnackBarUtil extends StatelessWidget {
  const SnackBarUtil({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SnackBar(
        content: Text('Copied stream ID to clipboard'),
        duration: Duration(seconds: 1),
      ),
    );
  }
}
