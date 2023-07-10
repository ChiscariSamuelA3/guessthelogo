import 'package:flutter/material.dart';
import '../models/logo.dart';

class LogoCard extends StatelessWidget {
  final Logo logo;

  const LogoCard({super.key, required this.logo});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 150,  
        height: 150,  
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            logo.imagePath,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}