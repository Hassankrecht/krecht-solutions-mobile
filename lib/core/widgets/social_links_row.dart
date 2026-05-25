import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/social_links.dart';

enum SocialLinksStyle { soft, filled }

// Data holder for one social platform entry.
class _SocialItem {
  const _SocialItem({
    required this.icon,
    required this.label,
    required this.url,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String url;
  final Color color;
}

// Reusable row of tappable social media icon buttons.
// Reads API values first; falls back to [SocialLinks] constants.
class SocialLinksRow extends StatelessWidget {
  const SocialLinksRow({
    super.key,
    this.facebookUrl,
    this.instagramUrl,
    this.tiktokUrl,
    this.linkedinUrl,
    this.githubUrl,
    this.whatsappUrl,
    this.useFallbacks = true,
    this.style = SocialLinksStyle.soft,
    this.iconSize = 20.0,
    this.buttonSize = 42.0,
  });

  final String? facebookUrl;
  final String? instagramUrl;
  final String? tiktokUrl;
  final String? linkedinUrl;
  final String? githubUrl;
  final String? whatsappUrl;
  final bool useFallbacks;
  final SocialLinksStyle style;
  final double iconSize;
  final double buttonSize;

  Future<void> _launch(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  String? _resolve(String? apiValue, String fallback) {
    if (apiValue != null && apiValue.isNotEmpty) return apiValue;
    if (!useFallbacks || fallback.isEmpty) return null;
    return fallback;
  }

  @override
  Widget build(BuildContext context) {
    final items = <_SocialItem>[
      if (_resolve(facebookUrl, SocialLinks.facebook) != null)
        _SocialItem(
          icon: Icons.facebook_rounded,
          label: 'Facebook',
          url: _resolve(facebookUrl, SocialLinks.facebook)!,
          color: const Color(0xFF1877F2),
        ),
      if (_resolve(instagramUrl, SocialLinks.instagram) != null)
        _SocialItem(
          icon: Icons.camera_alt_rounded,
          label: 'Instagram',
          url: _resolve(instagramUrl, SocialLinks.instagram)!,
          color: const Color(0xFFE1306C),
        ),
      if (_resolve(tiktokUrl, SocialLinks.tiktok) != null)
        _SocialItem(
          icon: Icons.music_video_rounded,
          label: 'TikTok',
          url: _resolve(tiktokUrl, SocialLinks.tiktok)!,
          color: const Color(0xFFFE2C55),
        ),
      if (_resolve(linkedinUrl, SocialLinks.linkedin) != null)
        _SocialItem(
          icon: Icons.work_rounded,
          label: 'LinkedIn',
          url: _resolve(linkedinUrl, SocialLinks.linkedin)!,
          color: const Color(0xFF0A66C2),
        ),
      if (_resolve(githubUrl, SocialLinks.github) != null)
        _SocialItem(
          icon: Icons.code_rounded,
          label: 'GitHub',
          url: _resolve(githubUrl, SocialLinks.github)!,
          color: const Color(0xFF24292F),
        ),
      if (_resolve(whatsappUrl, SocialLinks.whatsapp) != null)
        _SocialItem(
          icon: Icons.chat_rounded,
          label: 'WhatsApp',
          url: _resolve(whatsappUrl, SocialLinks.whatsapp)!,
          color: const Color(0xFF25D366),
        ),
    ];

    if (items.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: items
          .map(
            (item) {
              final isFilled = style == SocialLinksStyle.filled;
              final isGithub = item.label == 'GitHub';
              final backgroundColor = isFilled
                  ? isGithub
                        ? const Color(0xFFF8FAFC)
                        : item.color
                  : item.color.withValues(alpha: 0.10);
              final borderColor = isFilled
                  ? isGithub
                        ? Colors.white.withValues(alpha: 0.72)
                        : item.color.withValues(alpha: 0.82)
                  : item.color.withValues(alpha: 0.28);
              final iconColor = isFilled
                  ? isGithub
                        ? item.color
                        : Colors.white
                  : item.color;

              return Tooltip(
                message: item.label,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => _launch(item.url),
                  child: Container(
                    width: buttonSize,
                    height: buttonSize,
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: borderColor),
                      boxShadow: isFilled
                          ? [
                              BoxShadow(
                                color: item.color.withValues(alpha: 0.22),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ]
                          : null,
                    ),
                    child: Icon(item.icon, color: iconColor, size: iconSize),
                  ),
                ),
              );
            },
          )
          .toList(),
    );
  }
}
