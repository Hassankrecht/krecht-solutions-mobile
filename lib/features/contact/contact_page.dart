import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/api/api_client.dart';
import '../../core/api/api_exception.dart';
import '../../core/config/social_links.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/social_links_row.dart';
import '../../providers/settings_provider.dart';

// Contact screen with a submit form and optional company contact details.
class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  bool _isLoading = false;
  bool _submitted = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // Validates the form and sends the contact message to the API.
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      await ApiClient.instance.submitContact(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        subject: _subjectController.text.trim(),
        message: _messageController.text.trim(),
      );
      if (mounted) setState(() => _submitted = true);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (_) {
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        setState(
          () => _error =
              l10n?.get('somethingWentWrong') ??
              'Something went wrong. Please try again.',
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkNavy,
        title: Text(
          l10n?.get('contactUs') ?? 'Contact Us',
          style: const TextStyle(
            color: AppColors.contrast,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _submitted ? const _SuccessState() : _buildContent(),
    );
  }

  // Builds the top contact-info area plus the message form.
  Widget _buildContent() {
    return Column(
      children: [
        _buildContactInfo(),
        Expanded(child: _buildForm()),
      ],
    );
  }

  // Shows local company contact actions.
  Widget _buildContactInfo() {
    final l10n = AppLocalizations.of(context);
    final settings = context.watch<SettingsProvider>().appSettings;
    final phone = settings?.contactPhone ?? '';
    final email = settings?.contactEmail ?? '';
    final whatsapp = settings?.whatsappNumber ?? '';

    if (phone.isEmpty && email.isEmpty && whatsapp.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n?.get('contactInformation') ?? 'Contact Information',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.darkNavy,
            ),
          ),
          const SizedBox(height: 16),
          if (phone.isNotEmpty)
            _ContactTile(
              icon: Icons.call_outlined,
              label: AppLocalizations.of(context)?.get('call') ?? 'Call',
              value: phone,
              onTap: () => _launchUrl('tel:$phone'),
            ),
          if (whatsapp.isNotEmpty)
            _ContactTile(
              icon: Icons.chat_outlined,
              label:
                  AppLocalizations.of(context)?.get('whatsApp') ?? 'WhatsApp',
              value: whatsapp,
              onTap: () => _launchUrl('https://wa.me/${_digitsOnly(whatsapp)}'),
            ),
          if (email.isNotEmpty)
            _ContactTile(
              icon: Icons.email_outlined,
              label: AppLocalizations.of(context)?.get('email') ?? 'Email',
              value: email,
              onTap: () => _launchUrl('mailto:$email'),
            ),
        ],
      ),
    );
  }

  String _digitsOnly(String value) {
    return value.replaceAll(RegExp(r'\D'), '');
  }

  Future<void> _launchUrl(String urlString) async {
    final uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Widget _buildForm() {
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n?.get('getInTouch') ?? 'Get in Touch',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.darkNavy,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n?.get('contactFormSubtitle') ??
                  'We\'ll get back to you as soon as possible.',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.bodyTextMuted,
              ),
            ),
            const SizedBox(height: 24),
            if (_error != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Text(
                  _error!,
                  style: TextStyle(color: Colors.red.shade700, fontSize: 13),
                ),
              ),
              const SizedBox(height: 16),
            ],
            _Field(
              controller: _nameController,
              label: l10n?.get('fullName') ?? 'Full Name',
              icon: Icons.person_outline,
              action: TextInputAction.next,
              validator: (v) => v == null || v.trim().isEmpty
                  ? (l10n?.get('nameRequired') ?? 'Name is required')
                  : null,
            ),
            const SizedBox(height: 14),
            _Field(
              controller: _emailController,
              label: l10n?.get('emailAddress') ?? 'Email Address',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              action: TextInputAction.next,
              validator: (v) => v == null || !v.contains('@')
                  ? (l10n?.get('validEmailRequired') ?? 'Enter a valid email')
                  : null,
            ),
            const SizedBox(height: 14),
            _Field(
              controller: _phoneController,
              label: l10n?.get('phoneOptional') ?? 'Phone (optional)',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              action: TextInputAction.next,
            ),
            const SizedBox(height: 14),
            _Field(
              controller: _subjectController,
              label: l10n?.get('subjectOptional') ?? 'Subject (optional)',
              icon: Icons.subject_rounded,
              action: TextInputAction.next,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _messageController,
              maxLines: 5,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                labelText: l10n?.message ?? 'Message',
                alignLabelWithHint: true,
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(bottom: 64),
                  child: Icon(Icons.message_outlined),
                ),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (v) => v == null || v.trim().length < 10
                  ? (l10n?.get('messageMinLength') ??
                        'Message must be at least 10 characters')
                  : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentBlue,
                foregroundColor: AppColors.contrast,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _isLoading ? null : _submit,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.contrast,
                      ),
                    )
                  : Text(
                      l10n?.sendMessage ?? 'Send Message',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
            const SizedBox(height: 28),
            _SocialContactSection(
              settings: context.watch<SettingsProvider>().appSettings,
            ),
          ],
        ),
      ),
    );
  }
}

// Standard text field used by the contact form.
class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.action = TextInputAction.next,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final TextInputAction action;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: action,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      validator: validator,
    );
  }
}

// Confirmation screen shown after the contact form submits successfully.
class _SuccessState extends StatelessWidget {
  const _SuccessState();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_outline_rounded,
                size: 52,
                color: Colors.green.shade600,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n?.get('messageSent') ?? 'Message Sent!',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.darkNavy,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              l10n?.get('messageSentBody') ??
                  'Your message has been sent successfully. We\'ll get back to you as soon as possible.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.bodyTextMuted,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Social links section shown below the contact form.
class _SocialContactSection extends StatelessWidget {
  const _SocialContactSection({required this.settings});

  final dynamic settings;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n?.get('followUs') ?? 'Follow Us',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.darkNavy,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n?.get('connectWithUs') ?? 'Connect with us on social media',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.bodyTextMuted,
            ),
          ),
          const SizedBox(height: 14),
          SocialLinksRow(
            facebookUrl: settings?.facebookUrl,
            instagramUrl: settings?.instagramUrl,
            linkedinUrl: settings?.linkedinUrl,
            whatsappUrl: settings?.whatsappNumber?.isNotEmpty == true
                ? 'https://wa.me/${settings!.whatsappNumber}'
                : SocialLinks.whatsapp,
          ),
        ],
      ),
    );
  }
}

// Contact detail row that can optionally open phone, email, or link actions.
class _ContactTile extends StatelessWidget {
  const _ContactTile({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.accentBlue.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 20, color: AppColors.accentBlue),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.bodyTextMuted,
                    ),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.darkNavy,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(Icons.open_in_new, size: 16, color: AppColors.bodyTextMuted),
          ],
        ),
      ),
    );
  }
}
