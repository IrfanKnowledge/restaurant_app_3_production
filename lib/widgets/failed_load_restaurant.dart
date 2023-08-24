import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FailedLoadRestaurant extends StatelessWidget {
  final String message;
  bool isLoading;

  FailedLoadRestaurant({super.key, required this.message, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: isLoading ? const CircularProgressIndicator() : _buildText(),
      ),
    );
  }

  Text _buildText() {
    return Text(
        message,
        style: const TextStyle(fontSize: 16),
        textAlign: TextAlign.center,
      );
  }
}
