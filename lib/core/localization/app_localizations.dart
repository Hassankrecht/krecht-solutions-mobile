import 'package:flutter/material.dart';

// Lightweight localization helper for English and Arabic app strings.
class AppLocalizations {
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  final Locale locale;

  AppLocalizations(this.locale);

  // Localized string table grouped by language code.
  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // App
      'appName': 'Krecht Solutions',

      // Navigation
      'home': 'Home',
      'projects': 'Projects',
      'services': 'Services',
      'about': 'About',
      'contact': 'Contact',
      'settings': 'Settings',

      // Home
      'welcome': 'Welcome',
      'featuredServices': 'Featured Services',
      'recentProjects': 'Recent Projects',

      // Projects
      'projectDetails': 'Project Details',
      'client': 'Client',
      'status': 'Status',
      'completed': 'Completed',
      'inProgress': 'In Progress',
      'tags': 'Tags',
      'noProjects': 'No projects found',

      // Services
      'serviceDetails': 'Service Details',
      'noServices': 'No services found',

      // Contact
      'sendMessage': 'Send Message',
      'subject': 'Subject',
      'message': 'Message',
      'contactSuccess': 'Message sent successfully',
      'contactError': 'Failed to send message',

      // Settings
      'language': 'Language',
      'english': 'English',
      'arabic': 'Arabic',
      'darkMode': 'Dark Mode',
      'privacyPolicy': 'Privacy Policy',
      'termsOfService': 'Terms of Service',
      'security': 'Security',
      'faq': 'FAQ',
      'dataUsage': 'Data Usage',
      'maintenance': 'Maintenance',
      'aboutUs': 'About Us',

      // Common
      'save': 'Save',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'edit': 'Edit',
      'close': 'Close',
      'loading': 'Loading...',
      'error': 'Error',
      'retry': 'Retry',
      'noData': 'No data available',
      'search': 'Search',
      'filter': 'Filter',
      'sort': 'Sort',
      'refresh': 'Refresh',
      'submit': 'Submit',
      'back': 'Back',
      'next': 'Next',
      'previous': 'Previous',
      'done': 'Done',
      'yes': 'Yes',
      'no': 'No',
      'ok': 'OK',
      'or': 'or',
      'and': 'and',
    },
    'ar': {
      // App
      'appName': 'حلول كريخت',

      // Navigation
      'home': 'الرئيسية',
      'projects': 'المشاريع',
      'services': 'الخدمات',
      'about': 'من نحن',
      'contact': 'اتصل بنا',
      'settings': 'الإعدادات',

      // Home
      'welcome': 'مرحباً',
      'featuredServices': 'الخدمات المميزة',
      'recentProjects': 'المشاريع الأخيرة',

      // Projects
      'projectDetails': 'تفاصيل المشروع',
      'client': 'العميل',
      'status': 'الحالة',
      'completed': 'مكتمل',
      'inProgress': 'قيد التنفيذ',
      'tags': 'الوسوم',
      'noProjects': 'لا توجد مشاريع',

      // Services
      'serviceDetails': 'تفاصيل الخدمة',
      'noServices': 'لا توجد خدمات',

      // Contact
      'sendMessage': 'إرسال رسالة',
      'subject': 'الموضوع',
      'message': 'الرسالة',
      'contactSuccess': 'تم إرسال الرسالة بنجاح',
      'contactError': 'فشل إرسال الرسالة',

      // Settings
      'language': 'اللغة',
      'english': 'English',
      'arabic': 'العربية',
      'darkMode': 'الوضع المظلم',
      'privacyPolicy': 'سياسة الخصوصية',
      'termsOfService': 'شروط الخدمة',
      'security': 'الأمان',
      'faq': 'الأسئلة الشائعة',
      'dataUsage': 'استخدام البيانات',
      'maintenance': 'الصيانة',
      'aboutUs': 'من نحن',

      // Common
      'save': 'حفظ',
      'cancel': 'إلغاء',
      'delete': 'حذف',
      'edit': 'تعديل',
      'close': 'إغلاق',
      'loading': 'جاري التحميل...',
      'error': 'خطأ',
      'retry': 'إعادة المحاولة',
      'noData': 'لا توجد بيانات',
      'search': 'بحث',
      'filter': 'تصفية',
      'sort': 'ترتيب',
      'refresh': 'تحديث',
      'submit': 'إرسال',
      'back': 'رجوع',
      'next': 'التالي',
      'previous': 'السابق',
      'done': 'تم',
      'yes': 'نعم',
      'no': 'لا',
      'ok': 'موافق',
      'or': 'أو',
      'and': 'و',
    },
  };

  // Returns a localized value, falling back to English and then the key.
  String get(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']![key] ??
        key;
  }

  // Convenience getters
  String get appName => get('appName');

  // Navigation
  String get home => get('home');
  String get projects => get('projects');
  String get services => get('services');
  String get about => get('about');
  String get contact => get('contact');
  String get settings => get('settings');

  // Home
  String get welcome => get('welcome');
  String get featuredServices => get('featuredServices');
  String get recentProjects => get('recentProjects');

  // Projects
  String get projectDetails => get('projectDetails');
  String get client => get('client');
  String get status => get('status');
  String get completed => get('completed');
  String get inProgress => get('inProgress');
  String get tags => get('tags');
  String get noProjects => get('noProjects');

  // Services
  String get serviceDetails => get('serviceDetails');
  String get noServices => get('noServices');

  // Contact
  String get sendMessage => get('sendMessage');
  String get subject => get('subject');
  String get message => get('message');
  String get contactSuccess => get('contactSuccess');
  String get contactError => get('contactError');

  // Settings
  String get language => get('language');
  String get english => get('english');
  String get arabic => get('arabic');
  String get darkMode => get('darkMode');
  String get privacyPolicy => get('privacyPolicy');
  String get termsOfService => get('termsOfService');
  String get security => get('security');
  String get faq => get('faq');
  String get dataUsage => get('dataUsage');
  String get maintenance => get('maintenance');
  String get aboutUs => get('aboutUs');

  // Common
  String get save => get('save');
  String get cancel => get('cancel');
  String get delete => get('delete');
  String get edit => get('edit');
  String get close => get('close');
  String get loading => get('loading');
  String get error => get('error');
  String get retry => get('retry');
  String get noData => get('noData');
  String get search => get('search');
  String get filter => get('filter');
  String get sort => get('sort');
  String get refresh => get('refresh');
  String get submit => get('submit');
  String get back => get('back');
  String get next => get('next');
  String get previous => get('previous');
  String get done => get('done');
  String get yes => get('yes');
  String get no => get('no');
  String get ok => get('ok');
  String get or => get('or');
  String get and => get('and');
}

// Connects AppLocalizations to Flutter's localization system.
class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
