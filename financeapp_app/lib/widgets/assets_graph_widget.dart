import 'package:flutter/material.dart';

class AssetsGraphWidget extends StatelessWidget {
  const AssetsGraphWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: SizedBox(height: 300, child: Text('Assets Graph', style: TextStyle(fontWeight: FontWeight.bold),)),
    );
  }
}
