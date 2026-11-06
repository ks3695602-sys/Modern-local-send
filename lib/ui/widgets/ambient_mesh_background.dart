import 'dart:io';
import 'package:flutter/material.dart';

class AmbientMeshBackground extends StatelessWidget {
  const AmbientMeshBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Base dark luxury gradient
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0A0C16),
                Color(0xFF101322),
                Color(0xFF07080E),
              ],
            ),
          ),
        ),

        // Glowing chromatic refraction orbs for Glass shaders to refract against
        Positioned(
          top: -80,
          right: -50,
          child: Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF007AFF).withOpacity(0.40),
                  const Color(0xFF5856D6).withOpacity(0.18),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 340,
          left: -100,
          child: Container(
            width: 380,
            height: 380,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFAF52DE).withOpacity(0.32),
                  const Color(0xFFFF2D55).withOpacity(0.12),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -100,
          right: -40,
          child: Container(
            width: 360,
            height: 360,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF34C759).withOpacity(0.28),
                  const Color(0xFF007AFF).withOpacity(0.10),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Wallpaper asset if present
        Image.asset(
          'assets/images/wallpaper_dark.jpg',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
        ),

        // Subtle vignette
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.20),
                Colors.transparent,
                Colors.black.withOpacity(0.55),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
