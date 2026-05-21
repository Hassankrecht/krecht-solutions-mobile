import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/api/api_client.dart';
import '../../core/api/api_exception.dart';
import '../../core/theme/app_colors.dart';
import '../../models/app_setting_model.dart';

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
  final bool _isSettingsLoading = false;
  String? _error;
  AppSettingModel? _settings;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

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
        setState(() => _error = 'Something went wrong. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkNavy,
        title: const Text(
          'Contact Us',
          style: TextStyle(
            color: AppColors.contrast,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _submitted ? const _SuccessState() : _buildContent(),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        if (!_isSettingsLoading && _settings != null) _buildContactInfo(),
        Expanded(child: _buildForm()),
      ],
    );
  }

  Widget _buildContactInfo() {
    final phone = _settings?.get('contact_phone');
    final email = _settings?.get('contact_email');
    final location = _settings?.get('contact_location');
    final whatsapp = _settings?.get('contact_whatsapp');
    final facebook = _settings?.get('social_facebook');
    final twitter = _settings?.get('social_twitter');
    final instagram = _settings?.get('social_instagram');
    final linkedin = _settings?.get('social_linkedin');

    if (phone == null &&
        email == null &&
        location == null &&
        whatsapp == null &&
        facebook == null &&
        twitter == null &&
        instagram == null &&
        linkedin == null) {
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
          const Text(
            'Contact Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.darkNavy,
            ),
          ),
          const SizedBox(height: 16),
          if (phone != null)
            _ContactTile(
              icon: Icons.phone,
              label: 'Phone',
              value: phone,
              onTap: () => _launchUrl('tel:$phone'),
            ),
          if (email != null)
            _ContactTile(
              icon: Icons.email,
              label: 'Email',
              value: email,
              onTap: () => _launchUrl('mailto:$email'),
            ),
          if (location != null)
            _ContactTile(
              icon: Icons.location_on,
              label: 'Location',
              value: location,
              onTap: () => _launchUrl(
                'https://maps.google.com/?q=${Uri.encodeComponent(location)}',
              ),
            ),
          if (whatsapp != null)
            _ContactTile(
              icon: Icons.chat,
              label: 'WhatsApp',
              value: whatsapp,
              onTap: () => _launchUrl('https://wa.me/$whatsapp'),
            ),
          if (facebook != null ||
              twitter != null ||
              instagram != null ||
              linkedin != null) ...[
            const SizedBox(height: 8),
            const Text(
              'Follow Us',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.darkNavy,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              children: [
                if (facebook != null)
                  _SocialButton(icon: Icons.facebook, url: facebook),
                if (twitter != null)
                  _SocialButton(icon: Icons.alternate_email, url: twitter),
                if (instagram != null)
                  _SocialButton(icon: Icons.camera_alt, url: instagram),
                if (linkedin != null)
                  _SocialButton(icon: Icons.work, url: linkedin),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    final uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Get in Touch',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.darkNavy,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'We\'ll get back to you as soon as possible.',
              style: TextStyle(fontSize: 14, color: AppColors.bodyTextMuted),
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
              label: 'Full Name',
              icon: Icons.person_outline,
              action: TextInputAction.next,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Name is required' : null,
            ),
            const SizedBox(height: 14),
            _Field(
              controller: _emailController,
              label: 'Email Address',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              action: TextInputAction.next,
              validator: (v) =>
                  v == null || !v.contains('@') ? 'Enter a valid email' : null,
            ),
            const SizedBox(height: 14),
            _Field(
              controller: _phoneController,
              label: 'Phone (optional)',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              action: TextInputAction.next,
            ),
            const SizedBox(height: 14),
            _Field(
              controller: _subjectController,
              label: 'Subject (optional)',
              icon: Icons.subject_rounded,
              action: TextInputAction.next,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _messageController,
              maxLines: 5,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                labelText: 'Message',
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
                  ? 'Message must be at least 10 characters'
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
                  : const Text(
                      'Send Message',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

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

class _SuccessState extends StatelessWidget {
  const _SuccessState();

  @override
  Widget build(BuildContext context) {
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
            const Text(
              'Message Sent!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.darkNavy,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Your message has been sent successfully. We\'ll get back to you as soon as possible.',
              textAlign: TextAlign.center,
              style: TextStyle(
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

class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.icon, required this.url});

  final IconData icon;
  final String url;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        }
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.darkNavy,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(icon, size: 20, color: AppColors.contrast),
      ),
    );
  }
}
