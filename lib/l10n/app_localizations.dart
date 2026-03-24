import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
  ];

  /// No description provided for @actionAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get actionAdd;

  /// No description provided for @actionBrewAgain.
  ///
  /// In en, this message translates to:
  /// **'Brew Again'**
  String get actionBrewAgain;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// No description provided for @actionGoBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get actionGoBack;

  /// No description provided for @actionRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get actionRetry;

  /// No description provided for @actionShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get actionShare;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'OneBrew'**
  String get appTitle;

  /// No description provided for @brewActionAddCustomParameter.
  ///
  /// In en, this message translates to:
  /// **'Add Custom Parameter'**
  String get brewActionAddCustomParameter;

  /// No description provided for @brewActionAddParameter.
  ///
  /// In en, this message translates to:
  /// **'Add Parameter'**
  String get brewActionAddParameter;

  /// No description provided for @brewActionApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get brewActionApply;

  /// No description provided for @brewActionClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get brewActionClear;

  /// No description provided for @brewAddParamFieldDefaultLabel.
  ///
  /// In en, this message translates to:
  /// **'Default (optional)'**
  String get brewAddParamFieldDefaultLabel;

  /// No description provided for @brewAddParamFieldMaxLabel.
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get brewAddParamFieldMaxLabel;

  /// No description provided for @brewAddParamFieldMinLabel.
  ///
  /// In en, this message translates to:
  /// **'Min'**
  String get brewAddParamFieldMinLabel;

  /// No description provided for @brewAddParamFieldNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Flow Rate'**
  String get brewAddParamFieldNameHint;

  /// No description provided for @brewAddParamFieldStepLabel.
  ///
  /// In en, this message translates to:
  /// **'Step (optional)'**
  String get brewAddParamFieldStepLabel;

  /// No description provided for @brewAddParamFieldTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get brewAddParamFieldTypeLabel;

  /// No description provided for @brewAddParamFieldUnitHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. g, ml, bar'**
  String get brewAddParamFieldUnitHint;

  /// No description provided for @brewAddParamFieldUnitLabel.
  ///
  /// In en, this message translates to:
  /// **'Unit (optional)'**
  String get brewAddParamFieldUnitLabel;

  /// No description provided for @brewAddParamSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'New Parameter'**
  String get brewAddParamSheetTitle;

  /// No description provided for @brewAddParamValidationDefaultWithinRange.
  ///
  /// In en, this message translates to:
  /// **'Default must stay within range.'**
  String get brewAddParamValidationDefaultWithinRange;

  /// No description provided for @brewAddParamValidationMaxGreaterThanMin.
  ///
  /// In en, this message translates to:
  /// **'Max must be greater than min.'**
  String get brewAddParamValidationMaxGreaterThanMin;

  /// No description provided for @brewAddParamValidationMaxRequired.
  ///
  /// In en, this message translates to:
  /// **'Max is required.'**
  String get brewAddParamValidationMaxRequired;

  /// No description provided for @brewAddParamValidationMinRequired.
  ///
  /// In en, this message translates to:
  /// **'Min is required.'**
  String get brewAddParamValidationMinRequired;

  /// No description provided for @brewAddParamValidationNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required.'**
  String get brewAddParamValidationNameRequired;

  /// No description provided for @brewAddParamValidationStepPositive.
  ///
  /// In en, this message translates to:
  /// **'Step must be greater than 0.'**
  String get brewAddParamValidationStepPositive;

  /// No description provided for @brewAdjustDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Adjust {label}'**
  String brewAdjustDialogTitle(String label);

  /// No description provided for @brewAdjustedToNearestStep.
  ///
  /// In en, this message translates to:
  /// **'Adjusted to nearest step: {value}{unit}'**
  String brewAdjustedToNearestStep(String value, String unit);

  /// No description provided for @brewAdvancedBloomLabel.
  ///
  /// In en, this message translates to:
  /// **'Bloom'**
  String get brewAdvancedBloomLabel;

  /// No description provided for @brewAdvancedBloomSemantic.
  ///
  /// In en, this message translates to:
  /// **'Bloom time in seconds'**
  String get brewAdvancedBloomSemantic;

  /// No description provided for @brewAdvancedCoarsenessHint.
  ///
  /// In en, this message translates to:
  /// **'Select coarseness'**
  String get brewAdvancedCoarsenessHint;

  /// No description provided for @brewAdvancedCoarsenessLabel.
  ///
  /// In en, this message translates to:
  /// **'Coarseness'**
  String get brewAdvancedCoarsenessLabel;

  /// No description provided for @brewAdvancedEquipmentLabel.
  ///
  /// In en, this message translates to:
  /// **'Grinder / Equipment'**
  String get brewAdvancedEquipmentLabel;

  /// No description provided for @brewAdvancedGrindClicksLabel.
  ///
  /// In en, this message translates to:
  /// **'Grind Clicks'**
  String get brewAdvancedGrindClicksLabel;

  /// No description provided for @brewAdvancedGrindClicksSemantic.
  ///
  /// In en, this message translates to:
  /// **'Grind click value'**
  String get brewAdvancedGrindClicksSemantic;

  /// No description provided for @brewAdvancedGrindModeGrinder.
  ///
  /// In en, this message translates to:
  /// **'Grinder'**
  String get brewAdvancedGrindModeGrinder;

  /// No description provided for @brewAdvancedGrindModePro.
  ///
  /// In en, this message translates to:
  /// **'Pro (μm)'**
  String get brewAdvancedGrindModePro;

  /// No description provided for @brewAdvancedGrindModeSimple.
  ///
  /// In en, this message translates to:
  /// **'Simple'**
  String get brewAdvancedGrindModeSimple;

  /// No description provided for @brewAdvancedGrindSizeLabel.
  ///
  /// In en, this message translates to:
  /// **'Grind size (μm)'**
  String get brewAdvancedGrindSizeLabel;

  /// No description provided for @brewAdvancedPourMethodHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Spiral, Pulse, Centre'**
  String get brewAdvancedPourMethodHint;

  /// No description provided for @brewAdvancedPourMethodLabel.
  ///
  /// In en, this message translates to:
  /// **'Pour Method'**
  String get brewAdvancedPourMethodLabel;

  /// No description provided for @brewAdvancedSelectGrinderHint.
  ///
  /// In en, this message translates to:
  /// **'Select grinder...'**
  String get brewAdvancedSelectGrinderHint;

  /// No description provided for @brewAdvancedTempLabel.
  ///
  /// In en, this message translates to:
  /// **'Temp'**
  String get brewAdvancedTempLabel;

  /// No description provided for @brewAdvancedTempSemantic.
  ///
  /// In en, this message translates to:
  /// **'Water temperature'**
  String get brewAdvancedTempSemantic;

  /// No description provided for @brewBeanHint.
  ///
  /// In en, this message translates to:
  /// **'Search or add bean...'**
  String get brewBeanHint;

  /// No description provided for @brewBeanLabel.
  ///
  /// In en, this message translates to:
  /// **'Coffee Bean'**
  String get brewBeanLabel;

  /// No description provided for @brewCustomMethodDefaultName.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get brewCustomMethodDefaultName;

  /// No description provided for @brewCustomMethodDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get brewCustomMethodDelete;

  /// No description provided for @brewCustomMethodDisplay.
  ///
  /// In en, this message translates to:
  /// **'Custom method: {name}'**
  String brewCustomMethodDisplay(String name);

  /// No description provided for @brewCustomMethodNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. AeroPress'**
  String get brewCustomMethodNameHint;

  /// No description provided for @brewCustomMethodNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Method name'**
  String get brewCustomMethodNameLabel;

  /// No description provided for @brewCustomMethodRename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get brewCustomMethodRename;

  /// No description provided for @brewCustomMethodSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get brewCustomMethodSave;

  /// No description provided for @brewCustomMethodSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Custom Brew Method'**
  String get brewCustomMethodSheetTitle;

  /// No description provided for @brewCustomMethodWantAnother.
  ///
  /// In en, this message translates to:
  /// **'Want another method? Add one'**
  String get brewCustomMethodWantAnother;

  /// No description provided for @brewDetailAddRating.
  ///
  /// In en, this message translates to:
  /// **'Add Rating'**
  String get brewDetailAddRating;

  /// No description provided for @brewDetailDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete brew.'**
  String get brewDetailDeleteFailed;

  /// No description provided for @brewDetailDeleteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete brew'**
  String get brewDetailDeleteTooltip;

  /// No description provided for @brewDetailDeleted.
  ///
  /// In en, this message translates to:
  /// **'Brew deleted.'**
  String get brewDetailDeleted;

  /// No description provided for @brewDetailEditRating.
  ///
  /// In en, this message translates to:
  /// **'Edit Rating'**
  String get brewDetailEditRating;

  /// No description provided for @brewDetailGrindClickUnitDefault.
  ///
  /// In en, this message translates to:
  /// **'clicks'**
  String get brewDetailGrindClickUnitDefault;

  /// No description provided for @brewDetailGrindModeEquipment.
  ///
  /// In en, this message translates to:
  /// **'Equipment'**
  String get brewDetailGrindModeEquipment;

  /// No description provided for @brewDetailGrindModePro.
  ///
  /// In en, this message translates to:
  /// **'Pro'**
  String get brewDetailGrindModePro;

  /// No description provided for @brewDetailGrindModeSimple.
  ///
  /// In en, this message translates to:
  /// **'Simple'**
  String get brewDetailGrindModeSimple;

  /// No description provided for @brewDetailLabelAcidity.
  ///
  /// In en, this message translates to:
  /// **'Acidity'**
  String get brewDetailLabelAcidity;

  /// No description provided for @brewDetailLabelBean.
  ///
  /// In en, this message translates to:
  /// **'Bean'**
  String get brewDetailLabelBean;

  /// No description provided for @brewDetailLabelBitterness.
  ///
  /// In en, this message translates to:
  /// **'Bitterness'**
  String get brewDetailLabelBitterness;

  /// No description provided for @brewDetailLabelBloomTime.
  ///
  /// In en, this message translates to:
  /// **'Bloom Time'**
  String get brewDetailLabelBloomTime;

  /// No description provided for @brewDetailLabelBody.
  ///
  /// In en, this message translates to:
  /// **'Body'**
  String get brewDetailLabelBody;

  /// No description provided for @brewDetailLabelBrewedAt.
  ///
  /// In en, this message translates to:
  /// **'Brewed At'**
  String get brewDetailLabelBrewedAt;

  /// No description provided for @brewDetailLabelCoffee.
  ///
  /// In en, this message translates to:
  /// **'Coffee'**
  String get brewDetailLabelCoffee;

  /// No description provided for @brewDetailLabelCreatedAt.
  ///
  /// In en, this message translates to:
  /// **'Created At'**
  String get brewDetailLabelCreatedAt;

  /// No description provided for @brewDetailLabelDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get brewDetailLabelDuration;

  /// No description provided for @brewDetailLabelFlavorNotes.
  ///
  /// In en, this message translates to:
  /// **'Flavor Notes'**
  String get brewDetailLabelFlavorNotes;

  /// No description provided for @brewDetailLabelGrindClick.
  ///
  /// In en, this message translates to:
  /// **'Click'**
  String get brewDetailLabelGrindClick;

  /// No description provided for @brewDetailLabelGrindEquipment.
  ///
  /// In en, this message translates to:
  /// **'Equipment'**
  String get brewDetailLabelGrindEquipment;

  /// No description provided for @brewDetailLabelGrindLabel.
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get brewDetailLabelGrindLabel;

  /// No description provided for @brewDetailLabelGrindMicrons.
  ///
  /// In en, this message translates to:
  /// **'Microns'**
  String get brewDetailLabelGrindMicrons;

  /// No description provided for @brewDetailLabelGrindMode.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get brewDetailLabelGrindMode;

  /// No description provided for @brewDetailLabelNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get brewDetailLabelNotes;

  /// No description provided for @brewDetailLabelOrigin.
  ///
  /// In en, this message translates to:
  /// **'Origin'**
  String get brewDetailLabelOrigin;

  /// No description provided for @brewDetailLabelPourMethod.
  ///
  /// In en, this message translates to:
  /// **'Pour Method'**
  String get brewDetailLabelPourMethod;

  /// No description provided for @brewDetailLabelQuick.
  ///
  /// In en, this message translates to:
  /// **'Quick'**
  String get brewDetailLabelQuick;

  /// No description provided for @brewDetailLabelRatio.
  ///
  /// In en, this message translates to:
  /// **'Ratio'**
  String get brewDetailLabelRatio;

  /// No description provided for @brewDetailLabelRoastLevel.
  ///
  /// In en, this message translates to:
  /// **'Roast Level'**
  String get brewDetailLabelRoastLevel;

  /// No description provided for @brewDetailLabelRoaster.
  ///
  /// In en, this message translates to:
  /// **'Roaster'**
  String get brewDetailLabelRoaster;

  /// No description provided for @brewDetailLabelRoomTemp.
  ///
  /// In en, this message translates to:
  /// **'Room Temp'**
  String get brewDetailLabelRoomTemp;

  /// No description provided for @brewDetailLabelSweetness.
  ///
  /// In en, this message translates to:
  /// **'Sweetness'**
  String get brewDetailLabelSweetness;

  /// No description provided for @brewDetailLabelUpdatedAt.
  ///
  /// In en, this message translates to:
  /// **'Updated At'**
  String get brewDetailLabelUpdatedAt;

  /// No description provided for @brewDetailLabelWater.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get brewDetailLabelWater;

  /// No description provided for @brewDetailLabelWaterTemp.
  ///
  /// In en, this message translates to:
  /// **'Water Temp'**
  String get brewDetailLabelWaterTemp;

  /// No description provided for @brewDetailLabelWaterType.
  ///
  /// In en, this message translates to:
  /// **'Water Type'**
  String get brewDetailLabelWaterType;

  /// No description provided for @brewDetailNotFound.
  ///
  /// In en, this message translates to:
  /// **'Brew record not found.'**
  String get brewDetailNotFound;

  /// No description provided for @brewDetailQuickScore.
  ///
  /// In en, this message translates to:
  /// **'{score}/5'**
  String brewDetailQuickScore(int score);

  /// No description provided for @brewDetailRatingEmpty.
  ///
  /// In en, this message translates to:
  /// **'No rating recorded yet.'**
  String get brewDetailRatingEmpty;

  /// No description provided for @brewDetailRatingUpdated.
  ///
  /// In en, this message translates to:
  /// **'Rating updated.'**
  String get brewDetailRatingUpdated;

  /// No description provided for @brewDetailSectionBasic.
  ///
  /// In en, this message translates to:
  /// **'Basic'**
  String get brewDetailSectionBasic;

  /// No description provided for @brewDetailSectionBrewParams.
  ///
  /// In en, this message translates to:
  /// **'Brew Params'**
  String get brewDetailSectionBrewParams;

  /// No description provided for @brewDetailSectionEnvironment.
  ///
  /// In en, this message translates to:
  /// **'Environment'**
  String get brewDetailSectionEnvironment;

  /// No description provided for @brewDetailSectionGrind.
  ///
  /// In en, this message translates to:
  /// **'Grind'**
  String get brewDetailSectionGrind;

  /// No description provided for @brewDetailSectionMeta.
  ///
  /// In en, this message translates to:
  /// **'Meta'**
  String get brewDetailSectionMeta;

  /// No description provided for @brewDetailSectionRating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get brewDetailSectionRating;

  /// No description provided for @brewDetailSectionRecordedParams.
  ///
  /// In en, this message translates to:
  /// **'Recorded Params'**
  String get brewDetailSectionRecordedParams;

  /// No description provided for @brewDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Brew Detail'**
  String get brewDetailTitle;

  /// No description provided for @brewDetailUnrated.
  ///
  /// In en, this message translates to:
  /// **'Unrated'**
  String get brewDetailUnrated;

  /// No description provided for @brewEnableMethodInPreferences.
  ///
  /// In en, this message translates to:
  /// **'Enable a brew method in preferences to start logging.'**
  String get brewEnableMethodInPreferences;

  /// No description provided for @brewEnableMethodToConfigureParams.
  ///
  /// In en, this message translates to:
  /// **'Enable a brew method to configure parameters.'**
  String get brewEnableMethodToConfigureParams;

  /// No description provided for @brewErrorInvalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number.'**
  String get brewErrorInvalidNumber;

  /// No description provided for @brewErrorValueOutOfRange.
  ///
  /// In en, this message translates to:
  /// **'Value must be between {min} and {max}.'**
  String brewErrorValueOutOfRange(double min, double max);

  /// No description provided for @brewErrorValueRequired.
  ///
  /// In en, this message translates to:
  /// **'Value is required.'**
  String get brewErrorValueRequired;

  /// No description provided for @brewGrindModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Grind Mode'**
  String get brewGrindModeLabel;

  /// No description provided for @brewGrindSimpleCoarse.
  ///
  /// In en, this message translates to:
  /// **'Coarse'**
  String get brewGrindSimpleCoarse;

  /// No description provided for @brewGrindSimpleExtraCoarse.
  ///
  /// In en, this message translates to:
  /// **'Extra Coarse'**
  String get brewGrindSimpleExtraCoarse;

  /// No description provided for @brewGrindSimpleExtraFine.
  ///
  /// In en, this message translates to:
  /// **'Extra Fine'**
  String get brewGrindSimpleExtraFine;

  /// No description provided for @brewGrindSimpleFine.
  ///
  /// In en, this message translates to:
  /// **'Fine'**
  String get brewGrindSimpleFine;

  /// No description provided for @brewGrindSimpleMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get brewGrindSimpleMedium;

  /// No description provided for @brewGrindSimpleMediumCoarse.
  ///
  /// In en, this message translates to:
  /// **'Medium Coarse'**
  String get brewGrindSimpleMediumCoarse;

  /// No description provided for @brewGrindSimpleMediumFine.
  ///
  /// In en, this message translates to:
  /// **'Medium Fine'**
  String get brewGrindSimpleMediumFine;

  /// No description provided for @brewLabelCoffee.
  ///
  /// In en, this message translates to:
  /// **'Coffee'**
  String get brewLabelCoffee;

  /// No description provided for @brewLabelDose.
  ///
  /// In en, this message translates to:
  /// **'Dose'**
  String get brewLabelDose;

  /// No description provided for @brewLabelWater.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get brewLabelWater;

  /// No description provided for @brewLabelYield.
  ///
  /// In en, this message translates to:
  /// **'Yield'**
  String get brewLabelYield;

  /// No description provided for @brewMethodNameEspresso.
  ///
  /// In en, this message translates to:
  /// **'Espresso'**
  String get brewMethodNameEspresso;

  /// No description provided for @brewMethodNamePourOver.
  ///
  /// In en, this message translates to:
  /// **'Pour Over'**
  String get brewMethodNamePourOver;

  /// No description provided for @brewMethodSelectorLabel.
  ///
  /// In en, this message translates to:
  /// **'Brew Method'**
  String get brewMethodSelectorLabel;

  /// No description provided for @brewMethodsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Brew methods unavailable.'**
  String get brewMethodsUnavailable;

  /// No description provided for @brewNoParamsConfiguredYet.
  ///
  /// In en, this message translates to:
  /// **'No parameters configured for this brew method yet.'**
  String get brewNoParamsConfiguredYet;

  /// No description provided for @brewParamLabelAgitation.
  ///
  /// In en, this message translates to:
  /// **'Agitation'**
  String get brewParamLabelAgitation;

  /// No description provided for @brewParamLabelBloomTime.
  ///
  /// In en, this message translates to:
  /// **'Bloom Time'**
  String get brewParamLabelBloomTime;

  /// No description provided for @brewParamLabelBloomWater.
  ///
  /// In en, this message translates to:
  /// **'Bloom Water'**
  String get brewParamLabelBloomWater;

  /// No description provided for @brewParamLabelBrewRatio.
  ///
  /// In en, this message translates to:
  /// **'Brew Ratio'**
  String get brewParamLabelBrewRatio;

  /// No description provided for @brewParamLabelBrewTime.
  ///
  /// In en, this message translates to:
  /// **'Brew Time'**
  String get brewParamLabelBrewTime;

  /// No description provided for @brewParamLabelCoffeeDose.
  ///
  /// In en, this message translates to:
  /// **'Dose'**
  String get brewParamLabelCoffeeDose;

  /// No description provided for @brewParamLabelDistributionTamping.
  ///
  /// In en, this message translates to:
  /// **'Distribution/Tamping'**
  String get brewParamLabelDistributionTamping;

  /// No description provided for @brewParamLabelExtractionTime.
  ///
  /// In en, this message translates to:
  /// **'Extraction Time'**
  String get brewParamLabelExtractionTime;

  /// No description provided for @brewParamLabelFilterDripper.
  ///
  /// In en, this message translates to:
  /// **'Filter/Dripper'**
  String get brewParamLabelFilterDripper;

  /// No description provided for @brewParamLabelGrindSize.
  ///
  /// In en, this message translates to:
  /// **'Grind Size'**
  String get brewParamLabelGrindSize;

  /// No description provided for @brewParamLabelPourMethod.
  ///
  /// In en, this message translates to:
  /// **'Pour Method'**
  String get brewParamLabelPourMethod;

  /// No description provided for @brewParamLabelPreInfusion.
  ///
  /// In en, this message translates to:
  /// **'Pre-infusion Time'**
  String get brewParamLabelPreInfusion;

  /// No description provided for @brewParamLabelPressure.
  ///
  /// In en, this message translates to:
  /// **'Pressure'**
  String get brewParamLabelPressure;

  /// No description provided for @brewParamLabelWaterTemp.
  ///
  /// In en, this message translates to:
  /// **'Water Temp'**
  String get brewParamLabelWaterTemp;

  /// No description provided for @brewParamLabelWaterWeight.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get brewParamLabelWaterWeight;

  /// No description provided for @brewParamLabelYield.
  ///
  /// In en, this message translates to:
  /// **'Yield'**
  String get brewParamLabelYield;

  /// No description provided for @brewParamTypeNumber.
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get brewParamTypeNumber;

  /// No description provided for @brewParamTypeText.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get brewParamTypeText;

  /// No description provided for @brewPreferencesSectionMethodsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose which methods appear in the Brew page.'**
  String get brewPreferencesSectionMethodsSubtitle;

  /// No description provided for @brewPreferencesSectionMethodsTitle.
  ///
  /// In en, this message translates to:
  /// **'Brew Methods'**
  String get brewPreferencesSectionMethodsTitle;

  /// No description provided for @brewPreferencesSectionParamsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Hide defaults or add custom parameters for each brew method.'**
  String get brewPreferencesSectionParamsSubtitle;

  /// No description provided for @brewPreferencesSectionParamsTitle.
  ///
  /// In en, this message translates to:
  /// **'Parameter List'**
  String get brewPreferencesSectionParamsTitle;

  /// No description provided for @brewPreferencesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set your default brew methods and parameter list.'**
  String get brewPreferencesSubtitle;

  /// No description provided for @brewPreferencesTitle.
  ///
  /// In en, this message translates to:
  /// **'Record Preferences'**
  String get brewPreferencesTitle;

  /// No description provided for @brewRatingSaved.
  ///
  /// In en, this message translates to:
  /// **'Rating saved!'**
  String get brewRatingSaved;

  /// No description provided for @brewRatioBadge.
  ///
  /// In en, this message translates to:
  /// **'1 : {ratio}'**
  String brewRatioBadge(String ratio);

  /// No description provided for @brewRenameCustomMethodSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename Custom Method'**
  String get brewRenameCustomMethodSheetTitle;

  /// No description provided for @brewSaveActionDisabled.
  ///
  /// In en, this message translates to:
  /// **'Start timer to save'**
  String get brewSaveActionDisabled;

  /// No description provided for @brewSaveActionReady.
  ///
  /// In en, this message translates to:
  /// **'Save Brew'**
  String get brewSaveActionReady;

  /// No description provided for @brewSaveRecordSemantics.
  ///
  /// In en, this message translates to:
  /// **'Save brew record'**
  String get brewSaveRecordSemantics;

  /// No description provided for @brewSaveSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Brew saved. You can rate now or later in History detail.'**
  String get brewSaveSuccessMessage;

  /// No description provided for @brewSaveSuccessRateNow.
  ///
  /// In en, this message translates to:
  /// **'Rate now'**
  String get brewSaveSuccessRateNow;

  /// No description provided for @brewSemanticValue.
  ///
  /// In en, this message translates to:
  /// **'{label} value'**
  String brewSemanticValue(String label);

  /// No description provided for @brewSemanticWeight.
  ///
  /// In en, this message translates to:
  /// **'{label} weight'**
  String brewSemanticWeight(String label);

  /// No description provided for @brewTemplateApplied.
  ///
  /// In en, this message translates to:
  /// **'Template applied: {beanName}'**
  String brewTemplateApplied(String beanName);

  /// No description provided for @brewTemplateLoadedFromHistory.
  ///
  /// In en, this message translates to:
  /// **'Template loaded from history'**
  String get brewTemplateLoadedFromHistory;

  /// No description provided for @brewTemplateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{coffeeGrams}g -> {waterGrams}g | {duration}'**
  String brewTemplateSubtitle(
    String coffeeGrams,
    String waterGrams,
    String duration,
  );

  /// No description provided for @brewTemplatesUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Templates unavailable right now.'**
  String get brewTemplatesUnavailable;

  /// No description provided for @brewTextFieldHintEnterText.
  ///
  /// In en, this message translates to:
  /// **'Enter text'**
  String get brewTextFieldHintEnterText;

  /// No description provided for @brewTimerAdjustStepTooltip.
  ///
  /// In en, this message translates to:
  /// **'Adjust target by {seconds}s'**
  String brewTimerAdjustStepTooltip(int seconds);

  /// No description provided for @brewTimerBrew.
  ///
  /// In en, this message translates to:
  /// **'Brew'**
  String get brewTimerBrew;

  /// No description provided for @brewTimerDecreaseTargetSemantics.
  ///
  /// In en, this message translates to:
  /// **'Decrease target'**
  String get brewTimerDecreaseTargetSemantics;

  /// No description provided for @brewTimerDecreaseTargetTooltip.
  ///
  /// In en, this message translates to:
  /// **'Decrease target by {seconds}s'**
  String brewTimerDecreaseTargetTooltip(int seconds);

  /// No description provided for @brewTimerEnableTargetToUseCountdown.
  ///
  /// In en, this message translates to:
  /// **'Enable target to use countdown'**
  String get brewTimerEnableTargetToUseCountdown;

  /// No description provided for @brewTimerIncreaseTargetSemantics.
  ///
  /// In en, this message translates to:
  /// **'Increase target'**
  String get brewTimerIncreaseTargetSemantics;

  /// No description provided for @brewTimerIncreaseTargetTooltip.
  ///
  /// In en, this message translates to:
  /// **'Increase target by {seconds}s'**
  String brewTimerIncreaseTargetTooltip(int seconds);

  /// No description provided for @brewTimerPause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get brewTimerPause;

  /// No description provided for @brewTimerReset.
  ///
  /// In en, this message translates to:
  /// **'Reset timer'**
  String get brewTimerReset;

  /// No description provided for @brewTimerResume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get brewTimerResume;

  /// No description provided for @brewTimerSwitchToCountUp.
  ///
  /// In en, this message translates to:
  /// **'Switch to count-up'**
  String get brewTimerSwitchToCountUp;

  /// No description provided for @brewTimerSwitchToCountdown.
  ///
  /// In en, this message translates to:
  /// **'Switch to countdown'**
  String get brewTimerSwitchToCountdown;

  /// No description provided for @brewTimerTargetOff.
  ///
  /// In en, this message translates to:
  /// **'Target Off'**
  String get brewTimerTargetOff;

  /// No description provided for @brewTimerTargetOn.
  ///
  /// In en, this message translates to:
  /// **'Target On'**
  String get brewTimerTargetOn;

  /// No description provided for @brewTimerTargetValue.
  ///
  /// In en, this message translates to:
  /// **'Target {time}'**
  String brewTimerTargetValue(String time);

  /// No description provided for @brewTimerToggleCountdownSemantics.
  ///
  /// In en, this message translates to:
  /// **'Toggle countdown mode'**
  String get brewTimerToggleCountdownSemantics;

  /// No description provided for @brewTimerUseTarget.
  ///
  /// In en, this message translates to:
  /// **'Use Target'**
  String get brewTimerUseTarget;

  /// No description provided for @brewTooltipDeleteParameter.
  ///
  /// In en, this message translates to:
  /// **'Delete parameter'**
  String get brewTooltipDeleteParameter;

  /// No description provided for @brewUntitledBrew.
  ///
  /// In en, this message translates to:
  /// **'Untitled Brew'**
  String get brewUntitledBrew;

  /// No description provided for @brewValueLabel.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get brewValueLabel;

  /// No description provided for @brewValueLabelWithUnit.
  ///
  /// In en, this message translates to:
  /// **'Value ({unit})'**
  String brewValueLabelWithUnit(String unit);

  /// No description provided for @chipInputAddMore.
  ///
  /// In en, this message translates to:
  /// **'Add more…'**
  String get chipInputAddMore;

  /// No description provided for @chipInputHint.
  ///
  /// In en, this message translates to:
  /// **'Type and press Enter…'**
  String get chipInputHint;

  /// No description provided for @commonName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get commonName;

  /// No description provided for @dateDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{# day ago} other{# days ago}}'**
  String dateDaysAgo(int count);

  /// No description provided for @dateJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get dateJustNow;

  /// No description provided for @dateMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{# minute ago} other{# minutes ago}}'**
  String dateMinutesAgo(int count);

  /// No description provided for @dateThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get dateThisWeek;

  /// No description provided for @dateToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dateToday;

  /// No description provided for @dateTodayAt.
  ///
  /// In en, this message translates to:
  /// **'Today {time}'**
  String dateTodayAt(String time);

  /// No description provided for @dateYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get dateYesterday;

  /// No description provided for @dateYesterdayAt.
  ///
  /// In en, this message translates to:
  /// **'Yesterday {time}'**
  String dateYesterdayAt(String time);

  /// No description provided for @deleteBrewDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Delete this brew record? This action cannot be undone.'**
  String get deleteBrewDialogBody;

  /// No description provided for @deleteBrewDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Brew'**
  String get deleteBrewDialogTitle;

  /// No description provided for @flavorNoteBerry.
  ///
  /// In en, this message translates to:
  /// **'Berry'**
  String get flavorNoteBerry;

  /// No description provided for @flavorNoteCaramel.
  ///
  /// In en, this message translates to:
  /// **'Caramel'**
  String get flavorNoteCaramel;

  /// No description provided for @flavorNoteChocolate.
  ///
  /// In en, this message translates to:
  /// **'Chocolate'**
  String get flavorNoteChocolate;

  /// No description provided for @flavorNoteCitrus.
  ///
  /// In en, this message translates to:
  /// **'Citrus'**
  String get flavorNoteCitrus;

  /// No description provided for @flavorNoteClean.
  ///
  /// In en, this message translates to:
  /// **'Clean'**
  String get flavorNoteClean;

  /// No description provided for @flavorNoteFloral.
  ///
  /// In en, this message translates to:
  /// **'Floral'**
  String get flavorNoteFloral;

  /// No description provided for @flavorNoteHerbal.
  ///
  /// In en, this message translates to:
  /// **'Herbal'**
  String get flavorNoteHerbal;

  /// No description provided for @flavorNoteNutty.
  ///
  /// In en, this message translates to:
  /// **'Nutty'**
  String get flavorNoteNutty;

  /// No description provided for @flavorNoteSpice.
  ///
  /// In en, this message translates to:
  /// **'Spice'**
  String get flavorNoteSpice;

  /// No description provided for @flavorNoteStoneFruit.
  ///
  /// In en, this message translates to:
  /// **'Stone Fruit'**
  String get flavorNoteStoneFruit;

  /// No description provided for @flavorNoteTea.
  ///
  /// In en, this message translates to:
  /// **'Tea'**
  String get flavorNoteTea;

  /// No description provided for @flavorNoteTropical.
  ///
  /// In en, this message translates to:
  /// **'Tropical'**
  String get flavorNoteTropical;

  /// No description provided for @historyEmptyFiltered.
  ///
  /// In en, this message translates to:
  /// **'No brew records match the current filter.'**
  String get historyEmptyFiltered;

  /// No description provided for @historyErrorFilter.
  ///
  /// In en, this message translates to:
  /// **'Failed to filter history.'**
  String get historyErrorFilter;

  /// No description provided for @historyErrorLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load history.'**
  String get historyErrorLoad;

  /// No description provided for @historyErrorReset.
  ///
  /// In en, this message translates to:
  /// **'Failed to reset history filter.'**
  String get historyErrorReset;

  /// No description provided for @historyFilterAnyDate.
  ///
  /// In en, this message translates to:
  /// **'Any date'**
  String get historyFilterAnyDate;

  /// No description provided for @historyFilterBeanAddAction.
  ///
  /// In en, this message translates to:
  /// **'Use custom text'**
  String get historyFilterBeanAddAction;

  /// No description provided for @historyFilterBeanDialogConfirm.
  ///
  /// In en, this message translates to:
  /// **'Use text'**
  String get historyFilterBeanDialogConfirm;

  /// No description provided for @historyFilterBeanDialogHint.
  ///
  /// In en, this message translates to:
  /// **'Bean name'**
  String get historyFilterBeanDialogHint;

  /// No description provided for @historyFilterBeanDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter by Bean'**
  String get historyFilterBeanDialogTitle;

  /// No description provided for @historyFilterBeanHint.
  ///
  /// In en, this message translates to:
  /// **'Bean'**
  String get historyFilterBeanHint;

  /// No description provided for @historyFilterClearTooltip.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get historyFilterClearTooltip;

  /// No description provided for @historyFilterScoreAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get historyFilterScoreAll;

  /// No description provided for @historyFilterScoreHint.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get historyFilterScoreHint;

  /// No description provided for @historyRoasterPrefix.
  ///
  /// In en, this message translates to:
  /// **'Roaster: {roaster}'**
  String historyRoasterPrefix(String roaster);

  /// No description provided for @historySecondsSuffix.
  ///
  /// In en, this message translates to:
  /// **'{seconds}s'**
  String historySecondsSuffix(int seconds);

  /// No description provided for @historyStatsAvg.
  ///
  /// In en, this message translates to:
  /// **'Avg'**
  String get historyStatsAvg;

  /// No description provided for @historyStatsBrews.
  ///
  /// In en, this message translates to:
  /// **'Brews'**
  String get historyStatsBrews;

  /// No description provided for @historyStatsRated.
  ///
  /// In en, this message translates to:
  /// **'Rated'**
  String get historyStatsRated;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'Brew History'**
  String get historyTitle;

  /// No description provided for @historyTopBrew.
  ///
  /// In en, this message translates to:
  /// **'Top Brew'**
  String get historyTopBrew;

  /// No description provided for @inventoryAboutAuthor.
  ///
  /// In en, this message translates to:
  /// **'Author: {name}'**
  String inventoryAboutAuthor(String name);

  /// No description provided for @inventoryAboutOpenGithub.
  ///
  /// In en, this message translates to:
  /// **'Open GitHub Repository'**
  String get inventoryAboutOpenGithub;

  /// No description provided for @inventoryAboutOpenGithubFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to open GitHub link.'**
  String get inventoryAboutOpenGithubFailed;

  /// No description provided for @inventoryAboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About OneBrew'**
  String get inventoryAboutTitle;

  /// No description provided for @inventoryAboutVersion.
  ///
  /// In en, this message translates to:
  /// **'Version: {version}'**
  String inventoryAboutVersion(String version);

  /// No description provided for @inventoryAboutVersionLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get inventoryAboutVersionLoading;

  /// No description provided for @inventoryAboutVersionUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get inventoryAboutVersionUnavailable;

  /// No description provided for @inventoryActionCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get inventoryActionCreate;

  /// No description provided for @inventoryActionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get inventoryActionDelete;

  /// No description provided for @inventoryActionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get inventoryActionSave;

  /// No description provided for @inventoryBeanCreated.
  ///
  /// In en, this message translates to:
  /// **'Bean created.'**
  String get inventoryBeanCreated;

  /// No description provided for @inventoryBeanFormAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Bean'**
  String get inventoryBeanFormAddTitle;

  /// No description provided for @inventoryBeanFormEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Bean'**
  String get inventoryBeanFormEditTitle;

  /// No description provided for @inventoryBeanFormLabelName.
  ///
  /// In en, this message translates to:
  /// **'Bean name'**
  String get inventoryBeanFormLabelName;

  /// No description provided for @inventoryBeanFormLabelOrigin.
  ///
  /// In en, this message translates to:
  /// **'Origin'**
  String get inventoryBeanFormLabelOrigin;

  /// No description provided for @inventoryBeanFormLabelRoastLevel.
  ///
  /// In en, this message translates to:
  /// **'Roast level'**
  String get inventoryBeanFormLabelRoastLevel;

  /// No description provided for @inventoryBeanFormLabelRoaster.
  ///
  /// In en, this message translates to:
  /// **'Roaster'**
  String get inventoryBeanFormLabelRoaster;

  /// No description provided for @inventoryBeanFormNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter bean name.'**
  String get inventoryBeanFormNameRequired;

  /// No description provided for @inventoryBeanUpdated.
  ///
  /// In en, this message translates to:
  /// **'Bean updated successfully.'**
  String get inventoryBeanUpdated;

  /// No description provided for @inventoryConflictGrinderNameExists.
  ///
  /// In en, this message translates to:
  /// **'A grinder with the same name already exists.'**
  String get inventoryConflictGrinderNameExists;

  /// No description provided for @inventoryDeleteBeanTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Bean'**
  String get inventoryDeleteBeanTitle;

  /// No description provided for @inventoryDeleteBeanTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete bean'**
  String get inventoryDeleteBeanTooltip;

  /// No description provided for @inventoryDeleteGrinderTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Grinder'**
  String get inventoryDeleteGrinderTitle;

  /// No description provided for @inventoryDeleteGrinderTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete grinder'**
  String get inventoryDeleteGrinderTooltip;

  /// No description provided for @inventoryDeletePrompt.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"?'**
  String inventoryDeletePrompt(String name);

  /// No description provided for @inventoryEditBeanTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit bean'**
  String get inventoryEditBeanTooltip;

  /// No description provided for @inventoryEditGrinderTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit grinder'**
  String get inventoryEditGrinderTooltip;

  /// No description provided for @inventoryEmptyBeans.
  ///
  /// In en, this message translates to:
  /// **'No beans found.'**
  String get inventoryEmptyBeans;

  /// No description provided for @inventoryEmptyGrinders.
  ///
  /// In en, this message translates to:
  /// **'No grinders found.'**
  String get inventoryEmptyGrinders;

  /// No description provided for @inventoryErrorWithDetails.
  ///
  /// In en, this message translates to:
  /// **'Error: {details}'**
  String inventoryErrorWithDetails(String details);

  /// No description provided for @inventoryFabTooltipAddBean.
  ///
  /// In en, this message translates to:
  /// **'Add bean'**
  String get inventoryFabTooltipAddBean;

  /// No description provided for @inventoryFabTooltipAddGrinder.
  ///
  /// In en, this message translates to:
  /// **'Add grinder'**
  String get inventoryFabTooltipAddGrinder;

  /// No description provided for @inventoryFailedToDeleteBean.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete bean: {error}'**
  String inventoryFailedToDeleteBean(String error);

  /// No description provided for @inventoryFailedToDeleteGrinder.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete grinder: {error}'**
  String inventoryFailedToDeleteGrinder(String error);

  /// No description provided for @inventoryFailedToSaveBean.
  ///
  /// In en, this message translates to:
  /// **'Failed to save bean: {error}'**
  String inventoryFailedToSaveBean(String error);

  /// No description provided for @inventoryFailedToSaveGrinder.
  ///
  /// In en, this message translates to:
  /// **'Failed to save grinder: {error}'**
  String inventoryFailedToSaveGrinder(String error);

  /// No description provided for @inventoryFailedToSaveTag.
  ///
  /// In en, this message translates to:
  /// **'Failed to save \"{tag}\": {error}'**
  String inventoryFailedToSaveTag(String tag, String error);

  /// No description provided for @inventoryGrinderCreated.
  ///
  /// In en, this message translates to:
  /// **'Grinder created successfully.'**
  String get inventoryGrinderCreated;

  /// No description provided for @inventoryGrinderFormAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Grinder'**
  String get inventoryGrinderFormAddTitle;

  /// No description provided for @inventoryGrinderFormEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Grinder'**
  String get inventoryGrinderFormEditTitle;

  /// No description provided for @inventoryGrinderFormLabelMaxClick.
  ///
  /// In en, this message translates to:
  /// **'Max click'**
  String get inventoryGrinderFormLabelMaxClick;

  /// No description provided for @inventoryGrinderFormLabelMinClick.
  ///
  /// In en, this message translates to:
  /// **'Min click'**
  String get inventoryGrinderFormLabelMinClick;

  /// No description provided for @inventoryGrinderFormLabelName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get inventoryGrinderFormLabelName;

  /// No description provided for @inventoryGrinderFormLabelStep.
  ///
  /// In en, this message translates to:
  /// **'Step'**
  String get inventoryGrinderFormLabelStep;

  /// No description provided for @inventoryGrinderFormLabelUnit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get inventoryGrinderFormLabelUnit;

  /// No description provided for @inventoryGrinderFormNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter grinder name.'**
  String get inventoryGrinderFormNameRequired;

  /// No description provided for @inventoryGrinderMetaStep.
  ///
  /// In en, this message translates to:
  /// **'step {step}'**
  String inventoryGrinderMetaStep(num step);

  /// No description provided for @inventoryGrinderUpdated.
  ///
  /// In en, this message translates to:
  /// **'Grinder updated successfully.'**
  String get inventoryGrinderUpdated;

  /// No description provided for @inventoryLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get inventoryLanguageTitle;

  /// No description provided for @inventoryMetaAdded.
  ///
  /// In en, this message translates to:
  /// **'Added {date}'**
  String inventoryMetaAdded(String date);

  /// No description provided for @inventoryMetaUseCount.
  ///
  /// In en, this message translates to:
  /// **'Use {count}'**
  String inventoryMetaUseCount(int count);

  /// No description provided for @inventoryQuickGrinderSetupDescription.
  ///
  /// In en, this message translates to:
  /// **'Configure \"{tag}\". Leave blank to use defaults.'**
  String inventoryQuickGrinderSetupDescription(String tag);

  /// No description provided for @inventoryQuickGrinderSetupLabelMax.
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get inventoryQuickGrinderSetupLabelMax;

  /// No description provided for @inventoryQuickGrinderSetupLabelMin.
  ///
  /// In en, this message translates to:
  /// **'Min'**
  String get inventoryQuickGrinderSetupLabelMin;

  /// No description provided for @inventoryQuickGrinderSetupLabelStep.
  ///
  /// In en, this message translates to:
  /// **'Step'**
  String get inventoryQuickGrinderSetupLabelStep;

  /// No description provided for @inventoryQuickGrinderSetupLabelUnit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get inventoryQuickGrinderSetupLabelUnit;

  /// No description provided for @inventoryQuickGrinderSetupSaveGrinder.
  ///
  /// In en, this message translates to:
  /// **'Save Grinder'**
  String get inventoryQuickGrinderSetupSaveGrinder;

  /// No description provided for @inventoryQuickGrinderSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick Grinder Setup'**
  String get inventoryQuickGrinderSetupTitle;

  /// No description provided for @inventoryQuickGrinderSetupUseDefaults.
  ///
  /// In en, this message translates to:
  /// **'Use Defaults'**
  String get inventoryQuickGrinderSetupUseDefaults;

  /// No description provided for @inventoryQuickGrinderSetupValidationError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid range and step.'**
  String get inventoryQuickGrinderSetupValidationError;

  /// No description provided for @inventorySearchBeansHint.
  ///
  /// In en, this message translates to:
  /// **'Search beans'**
  String get inventorySearchBeansHint;

  /// No description provided for @inventorySearchGrindersHint.
  ///
  /// In en, this message translates to:
  /// **'Search grinders'**
  String get inventorySearchGrindersHint;

  /// No description provided for @inventorySmartTagAddBean.
  ///
  /// In en, this message translates to:
  /// **'Add bean'**
  String get inventorySmartTagAddBean;

  /// No description provided for @inventorySmartTagAddGrinder.
  ///
  /// In en, this message translates to:
  /// **'Add grinder'**
  String get inventorySmartTagAddGrinder;

  /// No description provided for @inventorySmartTagDialogAddBean.
  ///
  /// In en, this message translates to:
  /// **'Add Coffee Bean'**
  String get inventorySmartTagDialogAddBean;

  /// No description provided for @inventorySmartTagDialogAddGrinder.
  ///
  /// In en, this message translates to:
  /// **'Add Grinder'**
  String get inventorySmartTagDialogAddGrinder;

  /// No description provided for @inventorySmartTagDialogHintBeanName.
  ///
  /// In en, this message translates to:
  /// **'Bean name'**
  String get inventorySmartTagDialogHintBeanName;

  /// No description provided for @inventorySmartTagDialogHintGrinderName.
  ///
  /// In en, this message translates to:
  /// **'Grinder name'**
  String get inventorySmartTagDialogHintGrinderName;

  /// No description provided for @inventorySmartTagEmptyBeansYet.
  ///
  /// In en, this message translates to:
  /// **'No beans yet'**
  String get inventorySmartTagEmptyBeansYet;

  /// No description provided for @inventorySmartTagEmptyGrindersYet.
  ///
  /// In en, this message translates to:
  /// **'No grinders yet'**
  String get inventorySmartTagEmptyGrindersYet;

  /// No description provided for @inventorySmartTagHint.
  ///
  /// In en, this message translates to:
  /// **'Type to add...'**
  String get inventorySmartTagHint;

  /// No description provided for @inventoryTabBeans.
  ///
  /// In en, this message translates to:
  /// **'Beans'**
  String get inventoryTabBeans;

  /// No description provided for @inventoryTabGrinders.
  ///
  /// In en, this message translates to:
  /// **'Grinders'**
  String get inventoryTabGrinders;

  /// No description provided for @inventoryTemplatePickerEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Save one brew first, then reuse it here in one tap.'**
  String get inventoryTemplatePickerEmptyHint;

  /// No description provided for @inventoryTemplatePickerFooter.
  ///
  /// In en, this message translates to:
  /// **'Showing latest 3 brews only. Tap a chip to reuse.'**
  String get inventoryTemplatePickerFooter;

  /// No description provided for @inventoryTemplatePickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Brew Again (Templates)'**
  String get inventoryTemplatePickerTitle;

  /// No description provided for @inventoryTooltipAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get inventoryTooltipAbout;

  /// No description provided for @inventoryTooltipDebugRerunOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Debug: Re-run onboarding'**
  String get inventoryTooltipDebugRerunOnboarding;

  /// No description provided for @inventoryTooltipLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get inventoryTooltipLanguage;

  /// No description provided for @inventoryTooltipRecordPreferences.
  ///
  /// In en, this message translates to:
  /// **'Record Preferences'**
  String get inventoryTooltipRecordPreferences;

  /// No description provided for @inventoryValidationInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid'**
  String get inventoryValidationInvalid;

  /// No description provided for @inventoryValidationMustBeGreaterThanMin.
  ///
  /// In en, this message translates to:
  /// **'Must be > min'**
  String get inventoryValidationMustBeGreaterThanMin;

  /// No description provided for @inventoryValidationMustBeGreaterThanZero.
  ///
  /// In en, this message translates to:
  /// **'Must be > 0'**
  String get inventoryValidationMustBeGreaterThanZero;

  /// No description provided for @inventoryValidationRangeTooLarge.
  ///
  /// In en, this message translates to:
  /// **'Range too large'**
  String get inventoryValidationRangeTooLarge;

  /// No description provided for @inventoryValidationRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get inventoryValidationRequired;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageSimplifiedChinese.
  ///
  /// In en, this message translates to:
  /// **'Simplified Chinese'**
  String get languageSimplifiedChinese;

  /// No description provided for @languageSystemDefault.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get languageSystemDefault;

  /// No description provided for @navBrew.
  ///
  /// In en, this message translates to:
  /// **'Brew'**
  String get navBrew;

  /// No description provided for @navHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// No description provided for @navManage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get navManage;

  /// No description provided for @onboardingParamListSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Hide defaults or add custom parameters.'**
  String get onboardingParamListSubtitle;

  /// No description provided for @onboardingParamListTitle.
  ///
  /// In en, this message translates to:
  /// **'Parameter list'**
  String get onboardingParamListTitle;

  /// No description provided for @onboardingPrimaryFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get onboardingPrimaryFinish;

  /// No description provided for @onboardingPrimaryNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingPrimaryNext;

  /// No description provided for @onboardingPrimaryNextMethod.
  ///
  /// In en, this message translates to:
  /// **'Next Method'**
  String get onboardingPrimaryNextMethod;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingStepChooseMethodsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select at least one method to start. You can add one custom method for your workflow.'**
  String get onboardingStepChooseMethodsSubtitle;

  /// No description provided for @onboardingStepChooseMethodsTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose brew methods'**
  String get onboardingStepChooseMethodsTitle;

  /// No description provided for @onboardingTagline.
  ///
  /// In en, this message translates to:
  /// **'Focus on one brew at a time.'**
  String get onboardingTagline;

  /// No description provided for @onboardingWelcomeTo.
  ///
  /// In en, this message translates to:
  /// **'Welcome to'**
  String get onboardingWelcomeTo;

  /// No description provided for @posterMetricBloom.
  ///
  /// In en, this message translates to:
  /// **'BLOOM'**
  String get posterMetricBloom;

  /// No description provided for @posterMetricDose.
  ///
  /// In en, this message translates to:
  /// **'DOSE'**
  String get posterMetricDose;

  /// No description provided for @posterMetricGrind.
  ///
  /// In en, this message translates to:
  /// **'GRIND'**
  String get posterMetricGrind;

  /// No description provided for @posterMetricPour.
  ///
  /// In en, this message translates to:
  /// **'POUR'**
  String get posterMetricPour;

  /// No description provided for @posterMetricRatio.
  ///
  /// In en, this message translates to:
  /// **'RATIO'**
  String get posterMetricRatio;

  /// No description provided for @posterMetricRoom.
  ///
  /// In en, this message translates to:
  /// **'ROOM'**
  String get posterMetricRoom;

  /// No description provided for @posterMetricTemp.
  ///
  /// In en, this message translates to:
  /// **'TEMP'**
  String get posterMetricTemp;

  /// No description provided for @posterMetricTime.
  ///
  /// In en, this message translates to:
  /// **'TIME'**
  String get posterMetricTime;

  /// No description provided for @posterMetricWater.
  ///
  /// In en, this message translates to:
  /// **'WATER'**
  String get posterMetricWater;

  /// No description provided for @posterMetricYield.
  ///
  /// In en, this message translates to:
  /// **'YIELD'**
  String get posterMetricYield;

  /// No description provided for @posterScoreAcid.
  ///
  /// In en, this message translates to:
  /// **'ACID'**
  String get posterScoreAcid;

  /// No description provided for @posterScoreBitter.
  ///
  /// In en, this message translates to:
  /// **'BITTER'**
  String get posterScoreBitter;

  /// No description provided for @posterScoreBody.
  ///
  /// In en, this message translates to:
  /// **'BODY'**
  String get posterScoreBody;

  /// No description provided for @posterScoreSweet.
  ///
  /// In en, this message translates to:
  /// **'SWEET'**
  String get posterScoreSweet;

  /// No description provided for @progressiveExpandShowLess.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get progressiveExpandShowLess;

  /// No description provided for @progressiveExpandShowMore.
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get progressiveExpandShowMore;

  /// No description provided for @ratingFlavorNotesTitle.
  ///
  /// In en, this message translates to:
  /// **'Flavor Notes'**
  String get ratingFlavorNotesTitle;

  /// No description provided for @ratingLabelAcidity.
  ///
  /// In en, this message translates to:
  /// **'Acidity'**
  String get ratingLabelAcidity;

  /// No description provided for @ratingLabelBitterness.
  ///
  /// In en, this message translates to:
  /// **'Bitterness'**
  String get ratingLabelBitterness;

  /// No description provided for @ratingLabelBody.
  ///
  /// In en, this message translates to:
  /// **'Body'**
  String get ratingLabelBody;

  /// No description provided for @ratingLabelSweetness.
  ///
  /// In en, this message translates to:
  /// **'Sweetness'**
  String get ratingLabelSweetness;

  /// No description provided for @ratingModeProfessional.
  ///
  /// In en, this message translates to:
  /// **'Professional'**
  String get ratingModeProfessional;

  /// No description provided for @ratingModeQuick.
  ///
  /// In en, this message translates to:
  /// **'Quick'**
  String get ratingModeQuick;

  /// No description provided for @ratingMoodTitle.
  ///
  /// In en, this message translates to:
  /// **'Mood'**
  String get ratingMoodTitle;

  /// No description provided for @ratingProScoresTitle.
  ///
  /// In en, this message translates to:
  /// **'Professional Scores'**
  String get ratingProScoresTitle;

  /// No description provided for @ratingQuickTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick Rating'**
  String get ratingQuickTitle;

  /// No description provided for @ratingSave.
  ///
  /// In en, this message translates to:
  /// **'Save rating'**
  String get ratingSave;

  /// No description provided for @ratingSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get ratingSaving;

  /// No description provided for @ratingSheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Saved successfully. Add a quick score or detailed flavor notes.'**
  String get ratingSheetSubtitle;

  /// No description provided for @ratingSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Rate this brew'**
  String get ratingSheetTitle;

  /// No description provided for @ratingSkipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get ratingSkipForNow;

  /// No description provided for @ratingStarTooltip.
  ///
  /// In en, this message translates to:
  /// **'{star} star'**
  String ratingStarTooltip(int star);

  /// No description provided for @routeInvalidHistoryDetailId.
  ///
  /// In en, this message translates to:
  /// **'Invalid history detail id.'**
  String get routeInvalidHistoryDetailId;

  /// No description provided for @sharePreviewSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save poster: {details}'**
  String sharePreviewSaveFailed(String details);

  /// No description provided for @sharePreviewSavePoster.
  ///
  /// In en, this message translates to:
  /// **'Save Poster'**
  String get sharePreviewSavePoster;

  /// No description provided for @sharePreviewSaved.
  ///
  /// In en, this message translates to:
  /// **'Poster saved to your photo library.'**
  String get sharePreviewSaved;

  /// No description provided for @sharePreviewSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get sharePreviewSaving;

  /// No description provided for @sharePreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Share your brew'**
  String get sharePreviewTitle;

  /// No description provided for @singleSelectAddAction.
  ///
  /// In en, this message translates to:
  /// **'Add new'**
  String get singleSelectAddAction;

  /// No description provided for @singleSelectDialogConfirm.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get singleSelectDialogConfirm;

  /// No description provided for @singleSelectDialogHint.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get singleSelectDialogHint;

  /// No description provided for @singleSelectDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get singleSelectDialogTitle;

  /// No description provided for @singleSelectEmptyState.
  ///
  /// In en, this message translates to:
  /// **'No suggestions yet'**
  String get singleSelectEmptyState;

  /// No description provided for @singleSelectHint.
  ///
  /// In en, this message translates to:
  /// **'Select an option'**
  String get singleSelectHint;

  /// No description provided for @timerPhaseBloom.
  ///
  /// In en, this message translates to:
  /// **'Bloom'**
  String get timerPhaseBloom;

  /// No description provided for @timerPhaseBrewing.
  ///
  /// In en, this message translates to:
  /// **'Brewing'**
  String get timerPhaseBrewing;

  /// No description provided for @timerPhaseDone.
  ///
  /// In en, this message translates to:
  /// **'Done ✓'**
  String get timerPhaseDone;

  /// No description provided for @timerPhaseReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get timerPhaseReady;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hans':
            return AppLocalizationsZhHans();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
