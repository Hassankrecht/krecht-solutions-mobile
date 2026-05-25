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
      'packages': 'Packages',
      'about': 'About',
      'contact': 'Contact',
      'settings': 'Settings',
      'searchProjectsServicesPackages': 'Search projects, services, packages',

      // Home
      'welcome': 'Welcome',
      'featuredServices': 'Featured Services',
      'recentProjects': 'Recent Projects',
      'pricingPackages': 'Pricing Packages',
      'ourServices': 'Our Services',
      'featuredProjects': 'Featured Projects',
      'viewAll': 'View All',
      'all': 'All',
      'featured': 'Featured',
      'viewDetails': 'View Details',
      'noPackagesAvailable': 'No packages available',
      'noPackagesInCategory': 'No packages in this category yet.',
      'packageFallback': 'Package',
      'packagesAvailable': '{count} packages available',
      'packageAvailable': '{count} package available',
      'needHelpWithProject': 'Need help with a project?',
      'contactCtaBody': 'Reach us directly by email, phone, or WhatsApp.',
      'digitalSolutionsTitle': 'Digital solutions, built cleanly',
      'digitalSolutionsSubtitle': 'Apps, dashboards, websites, and systems.',
      'exploreProjects': 'Explore Projects',

      // Projects
      'projectDetails': 'Project Details',
      'client': 'Client',
      'status': 'Status',
      'completed': 'Completed',
      'inProgress': 'In Progress',
      'tags': 'Tags',
      'noProjects': 'No projects found',
      'ourWork': 'Our Work',
      'allCategories': 'All categories',
      'projectsAvailable': '{count} projects available',
      'projectAvailable': '{count} project available',
      'noProjectsYet': 'No projects yet',
      'projectNotFound': 'Project not found',
      'description': 'Description',
      'gallery': 'Gallery',
      'projectVideo': 'Project Video',
      'loadProjectVideo': 'Load project video',
      'viewProject': 'View Project',

      // Services
      'serviceDetails': 'Service Details',
      'noServices': 'No services found',
      'professionalServices': 'Professional Services',
      'solutionsReady': '{count} solutions ready for your business',
      'discussThisService': 'Discuss this service',

      // Contact
      'sendMessage': 'Send Message',
      'contactUs': 'Contact Us',
      'contactInformation': 'Contact Information',
      'getInTouch': 'Get in Touch',
      'contactFormSubtitle': 'We\'ll get back to you as soon as possible.',
      'fullName': 'Full Name',
      'nameRequired': 'Name is required',
      'emailAddress': 'Email Address',
      'validEmailRequired': 'Enter a valid email',
      'phoneOptional': 'Phone (optional)',
      'subjectOptional': 'Subject (optional)',
      'messageMinLength': 'Message must be at least 10 characters',
      'messageSent': 'Message Sent!',
      'messageSentBody':
          'Your message has been sent successfully. We\'ll get back to you as soon as possible.',
      'somethingWentWrong': 'Something went wrong. Please try again.',
      'subject': 'Subject',
      'message': 'Message',
      'contactSuccess': 'Message sent successfully',
      'contactError': 'Failed to send message',

      // Settings
      'language': 'Language',
      'english': 'English',
      'arabic': 'Arabic',
      'darkMode': 'Dark Mode',
      'more': 'More',
      'appConfiguration': 'App Configuration',
      'theme': 'Theme',
      'clearCache': 'Clear Cache',
      'cacheCleared': 'Cache cleared successfully',
      'privacySecurity': 'Privacy & Security',
      'support': 'Support',
      'social': 'Social',
      'contactSupport': 'Contact Support',
      'whatsApp': 'WhatsApp',
      'call': 'Call',
      'email': 'Email',
      'reportProblem': 'Report Problem',
      'aboutKrechtSolutions': 'About Krecht Solutions',
      'appVersion': 'App Version',
      'developedByKrecht': 'Developed by Krecht Solutions',
      'selectLanguage': 'Select Language',
      'selectTheme': 'Select Theme',
      'auto': 'Auto',
      'usePhoneSettings': 'Use phone settings',
      'light': 'Light',
      'alwaysLightMode': 'Always use light mode',
      'dark': 'Dark',
      'alwaysDarkMode': 'Always use dark mode',
      'privacyPolicy': 'Privacy Policy',
      'termsConditions': 'Terms & Conditions',
      'termsOfService': 'Terms of Service',
      'security': 'Security',
      'faq': 'FAQ',
      'noFaqsAvailable': 'No FAQs available at the moment.',
      'dataUsage': 'Data Usage',
      'dataUsageInformation': 'Data Usage Information',
      'dataCollection': 'Data Collection',
      'dataCollectionBody':
          'We collect data to improve your experience. This includes usage patterns, crash reports, and performance metrics.',
      'dataStorage': 'Data Storage',
      'dataStorageBody':
          'Your data is stored securely on our servers. We use industry-standard encryption to protect your information.',
      'dataSharing': 'Data Sharing',
      'dataSharingBody':
          'We do not sell your personal data to third parties. Your information is only shared with your consent or as required by law.',
      'yourRights': 'Your Rights',
      'yourRightsBody':
          'You have the right to access, correct, or delete your personal data at any time through your account settings.',
      'cookies': 'Cookies',
      'cookiesBody':
          'We use cookies to enhance your browsing experience. You can manage cookie preferences in your browser settings.',
      'offlineData': 'Offline Data',
      'offlineDataBody':
          'The app may store some data locally on your device for offline access. This data is encrypted and protected.',
      'maintenance': 'Maintenance',
      'underMaintenance': 'Under Maintenance',
      'maintenanceMessage':
          'We\'re currently performing scheduled maintenance.',
      'maintenanceCheckBack':
          'Please check back soon. We apologize for any inconvenience.',
      'backShortly': 'We\'ll be back shortly',
      'aboutUs': 'About Us',
      'ourMission': 'Our Mission',
      'aboutCompanyBody':
          'Krecht Solutions is a leading technology company specializing in innovative digital solutions. We provide cutting-edge web development, mobile applications, and cloud services to help businesses transform and grow in the digital age.',
      'ourMissionBody':
          'To empower businesses with innovative technology solutions that drive growth, efficiency, and success in the digital marketplace.',
      'ourServicesBody':
          'We specialize in web development, mobile app development, cloud solutions, UI/UX design, and digital transformation consulting.',

      // Social
      'followUs': 'Follow Us',
      'connectWithUs': 'Connect with us on social media',
      'tiktok': 'TikTok',
      'github': 'GitHub',
      'facebook': 'Facebook',
      'instagram': 'Instagram',
      'linkedin': 'LinkedIn',

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
      'packages': 'الباقات',
      'about': 'من نحن',
      'contact': 'اتصل بنا',
      'settings': 'الإعدادات',
      'searchProjectsServicesPackages': 'ابحث في المشاريع والخدمات والباقات',

      // Home
      'welcome': 'مرحباً',
      'featuredServices': 'الخدمات المميزة',
      'recentProjects': 'المشاريع الأخيرة',
      'pricingPackages': 'باقات الأسعار',
      'ourServices': 'خدماتنا',
      'featuredProjects': 'مشاريع مميزة',
      'viewAll': 'عرض الكل',
      'all': 'الكل',
      'featured': 'مميز',
      'viewDetails': 'عرض التفاصيل',
      'startingFrom': 'يبدأ من',
      'priceOnRequest': 'السعر عند الطلب',
      'noPackagesAvailable': 'لا توجد باقات متاحة',
      'noPackagesInCategory': 'لا توجد باقات في هذه الفئة حالياً.',
      'packageFallback': 'باقة',
      'packagesAvailable': '{count} باقات متاحة',
      'packageAvailable': 'باقة واحدة متاحة',
      'needHelpWithProject': 'تحتاج مساعدة في مشروع؟',
      'contactCtaBody':
          'تواصل معنا مباشرة عبر البريد الإلكتروني أو الهاتف أو واتساب.',
      'digitalSolutionsTitle': 'حلول رقمية مبنية بإتقان',
      'digitalSolutionsSubtitle': 'تطبيقات ولوحات تحكم ومواقع وأنظمة.',
      'exploreProjects': 'استكشف المشاريع',

      // Projects
      'projectDetails': 'تفاصيل المشروع',
      'client': 'العميل',
      'status': 'الحالة',
      'completed': 'مكتمل',
      'inProgress': 'قيد التنفيذ',
      'tags': 'الوسوم',
      'noProjects': 'لا توجد مشاريع',
      'ourWork': 'أعمالنا',
      'allCategories': 'كل الفئات',
      'projectsAvailable': '{count} مشاريع متاحة',
      'projectAvailable': 'مشروع واحد متاح',
      'noProjectsYet': 'لا توجد مشاريع حالياً',
      'projectNotFound': 'المشروع غير موجود',
      'description': 'الوصف',
      'gallery': 'المعرض',
      'projectVideo': 'فيديو المشروع',
      'loadProjectVideo': 'تحميل فيديو المشروع',
      'viewProject': 'عرض المشروع',

      // Services
      'serviceDetails': 'تفاصيل الخدمة',
      'noServices': 'لا توجد خدمات',
      'professionalServices': 'خدمات احترافية',
      'solutionsReady': '{count} حلول جاهزة لعملك',
      'discussThisService': 'ناقش هذه الخدمة',

      // Contact
      'sendMessage': 'إرسال رسالة',
      'contactUs': 'اتصل بنا',
      'contactInformation': 'معلومات التواصل',
      'getInTouch': 'تواصل معنا',
      'contactFormSubtitle': 'سنعاود التواصل معك في أقرب وقت ممكن.',
      'fullName': 'الاسم الكامل',
      'nameRequired': 'الاسم مطلوب',
      'emailAddress': 'عنوان البريد الإلكتروني',
      'validEmailRequired': 'أدخل بريداً إلكترونياً صالحاً',
      'phoneOptional': 'الهاتف (اختياري)',
      'subjectOptional': 'الموضوع (اختياري)',
      'messageMinLength': 'يجب أن تتكون الرسالة من 10 أحرف على الأقل',
      'messageSent': 'تم إرسال الرسالة!',
      'messageSentBody':
          'تم إرسال رسالتك بنجاح. سنعاود التواصل معك في أقرب وقت ممكن.',
      'somethingWentWrong': 'حدث خطأ ما. يرجى المحاولة مرة أخرى.',
      'subject': 'الموضوع',
      'message': 'الرسالة',
      'contactSuccess': 'تم إرسال الرسالة بنجاح',
      'contactError': 'فشل إرسال الرسالة',

      // Settings
      'language': 'اللغة',
      'english': 'English',
      'arabic': 'العربية',
      'darkMode': 'الوضع المظلم',
      'more': 'المزيد',
      'appConfiguration': 'إعدادات التطبيق',
      'theme': 'المظهر',
      'clearCache': 'مسح التخزين المؤقت',
      'cacheCleared': 'تم مسح التخزين المؤقت بنجاح',
      'privacySecurity': 'الخصوصية والأمان',
      'support': 'الدعم',
      'social': 'التواصل الاجتماعي',
      'contactSupport': 'التواصل مع الدعم',
      'whatsApp': 'واتساب',
      'call': 'اتصال',
      'email': 'البريد الإلكتروني',
      'reportProblem': 'الإبلاغ عن مشكلة',
      'aboutKrechtSolutions': 'عن كريخت سوليوشنز',
      'appVersion': 'إصدار التطبيق',
      'developedByKrecht': 'تم التطوير بواسطة كريخت سوليوشنز',
      'selectLanguage': 'اختر اللغة',
      'selectTheme': 'اختر المظهر',
      'auto': 'تلقائي',
      'usePhoneSettings': 'استخدام إعدادات الهاتف',
      'light': 'فاتح',
      'alwaysLightMode': 'استخدام الوضع الفاتح دائماً',
      'dark': 'داكن',
      'alwaysDarkMode': 'استخدام الوضع الداكن دائماً',
      'privacyPolicy': 'سياسة الخصوصية',
      'termsConditions': 'الشروط والأحكام',
      'termsOfService': 'شروط الخدمة',
      'security': 'الأمان',
      'faq': 'الأسئلة الشائعة',
      'noFaqsAvailable': 'لا توجد أسئلة شائعة حالياً.',
      'dataUsage': 'استخدام البيانات',
      'dataUsageInformation': 'معلومات استخدام البيانات',
      'dataCollection': 'جمع البيانات',
      'dataCollectionBody':
          'نجمع البيانات لتحسين تجربتك، ويشمل ذلك أنماط الاستخدام وتقارير الأعطال ومقاييس الأداء.',
      'dataStorage': 'تخزين البيانات',
      'dataStorageBody':
          'يتم تخزين بياناتك بأمان على خوادمنا، ونستخدم تشفيراً بمعايير موثوقة لحماية معلوماتك.',
      'dataSharing': 'مشاركة البيانات',
      'dataSharingBody':
          'لا نبيع بياناتك الشخصية لأطراف ثالثة. تتم مشاركة معلوماتك فقط بموافقتك أو عندما يقتضي القانون ذلك.',
      'yourRights': 'حقوقك',
      'yourRightsBody':
          'لديك الحق في الوصول إلى بياناتك الشخصية أو تصحيحها أو حذفها في أي وقت من خلال إعدادات حسابك.',
      'cookies': 'ملفات تعريف الارتباط',
      'cookiesBody':
          'نستخدم ملفات تعريف الارتباط لتحسين تجربة التصفح. يمكنك إدارة تفضيلات ملفات تعريف الارتباط من إعدادات المتصفح.',
      'offlineData': 'البيانات دون اتصال',
      'offlineDataBody':
          'قد يخزن التطبيق بعض البيانات محلياً على جهازك للوصول إليها دون اتصال. هذه البيانات مشفرة ومحمية.',
      'maintenance': 'الصيانة',
      'underMaintenance': 'قيد الصيانة',
      'maintenanceMessage': 'نقوم حالياً بإجراء صيانة مجدولة.',
      'maintenanceCheckBack': 'يرجى العودة قريباً. نعتذر عن أي إزعاج.',
      'backShortly': 'سنعود قريباً',
      'aboutUs': 'من نحن',
      'ourMission': 'مهمتنا',
      'aboutCompanyBody':
          'كريخت سوليوشنز شركة تقنية رائدة متخصصة في الحلول الرقمية المبتكرة. نقدم تطوير مواقع وتطبيقات وخدمات سحابية متقدمة لمساعدة الأعمال على التحول والنمو في العصر الرقمي.',
      'ourMissionBody':
          'تمكين الأعمال بحلول تقنية مبتكرة تدفع النمو والكفاءة والنجاح في السوق الرقمية.',
      'ourServicesBody':
          'نتخصص في تطوير المواقع وتطبيقات الهاتف والحلول السحابية وتصميم واجهات وتجارب المستخدم واستشارات التحول الرقمي.',

      // Social
      'followUs': 'تابعنا',
      'connectWithUs': 'تواصل معنا على وسائل التواصل الاجتماعي',
      'tiktok': 'تيك توك',
      'github': 'GitHub',
      'facebook': 'فيسبوك',
      'instagram': 'إنستغرام',
      'linkedin': 'لينكدإن',

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
  String get packages => get('packages');
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
