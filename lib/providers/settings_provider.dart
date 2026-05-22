import 'package:flutter/foundation.dart';
import '../models/app_setting_model.dart';
import '../models/faq_item_model.dart';

// Manages app settings, policy content, FAQ data, loading, and error state.
class SettingsProvider extends ChangeNotifier {
  final AppSettingModel _appSettings = const AppSettingModel(
    appName: 'Krecht Solutions',
    appLogo: '',
    appVersion: '1.0.0',
    maintenanceMode: false,
    contactPhone: '+96178768725',
    contactEmail: 'krechtsolutions@gmail.com',
    whatsappNumber: '+96178768725',
    defaultCurrency: 'USD',
    defaultLanguage: 'en',
  );
  final String _privacyPolicy = '''
Krecht Solutions respects your privacy. The mobile app uses only the information needed to provide contact, project, service, and support features.

Information you send through contact forms may include your name, email address, phone number, subject, and message. This information is used to answer your request and provide customer support.

The app may open external services such as phone, email, WhatsApp, or social media links only when you choose those actions. These services are governed by their own privacy practices.

We do not sell personal information. We keep collected information only as long as needed for business, legal, or support purposes.

For privacy questions or data requests, contact Krecht Solutions through the support options in the app.
''';
  final String _privacyPolicyAr = '''
تحترم كريخت سوليوشنز خصوصيتك. يستخدم تطبيق الهاتف فقط المعلومات اللازمة لتوفير ميزات التواصل والمشاريع والخدمات والدعم.

قد تتضمن المعلومات التي ترسلها عبر نماذج التواصل اسمك وبريدك الإلكتروني ورقم هاتفك والموضوع والرسالة. نستخدم هذه المعلومات للرد على طلبك وتقديم الدعم.

قد يفتح التطبيق خدمات خارجية مثل الهاتف أو البريد الإلكتروني أو واتساب أو روابط التواصل الاجتماعي فقط عند اختيارك لهذه الإجراءات. تخضع هذه الخدمات لسياسات الخصوصية الخاصة بها.

نحن لا نبيع المعلومات الشخصية. ونحتفظ بالمعلومات التي يتم جمعها فقط للمدة اللازمة لأغراض العمل أو المتطلبات القانونية أو الدعم.

لأسئلة الخصوصية أو طلبات البيانات، تواصل مع كريخت سوليوشنز من خلال خيارات الدعم داخل التطبيق.
''';
  final String _terms = '''
By using the Krecht Solutions app, you agree to use it only for lawful purposes and in a way that does not harm the app, backend services, or other users.

The information shown in the app is provided for general business and service reference. Project details, package information, pricing, timelines, and availability may change without notice.

Requests submitted through the app do not create a binding agreement until Krecht Solutions confirms the scope, pricing, and terms in writing.

You are responsible for the accuracy of the information you submit through forms or support channels.

Krecht Solutions may update these terms when needed. Continued use of the app means you accept the latest version available in the app.
''';
  final String _termsAr = '''
باستخدام تطبيق كريخت سوليوشنز، فإنك توافق على استخدامه فقط للأغراض القانونية وبطريقة لا تضر بالتطبيق أو خدمات الخلفية أو المستخدمين الآخرين.

تُعرض المعلومات داخل التطبيق كمرجع عام للأعمال والخدمات. قد تتغير تفاصيل المشاريع ومعلومات الباقات والأسعار والجداول الزمنية والتوفر دون إشعار مسبق.

لا تنشئ الطلبات المقدمة عبر التطبيق اتفاقاً ملزماً حتى تؤكد كريخت سوليوشنز النطاق والسعر والشروط كتابياً.

أنت مسؤول عن دقة المعلومات التي ترسلها عبر النماذج أو قنوات الدعم.

قد تقوم كريخت سوليوشنز بتحديث هذه الشروط عند الحاجة. استمرارك في استخدام التطبيق يعني قبولك لأحدث نسخة متاحة داخل التطبيق.
''';
  final String _security = '''
Krecht Solutions applies practical safeguards to protect app and service data, including secure communication with backend services, limited data collection, and controlled access to submitted contact requests.

The app does not ask for payment card information, passwords, or sensitive identity documents. Do not send confidential credentials through contact forms or messages.

Keep your device updated and avoid using modified or untrusted app versions. If you believe your information was exposed or a security issue exists, contact support immediately.

External links such as WhatsApp, email, phone, and social media open outside the app and are handled by those providers.
''';
  final String _securityAr = '''
تطبق كريخت سوليوشنز إجراءات حماية عملية لحماية بيانات التطبيق والخدمات، بما في ذلك الاتصال الآمن مع خدمات الخلفية، وتقليل جمع البيانات، والتحكم في الوصول إلى طلبات التواصل المرسلة.

لا يطلب التطبيق معلومات بطاقات الدفع أو كلمات المرور أو مستندات الهوية الحساسة. لا ترسل بيانات اعتماد سرية عبر نماذج التواصل أو الرسائل.

حافظ على تحديث جهازك وتجنب استخدام نسخ معدلة أو غير موثوقة من التطبيق. إذا كنت تعتقد أن معلوماتك تعرضت للكشف أو توجد مشكلة أمنية، فتواصل مع الدعم فوراً.

الروابط الخارجية مثل واتساب والبريد الإلكتروني والهاتف ووسائل التواصل الاجتماعي تفتح خارج التطبيق وتتم معالجتها بواسطة مزودي هذه الخدمات.
''';
  final List<FaqItemModel> _faqs = const [
    FaqItemModel(
      id: 1,
      question: 'How can I contact Krecht Solutions?',
      answer:
          'Use the Contact Support page, email option, phone option, or WhatsApp link when available in the app.',
      questionAr: 'كيف يمكنني التواصل مع كريخت سوليوشنز؟',
      answerAr:
          'استخدم صفحة التواصل مع الدعم أو خيار البريد الإلكتروني أو الهاتف أو رابط واتساب عند توفره في التطبيق.',
    ),
    FaqItemModel(
      id: 2,
      question: 'Are prices in the app final?',
      answer:
          'Prices and packages are for reference. Final pricing depends on project scope, requirements, and written confirmation.',
      questionAr: 'هل الأسعار داخل التطبيق نهائية؟',
      answerAr:
          'الأسعار والباقات مرجعية. يعتمد السعر النهائي على نطاق المشروع والمتطلبات والتأكيد الكتابي.',
    ),
    FaqItemModel(
      id: 3,
      question: 'Can I request a custom project?',
      answer:
          'Yes. Send your project details through the contact form and the team will review the request.',
      questionAr: 'هل يمكنني طلب مشروع مخصص؟',
      answerAr:
          'نعم. أرسل تفاصيل مشروعك عبر نموذج التواصل وسيقوم الفريق بمراجعة الطلب.',
    ),
    FaqItemModel(
      id: 4,
      question: 'Does the app work without these settings APIs?',
      answer:
          'Yes. Privacy, terms, security, and FAQ content are stored locally in the Flutter app.',
      questionAr: 'هل يعمل التطبيق بدون واجهات إعدادات الخلفية؟',
      answerAr:
          'نعم. يتم تخزين محتوى الخصوصية والشروط والأمان والأسئلة الشائعة محلياً داخل تطبيق Flutter.',
    ),
  ];
  bool _isLoading = false;
  String? _errorMessage;

