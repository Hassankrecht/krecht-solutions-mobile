/// Represents `GET /api/app-settings` response.
class AppSettingModel {
  const AppSettingModel({
    required this.appName,
    required this.appLogo,
    required this.appVersion,
    required this.maintenanceMode,
    required this.contactPhone,
    required this.contactEmail,
    required this.whatsappNumber,
    this.facebookUrl,
    this.instagramUrl,
    this.linkedinUrl,
    required this.defaultCurrency,
    required this.defaultLanguage,
    this.privacyPolicy,
    this.termsConditions,
    this.securityText,
  });

  final String appName;
  final String appLogo;
  final String appVersion;
  final bool maintenanceMode;
  final String contactPhone;
  final String contactEmail;
  final String whatsappNumber;
  final String? facebookUrl;
  final String? instagramUrl;
  final String? linkedinUrl;
  final String defaultCurrency;
  final String defaultLanguage;
  final String? privacyPolicy;
  final String? termsConditions;
  final String? securityText;

  // Creates settings from API JSON, accepting either wrapped or direct data.
  factory AppSettingModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return AppSettingModel(
      appName: data['app_name']?.toString() ?? 'Krecht Solutions',
      appLogo: data['app_logo']?.toString() ?? '',
      appVersion: data['app_version']?.toString() ?? '1.0.0',
      maintenanceMode:
          data['maintenance_mode'] == true ||
          data['maintenance_mode'] == '1' ||
          data['maintenance_mode']?.toString().toLowerCase() == 'true',
      contactPhone: data['contact_phone']?.toString() ?? '',
      contactEmail: data['contact_email']?.toString() ?? '',
      whatsappNumber: data['whatsapp_number']?.toString() ?? '',
      facebookUrl: data['facebook_url']?.toString(),
      instagramUrl: data['instagram_url']?.toString(),
      linkedinUrl: data['linkedin_url']?.toString(),
      defaultCurrency: data['default_currency']?.toString() ?? 'USD',
      defaultLanguage: data['default_language']?.toString() ?? 'en',
      privacyPolicy: data['privacy_policy']?.toString(),
      termsConditions: data['terms_conditions']?.toString(),
      securityText: data['security_text']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'app_name': appName,
    'app_logo': appLogo,
    'app_version': appVersion,
    'maintenance_mode': maintenanceMode,
    'contact_phone': contactPhone,
    'contact_email': contactEmail,
    'whatsapp_number': whatsappNumber,
    'facebook_url': facebookUrl,
    'instagram_url': instagramUrl,
    'linkedin_url': linkedinUrl,
    'default_currency': defaultCurrency,
    'default_language': defaultLanguage,
    'privacy_policy': privacyPolicy,
    'terms_conditions': termsConditions,
    'security_text': securityText,
  };

  // Compatibility getter for older code that accesses settings by key.
  String? get(String key) {
    final fieldMap = {
      'contact_phone': contactPhone,
      'contact_email': contactEmail,
      'contact_whatsapp': whatsappNumber,
      'social_facebook': facebookUrl,
      'social_instagram': instagramUrl,
      'social_linkedin': linkedinUrl,
      'app_name': appName,
      'app_logo': appLogo,
      'app_version': appVersion,
      'default_currency': defaultCurrency,
      'default_language': defaultLanguage,
    };
    return fieldMap[key];
  }
}
