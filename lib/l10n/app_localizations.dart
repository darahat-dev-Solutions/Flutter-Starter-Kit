import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_km.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('ja'),
    Locale('km')
  ];

  /// No description provided for @signInToContinue.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get signInToContinue;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @flutterStarterKit.
  ///
  /// In en, this message translates to:
  /// **'Flutter Starter Kit'**
  String get flutterStarterKit;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @pleaseEnterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterYourEmail;

  /// No description provided for @pleaseEnterAValidEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get pleaseEnterAValidEmailAddress;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @pleaseEnterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterYourPassword;

  /// No description provided for @passwordMustBeAtLeast6Characters.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMustBeAtLeast6Characters;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @continueWithPhone.
  ///
  /// In en, this message translates to:
  /// **'Continue with Phone'**
  String get continueWithPhone;

  /// No description provided for @continueWithGithub.
  ///
  /// In en, this message translates to:
  /// **'Continue with Github'**
  String get continueWithGithub;

  /// No description provided for @dontHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAnAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @letsGetYouStarted.
  ///
  /// In en, this message translates to:
  /// **'Let\'s get you started!'**
  String get letsGetYouStarted;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @pleaseEnterYourName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get pleaseEnterYourName;

  /// No description provided for @pleaseEnterAValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get pleaseEnterAValidEmail;

  /// No description provided for @alreadyHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAnAccount;

  /// No description provided for @resetEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Reset email sent (if account exists).'**
  String get resetEmailSent;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error: '**
  String get error;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPasswordTitle;

  /// No description provided for @resetYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset your password'**
  String get resetYourPassword;

  /// No description provided for @enterTheEmailAssociatedWithYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Enter the email associated with your account and we’ll send you a link to reset your password.'**
  String get enterTheEmailAssociatedWithYourAccount;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @emailIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailIsRequired;

  /// No description provided for @enterAValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get enterAValidEmail;

  /// No description provided for @sendResetEmail.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Email'**
  String get sendResetEmail;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get backToLogin;

  /// No description provided for @enterOTP.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get enterOTP;

  /// No description provided for @enterTheOTPSentToYourPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter the OTP sent to your phone'**
  String get enterTheOTPSentToYourPhone;

  /// No description provided for @verifyOTP.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOTP;

  /// No description provided for @resendOTP.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendOTP;

  /// No description provided for @resendOTPIn.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP in '**
  String get resendOTPIn;

  /// No description provided for @enterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter Phone Number'**
  String get enterPhoneNumber;

  /// No description provided for @enterYourPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enterYourPhoneNumber;

  /// No description provided for @weWillSendYouAVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'We will send you a verification code'**
  String get weWillSendYouAVerificationCode;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @pleaseEnterYourPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get pleaseEnterYourPhoneNumber;

  /// No description provided for @sendOTP.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOTP;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @addNewTask.
  ///
  /// In en, this message translates to:
  /// **'Add New Task'**
  String get addNewTask;

  /// No description provided for @enterTaskDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter task description'**
  String get enterTaskDescription;

  /// No description provided for @addTask.
  ///
  /// In en, this message translates to:
  /// **'Add Task'**
  String get addTask;

  /// No description provided for @takeAction.
  ///
  /// In en, this message translates to:
  /// **'Take Action'**
  String get takeAction;

  /// No description provided for @taskTitle.
  ///
  /// In en, this message translates to:
  /// **'Task Title'**
  String get taskTitle;

  /// No description provided for @aiGeneratedSummary.
  ///
  /// In en, this message translates to:
  /// **'AI-Generated Summary'**
  String get aiGeneratedSummary;

  /// No description provided for @noTasksAvailableToSummarize.
  ///
  /// In en, this message translates to:
  /// **'No tasks available to summarize.'**
  String get noTasksAvailableToSummarize;

  /// No description provided for @seeLess.
  ///
  /// In en, this message translates to:
  /// **'See Less'**
  String get seeLess;

  /// No description provided for @seeMore.
  ///
  /// In en, this message translates to:
  /// **'See More'**
  String get seeMore;

  /// No description provided for @generatingSummary.
  ///
  /// In en, this message translates to:
  /// **'Generating summary...'**
  String get generatingSummary;

  /// No description provided for @unableToGenerateSummary.
  ///
  /// In en, this message translates to:
  /// **'Unable to generate summary. Please try again.'**
  String get unableToGenerateSummary;

  /// No description provided for @noTasksYet.
  ///
  /// In en, this message translates to:
  /// **'No Tasks yet'**
  String get noTasksYet;

  /// No description provided for @listening.
  ///
  /// In en, this message translates to:
  /// **'Listening...'**
  String get listening;

  /// No description provided for @secondPage.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get secondPage;

  /// No description provided for @chatAndMessages.
  ///
  /// In en, this message translates to:
  /// **'Chat and Messages'**
  String get chatAndMessages;

  /// No description provided for @thirdPage.
  ///
  /// In en, this message translates to:
  /// **'AI Chat'**
  String get thirdPage;

  /// No description provided for @aiChatAssistant.
  ///
  /// In en, this message translates to:
  /// **'AI Chat Assistant'**
  String get aiChatAssistant;

  /// No description provided for @helpCenterComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Help center coming soon!'**
  String get helpCenterComingSoon;

  /// No description provided for @dreamFlutterStarterKit.
  ///
  /// In en, this message translates to:
  /// **'Dream Flutter Starter Kit'**
  String get dreamFlutterStarterKit;

  /// No description provided for @optionSecond.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get optionSecond;

  /// No description provided for @optionThird.
  ///
  /// In en, this message translates to:
  /// **'AI Chat'**
  String get optionThird;

  /// No description provided for @readyToExplore.
  ///
  /// In en, this message translates to:
  /// **'Ready to explore? 🚀'**
  String get readyToExplore;

  /// No description provided for @newFeaturesComingSoon.
  ///
  /// In en, this message translates to:
  /// **'New Features Coming Soon!'**
  String get newFeaturesComingSoon;

  /// No description provided for @workingOnExcitingUpdates.
  ///
  /// In en, this message translates to:
  /// **'We\'re working on exciting updates'**
  String get workingOnExcitingUpdates;

  /// No description provided for @aiChatFeatures.
  ///
  /// In en, this message translates to:
  /// **'AI Chat Features'**
  String get aiChatFeatures;

  /// No description provided for @currentlyUnderDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Currently under development'**
  String get currentlyUnderDevelopment;

  /// No description provided for @aiChatDescription.
  ///
  /// In en, this message translates to:
  /// **'We\'re building AI Chat option where AI will read your REST API and reply according your provided data'**
  String get aiChatDescription;

  /// No description provided for @developmentProgress.
  ///
  /// In en, this message translates to:
  /// **'Development Progress'**
  String get developmentProgress;

  /// No description provided for @comingSoonFeatures.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon Features'**
  String get comingSoonFeatures;

  /// No description provided for @giveOrder.
  ///
  /// In en, this message translates to:
  /// **'Give Order'**
  String get giveOrder;

  /// No description provided for @aiCanTakeOrder.
  ///
  /// In en, this message translates to:
  /// **'AI can take order'**
  String get aiCanTakeOrder;

  /// No description provided for @multiModule.
  ///
  /// In en, this message translates to:
  /// **'Multi Module'**
  String get multiModule;

  /// No description provided for @multiModuleAiAct.
  ///
  /// In en, this message translates to:
  /// **'Multi Module AI Act'**
  String get multiModuleAiAct;

  /// No description provided for @voiceToText.
  ///
  /// In en, this message translates to:
  /// **'Voice to Text'**
  String get voiceToText;

  /// No description provided for @userCanOrderInVoice.
  ///
  /// In en, this message translates to:
  /// **'User can Order in voice'**
  String get userCanOrderInVoice;

  /// No description provided for @billGenerate.
  ///
  /// In en, this message translates to:
  /// **'Bill Generate'**
  String get billGenerate;

  /// No description provided for @aiCanGenerateBill.
  ///
  /// In en, this message translates to:
  /// **'AI Can Generate Bill'**
  String get aiCanGenerateBill;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @stayUpdated.
  ///
  /// In en, this message translates to:
  /// **'Stay Updated'**
  String get stayUpdated;

  /// No description provided for @notifyWhenReady.
  ///
  /// In en, this message translates to:
  /// **'We\'ll notify you when new features are ready'**
  String get notifyWhenReady;

  /// No description provided for @aiChatModule.
  ///
  /// In en, this message translates to:
  /// **'AI Chat Module'**
  String get aiChatModule;

  /// No description provided for @loadingSettings.
  ///
  /// In en, this message translates to:
  /// **'Loading settings...'**
  String get loadingSettings;

  /// No description provided for @failedToLoadSettings.
  ///
  /// In en, this message translates to:
  /// **'Failed to load settings'**
  String get failedToLoadSettings;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @darkThemeEnabled.
  ///
  /// In en, this message translates to:
  /// **'Dark theme enabled'**
  String get darkThemeEnabled;

  /// No description provided for @lightThemeEnabled.
  ///
  /// In en, this message translates to:
  /// **'Light theme enabled'**
  String get lightThemeEnabled;

  /// No description provided for @darkModeDescription.
  ///
  /// In en, this message translates to:
  /// **'Change how the app looks. Dark mode is easier on the eyes in low light.'**
  String get darkModeDescription;

  /// No description provided for @appLanguage.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get appLanguage;

  /// No description provided for @choosePreferredLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language'**
  String get choosePreferredLanguage;

  /// No description provided for @aiChatModel.
  ///
  /// In en, this message translates to:
  /// **'AI Chat Model'**
  String get aiChatModel;

  /// No description provided for @choosePreferredAiModel.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred AI model'**
  String get choosePreferredAiModel;

  /// No description provided for @aiModelCapabilities.
  ///
  /// In en, this message translates to:
  /// **'Different AI models may have varying capabilities and response styles.'**
  String get aiModelCapabilities;

  /// No description provided for @welcomeUser.
  ///
  /// In en, this message translates to:
  /// **'Welcome User'**
  String get welcomeUser;

  /// No description provided for @aiAssistant.
  ///
  /// In en, this message translates to:
  /// **'AI Assistant'**
  String get aiAssistant;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @noName.
  ///
  /// In en, this message translates to:
  /// **'No Name'**
  String get noName;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es', 'ja', 'km'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'ja': return AppLocalizationsJa();
    case 'km': return AppLocalizationsKm();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