  AppSettingModel? get appSettings => _appSettings;
  String get privacyPolicy => _privacyPolicy;
  String get terms => _terms;
  String get security => _security;
  List<FaqItemModel> get faqs => _faqs;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isInMaintenanceMode => _appSettings.maintenanceMode;

  String privacyPolicyFor(bool isArabic) =>
      isArabic ? _privacyPolicyAr : _privacyPolicy;

  String termsFor(bool isArabic) => isArabic ? _termsAr : _terms;

  String securityFor(bool isArabic) => isArabic ? _securityAr : _security;

  // Loads app settings. Current defaults keep startup fast and offline-safe.
  Future<void> fetchAppSettings() async {
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  // Loads privacy policy text from local static content.
  Future<void> fetchPrivacyPolicy() async {
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  // Loads terms and conditions text from local static content.
  Future<void> fetchTerms() async {
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  // Loads security information text from local static content.
  Future<void> fetchSecurity() async {
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  // Loads FAQ items from local static content.
  Future<void> fetchFaqs() async {
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  // Refreshes all settings-related data in parallel.
  Future<void> refreshAll() async {
    await Future.wait([
      fetchAppSettings(),
      fetchPrivacyPolicy(),
      fetchTerms(),
      fetchSecurity(),
      fetchFaqs(),
    ], eagerError: false);
  }

  // Clears the current provider error message.
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
