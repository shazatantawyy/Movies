import 'package:flutter/material.dart';
import 'package:movies/core/app_colors/app_colors.dart';
import 'package:movies/core/app_images/app_images.dart';

class OnboardingContent {
  final String title;
  final String description;
  final String image;
  final Color overlayColor;
  final bool showBackButton;
  final String buttonText;

  OnboardingContent({
    required this.title,
    required this.description,
    required this.image,
    required this.overlayColor,
    required this.showBackButton,
    required this.buttonText,
  });
}

final List<OnboardingContent> onboardingData = [
  OnboardingContent(
    title: "Find Your Next Favorite Movie Here",
    description: "Get access to a huge library of movies to suit all tastes. You will surely like it",
    image: AppImages.bg1,
    overlayColor: AppColors.black,
    showBackButton: false,
    buttonText: "Explore Now",
  ),
  OnboardingContent(
    title: "Discover Movies",
    description: "Explore a vast collection of movies in all qualities and genres. Find your next favorite film with ease.",
    image: AppImages.bg2,
    overlayColor: AppColors.blue,
    showBackButton: false,
    buttonText: "Next",
  ),
  OnboardingContent(
    title: "Explore All Genres",
    description: "Discover movies from every genre, in all available qualities. Find something new and exciting to watch every day.",
    image: AppImages.bg3,
    overlayColor: AppColors.red2,
    showBackButton: true,
    buttonText: "Next",
  ),
  OnboardingContent(
    title: "Create Watchlists",
    description: "Save movies to your watchlist to keep track of what you want to watch next. Enjoy films in various qualities and genres",
    image: AppImages.bg4,
    overlayColor: AppColors.red2,
    showBackButton: true,
    buttonText: "Next",
  ),
  OnboardingContent(
    title: "Rate, Review, and Learn",
    description: "Share your thoughts on the movies you've watched. Dive deep into film details and help others discover great movies with your reviews.",
    image: AppImages.bg5,
    overlayColor: AppColors.red2,
    showBackButton: true,
    buttonText: "Next",
  ),
  OnboardingContent(
    title: "Start Watching Now",
    description: "",
    image: AppImages.bg6,
    overlayColor: AppColors.black,
    showBackButton: true,
    buttonText: "Finish",
  ),
];