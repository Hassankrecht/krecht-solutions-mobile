import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.accentBlue.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.build_rounded,
                  size: 64,
                  color: AppColors.accentBlue,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Under Maintenance',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkNavy,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'We\'re currently performing scheduled maintenance.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.bodyText,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please check back soon. We apologize for any inconvenience.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.bodyTextMuted,
                ),
              ),
              const SizedBox(height: 48),
              const CircularProgressIndicator(
                color: AppColors.accentBlue,
              ),
              const SizedBox(height: 16),
              const Text(
                'We\'ll be back shortly',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.bodyTextMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
