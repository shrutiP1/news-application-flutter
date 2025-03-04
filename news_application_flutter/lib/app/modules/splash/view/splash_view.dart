// lib/app/modules/splash/view/splash_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/app/constants/constants.dart';
import 'package:news_app/app/modules/splash/controller/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use a gradient background
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.cyan, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Container(
                height: 250,
                width: 250,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle, // Make the logo circular
                  color: Colors.white, // Background color for the logo
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4), // Shadow position
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    Constants.logo,
                    fit: BoxFit.cover, // Cover the entire container
                  ),
                ),
              ),

              SizedBox(
                width: 320,
                height: 300,
                child: Image.asset(Constants.lottieAnimation),
              ),
              const SizedBox(height: 20), // Space below the animation
              // Optional: Add a loading indicator or text
            ],
          ),
        ),
      ),
    );
  }
}
