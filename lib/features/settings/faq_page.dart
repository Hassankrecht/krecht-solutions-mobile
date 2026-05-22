import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../models/faq_item_model.dart';
import '../../providers/language_provider.dart';
import '../../providers/settings_provider.dart';

// FAQ screen that displays local static question/answer items.
class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final isArabic = context.watch<LanguageProvider>().isArabic;
    final faqs = context.watch<SettingsProvider>().faqs;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.darkNavy,
        title: Text(
          l10n?.faq ?? 'FAQ',
          style: const TextStyle(
            color: AppColors.contrast,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: faqs.isEmpty
          ? Center(
              child: Text(
                l10n?.get('noFaqsAvailable') ??
                    'No FAQs available at the moment.',
                style: const TextStyle(color: AppColors.bodyTextMuted),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: faqs.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final faq = faqs[index];
                return _FaqCard(faq: faq, isArabic: isArabic);
              },
            ),
    );
  }
}

// Expandable card for one FAQ question and answer.
class _FaqCard extends StatefulWidget {
  const _FaqCard({required this.faq, required this.isArabic});

  final FaqItemModel faq;
  final bool isArabic;

  @override
  State<_FaqCard> createState() => _FaqCardState();
}

class _FaqCardState extends State<_FaqCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowSoft,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        onExpansionChanged: (expanded) {
          setState(() {
            _isExpanded = expanded;
          });
        },
        title: Text(
          widget.faq.getLocalizedQuestion(widget.isArabic),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: colorScheme.primary,
          ),
        ),
        trailing: Icon(
          _isExpanded ? Icons.expand_less : Icons.expand_more,
          color: AppColors.bodyTextMuted,
        ),
        children: [
          Text(
            widget.faq.getLocalizedAnswer(widget.isArabic),
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurface,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
