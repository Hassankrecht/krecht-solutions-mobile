import 'package:flutter/material.dart';
import '../../core/api/api_client.dart';
import '../../core/theme/app_colors.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  List<Map<String, dynamic>> _faqs = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadFaqs();
  }

  Future<void> _loadFaqs() async {
    try {
      final response = await ApiClient.instance.getFaqs();
      setState(() {
        _faqs = List<Map<String, dynamic>>.from(
          response['data'] is List 
              ? response['data'] 
              : [],
        );
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load FAQs: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkNavy,
        title: const Text(
          'FAQ',
          style: TextStyle(
            color: AppColors.contrast,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: AppColors.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppColors.bodyText),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadFaqs,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : _faqs.isEmpty
                  ? const Center(
                      child: Text(
                        'No FAQs available at the moment.',
                        style: TextStyle(color: AppColors.bodyTextMuted),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(20),
                      itemCount: _faqs.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final faq = _faqs[index];
                        return _FaqCard(
                          question: faq['question'] ?? 'No question',
                          answer: faq['answer'] ?? 'No answer available',
                        );
                      },
                    ),
    );
  }
}

class _FaqCard extends StatefulWidget {
  const _FaqCard({
    required this.question,
    required this.answer,
  });

  final String question;
  final String answer;

  @override
  State<_FaqCard> createState() => _FaqCardState();
}

class _FaqCardState extends State<_FaqCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
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
          widget.question,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.darkNavy,
          ),
        ),
        trailing: Icon(
          _isExpanded ? Icons.expand_less : Icons.expand_more,
          color: AppColors.bodyTextMuted,
        ),
        children: [
          Text(
            widget.answer,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.bodyText,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
