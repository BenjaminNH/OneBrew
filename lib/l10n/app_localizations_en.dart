// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get actionAdd => 'Add';

  @override
  String get actionBrewAgain => 'Brew Again';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionGoBack => 'Go Back';

  @override
  String get actionRetry => 'Retry';

  @override
  String get actionShare => 'Share';

  @override
  String get appTitle => 'OneBrew';

  @override
  String get brewActionAddCustomParameter => 'Add Custom Parameter';

  @override
  String get brewActionAddParameter => 'Add Parameter';

  @override
  String get brewActionApply => 'Apply';

  @override
  String get brewActionClear => 'Clear';

  @override
  String get brewAddParamFieldDefaultLabel => 'Default (optional)';

  @override
  String get brewAddParamFieldMaxLabel => 'Max';

  @override
  String get brewAddParamFieldMinLabel => 'Min';

  @override
  String get brewAddParamFieldNameHint => 'e.g. Flow Rate';

  @override
  String get brewAddParamFieldStepLabel => 'Step (optional)';

  @override
  String get brewAddParamFieldTypeLabel => 'Type';

  @override
  String get brewAddParamFieldUnitHint => 'e.g. g, ml, bar';

  @override
  String get brewAddParamFieldUnitLabel => 'Unit (optional)';

  @override
  String get brewAddParamSheetTitle => 'New Parameter';

  @override
  String get brewAddParamValidationDefaultWithinRange =>
      'Default must stay within range.';

  @override
  String get brewAddParamValidationMaxGreaterThanMin =>
      'Max must be greater than min.';

  @override
  String get brewAddParamValidationMaxRequired => 'Max is required.';

  @override
  String get brewAddParamValidationMinRequired => 'Min is required.';

  @override
  String get brewAddParamValidationNameRequired => 'Name is required.';

  @override
  String get brewAddParamValidationStepPositive =>
      'Step must be greater than 0.';

  @override
  String brewAdjustDialogTitle(String label) {
    return 'Adjust $label';
  }

  @override
  String brewAdjustedToNearestStep(String value, String unit) {
    return 'Adjusted to nearest step: $value$unit';
  }

  @override
  String get brewAdvancedBloomLabel => 'Bloom';

  @override
  String get brewAdvancedBloomSemantic => 'Bloom time in seconds';

  @override
  String get brewAdvancedCoarsenessHint => 'Select coarseness';

  @override
  String get brewAdvancedCoarsenessLabel => 'Coarseness';

  @override
  String get brewAdvancedEquipmentLabel => 'Grinder / Equipment';

  @override
  String get brewAdvancedGrindClicksLabel => 'Grind Clicks';

  @override
  String get brewAdvancedGrindClicksSemantic => 'Grind click value';

  @override
  String get brewAdvancedGrindModeGrinder => 'Grinder';

  @override
  String get brewAdvancedGrindModePro => 'Pro (μm)';

  @override
  String get brewAdvancedGrindModeSimple => 'Simple';

  @override
  String get brewAdvancedGrindSizeLabel => 'Grind size (μm)';

  @override
  String get brewAdvancedPourMethodHint => 'e.g. Spiral, Pulse, Centre';

  @override
  String get brewAdvancedPourMethodLabel => 'Pour Method';

  @override
  String get brewAdvancedSelectGrinderHint => 'Select grinder...';

  @override
  String get brewAdvancedTempLabel => 'Temp';

  @override
  String get brewAdvancedTempSemantic => 'Water temperature';

  @override
  String get brewBeanHint => 'Search or add bean...';

  @override
  String get brewBeanLabel => 'Coffee Bean';

  @override
  String get brewCustomMethodDefaultName => 'Custom';

  @override
  String get brewCustomMethodDelete => 'Delete';

  @override
  String brewCustomMethodDisplay(String name) {
    return 'Custom method: $name';
  }

  @override
  String get brewCustomMethodNameHint => 'e.g. AeroPress';

  @override
  String get brewCustomMethodNameLabel => 'Method name';

  @override
  String get brewCustomMethodRename => 'Rename';

  @override
  String get brewCustomMethodSave => 'Save';

  @override
  String get brewCustomMethodSheetTitle => 'Custom Brew Method';

  @override
  String get brewCustomMethodWantAnother => 'Want another method? Add one';

  @override
  String get brewDetailAddRating => 'Add Rating';

  @override
  String get brewDetailDeleteFailed => 'Failed to delete brew.';

  @override
  String get brewDetailDeleteTooltip => 'Delete brew';

  @override
  String get brewDetailDeleted => 'Brew deleted.';

  @override
  String get brewDetailEditRating => 'Edit Rating';

  @override
  String get brewDetailGrindClickUnitDefault => 'clicks';

  @override
  String get brewDetailGrindModeEquipment => 'Equipment';

  @override
  String get brewDetailGrindModePro => 'Pro';

  @override
  String get brewDetailGrindModeSimple => 'Simple';

  @override
  String get brewDetailLabelAcidity => 'Acidity';

  @override
  String get brewDetailLabelBean => 'Bean';

  @override
  String get brewDetailLabelBitterness => 'Bitterness';

  @override
  String get brewDetailLabelBloomTime => 'Bloom Time';

  @override
  String get brewDetailLabelBody => 'Body';

  @override
  String get brewDetailLabelBrewedAt => 'Brewed At';

  @override
  String get brewDetailLabelCoffee => 'Coffee';

  @override
  String get brewDetailLabelCreatedAt => 'Created At';

  @override
  String get brewDetailLabelDuration => 'Duration';

  @override
  String get brewDetailLabelFlavorNotes => 'Flavor Notes';

  @override
  String get brewDetailLabelGrindClick => 'Click';

  @override
  String get brewDetailLabelGrindEquipment => 'Equipment';

  @override
  String get brewDetailLabelGrindLabel => 'Label';

  @override
  String get brewDetailLabelGrindMicrons => 'Microns';

  @override
  String get brewDetailLabelGrindMode => 'Mode';

  @override
  String get brewDetailLabelNotes => 'Notes';

  @override
  String get brewDetailLabelOrigin => 'Origin';

  @override
  String get brewDetailLabelPourMethod => 'Pour Method';

  @override
  String get brewDetailLabelQuick => 'Quick';

  @override
  String get brewDetailLabelRatio => 'Ratio';

  @override
  String get brewDetailLabelRoastLevel => 'Roast Level';

  @override
  String get brewDetailLabelRoaster => 'Roaster';

  @override
  String get brewDetailLabelRoomTemp => 'Room Temp';

  @override
  String get brewDetailLabelSweetness => 'Sweetness';

  @override
  String get brewDetailLabelUpdatedAt => 'Updated At';

  @override
  String get brewDetailLabelWater => 'Water';

  @override
  String get brewDetailLabelWaterTemp => 'Water Temp';

  @override
  String get brewDetailLabelWaterType => 'Water Type';

  @override
  String get brewDetailNotFound => 'Brew record not found.';

  @override
  String brewDetailQuickScore(int score) {
    return '$score/5';
  }

  @override
  String get brewDetailRatingEmpty => 'No rating recorded yet.';

  @override
  String get brewDetailRatingUpdated => 'Rating updated.';

  @override
  String get brewDetailSectionBasic => 'Basic';

  @override
  String get brewDetailSectionBrewParams => 'Brew Params';

  @override
  String get brewDetailSectionEnvironment => 'Environment';

  @override
  String get brewDetailSectionGrind => 'Grind';

  @override
  String get brewDetailSectionMeta => 'Meta';

  @override
  String get brewDetailSectionRating => 'Rating';

  @override
  String get brewDetailSectionRecordedParams => 'Recorded Params';

  @override
  String get brewDetailTitle => 'Brew Detail';

  @override
  String get brewDetailUnrated => 'Unrated';

  @override
  String get brewEnableMethodInPreferences =>
      'Enable a brew method in preferences to start logging.';

  @override
  String get brewEnableMethodToConfigureParams =>
      'Enable a brew method to configure parameters.';

  @override
  String get brewErrorInvalidNumber => 'Please enter a valid number.';

  @override
  String brewErrorValueOutOfRange(double min, double max) {
    return 'Value must be between $min and $max.';
  }

  @override
  String get brewErrorValueRequired => 'Value is required.';

  @override
  String get brewGrindModeLabel => 'Grind Mode';

  @override
  String get brewGrindSimpleCoarse => 'Coarse';

  @override
  String get brewGrindSimpleExtraCoarse => 'Extra Coarse';

  @override
  String get brewGrindSimpleExtraFine => 'Extra Fine';

  @override
  String get brewGrindSimpleFine => 'Fine';

  @override
  String get brewGrindSimpleMedium => 'Medium';

  @override
  String get brewGrindSimpleMediumCoarse => 'Medium Coarse';

  @override
  String get brewGrindSimpleMediumFine => 'Medium Fine';

  @override
  String get brewLabelCoffee => 'Coffee';

  @override
  String get brewLabelDose => 'Dose';

  @override
  String get brewLabelWater => 'Water';

  @override
  String get brewLabelYield => 'Yield';

  @override
  String get brewMethodNameEspresso => 'Espresso';

  @override
  String get brewMethodNamePourOver => 'Pour Over';

  @override
  String get brewMethodSelectorLabel => 'Brew Method';

  @override
  String get brewMethodsUnavailable => 'Brew methods unavailable.';

  @override
  String get brewNoParamsConfiguredYet =>
      'No parameters configured for this brew method yet.';

  @override
  String get brewParamLabelAgitation => 'Agitation';

  @override
  String get brewParamLabelBloomTime => 'Bloom Time';

  @override
  String get brewParamLabelBloomWater => 'Bloom Water';

  @override
  String get brewParamLabelBrewRatio => 'Brew Ratio';

  @override
  String get brewParamLabelBrewTime => 'Brew Time';

  @override
  String get brewParamLabelCoffeeDose => 'Dose';

  @override
  String get brewParamLabelDistributionTamping => 'Distribution/Tamping';

  @override
  String get brewParamLabelExtractionTime => 'Extraction Time';

  @override
  String get brewParamLabelFilterDripper => 'Filter/Dripper';

  @override
  String get brewParamLabelGrindSize => 'Grind Size';

  @override
  String get brewParamLabelPourMethod => 'Pour Method';

  @override
  String get brewParamLabelPreInfusion => 'Pre-infusion Time';

  @override
  String get brewParamLabelPressure => 'Pressure';

  @override
  String get brewParamLabelWaterTemp => 'Water Temp';

  @override
  String get brewParamLabelWaterWeight => 'Water';

  @override
  String get brewParamLabelYield => 'Yield';

  @override
  String get brewParamTypeNumber => 'Number';

  @override
  String get brewParamTypeText => 'Text';

  @override
  String get brewPreferencesSectionMethodsSubtitle =>
      'Choose which methods appear in the Brew page.';

  @override
  String get brewPreferencesSectionMethodsTitle => 'Brew Methods';

  @override
  String get brewPreferencesSectionParamsSubtitle =>
      'Hide defaults or add custom parameters for each brew method.';

  @override
  String get brewPreferencesSectionParamsTitle => 'Parameter List';

  @override
  String get brewPreferencesSubtitle =>
      'Set your default brew methods and parameter list.';

  @override
  String get brewPreferencesTitle => 'Record Preferences';

  @override
  String get brewRatingSaved => 'Rating saved!';

  @override
  String brewRatioBadge(String ratio) {
    return '1 : $ratio';
  }

  @override
  String get brewRenameCustomMethodSheetTitle => 'Rename Custom Method';

  @override
  String get brewSaveActionDisabled => 'Start timer to save';

  @override
  String get brewSaveActionReady => 'Save Brew';

  @override
  String get brewSaveRecordSemantics => 'Save brew record';

  @override
  String get brewSaveSuccessMessage =>
      'Brew saved. You can rate now or later in History detail.';

  @override
  String get brewSaveSuccessRateNow => 'Rate now';

  @override
  String brewSemanticValue(String label) {
    return '$label value';
  }

  @override
  String brewSemanticWeight(String label) {
    return '$label weight';
  }

  @override
  String brewTemplateApplied(String beanName) {
    return 'Template applied: $beanName';
  }

  @override
  String get brewTemplateLoadedFromHistory => 'Template loaded from history';

  @override
  String brewTemplateSubtitle(
    String coffeeGrams,
    String waterGrams,
    String duration,
  ) {
    return '${coffeeGrams}g -> ${waterGrams}g | $duration';
  }

  @override
  String get brewTemplatesUnavailable => 'Templates unavailable right now.';

  @override
  String get brewTextFieldHintEnterText => 'Enter text';

  @override
  String brewTimerAdjustStepTooltip(int seconds) {
    return 'Adjust target by ${seconds}s';
  }

  @override
  String get brewTimerBrew => 'Brew';

  @override
  String get brewTimerDecreaseTargetSemantics => 'Decrease target';

  @override
  String brewTimerDecreaseTargetTooltip(int seconds) {
    return 'Decrease target by ${seconds}s';
  }

  @override
  String get brewTimerEnableTargetToUseCountdown =>
      'Enable target to use countdown';

  @override
  String get brewTimerIncreaseTargetSemantics => 'Increase target';

  @override
  String brewTimerIncreaseTargetTooltip(int seconds) {
    return 'Increase target by ${seconds}s';
  }

  @override
  String get brewTimerPause => 'Pause';

  @override
  String get brewTimerReset => 'Reset timer';

  @override
  String get brewTimerResume => 'Resume';

  @override
  String get brewTimerSwitchToCountUp => 'Switch to count-up';

  @override
  String get brewTimerSwitchToCountdown => 'Switch to countdown';

  @override
  String get brewTimerTargetOff => 'Target Off';

  @override
  String get brewTimerTargetOn => 'Target On';

  @override
  String brewTimerTargetValue(String time) {
    return 'Target $time';
  }

  @override
  String get brewTimerToggleCountdownSemantics => 'Toggle countdown mode';

  @override
  String get brewTimerUseTarget => 'Use Target';

  @override
  String get brewTooltipDeleteParameter => 'Delete parameter';

  @override
  String get brewUntitledBrew => 'Untitled Brew';

  @override
  String get brewValueLabel => 'Value';

  @override
  String brewValueLabelWithUnit(String unit) {
    return 'Value ($unit)';
  }

  @override
  String get chipInputAddMore => 'Add more…';

  @override
  String get chipInputHint => 'Type and press Enter…';

  @override
  String get commonName => 'Name';

  @override
  String dateDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# days ago',
      one: '# day ago',
    );
    return '$_temp0';
  }

  @override
  String get dateJustNow => 'Just now';

  @override
  String dateMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# minutes ago',
      one: '# minute ago',
    );
    return '$_temp0';
  }

  @override
  String get dateThisWeek => 'This Week';

  @override
  String get dateToday => 'Today';

  @override
  String dateTodayAt(String time) {
    return 'Today $time';
  }

  @override
  String get dateYesterday => 'Yesterday';

  @override
  String dateYesterdayAt(String time) {
    return 'Yesterday $time';
  }

  @override
  String get deleteBrewDialogBody =>
      'Delete this brew record? This action cannot be undone.';

  @override
  String get deleteBrewDialogTitle => 'Delete Brew';

  @override
  String get flavorNoteBerry => 'Berry';

  @override
  String get flavorNoteCaramel => 'Caramel';

  @override
  String get flavorNoteChocolate => 'Chocolate';

  @override
  String get flavorNoteCitrus => 'Citrus';

  @override
  String get flavorNoteClean => 'Clean';

  @override
  String get flavorNoteFloral => 'Floral';

  @override
  String get flavorNoteHerbal => 'Herbal';

  @override
  String get flavorNoteNutty => 'Nutty';

  @override
  String get flavorNoteSpice => 'Spice';

  @override
  String get flavorNoteStoneFruit => 'Stone Fruit';

  @override
  String get flavorNoteTea => 'Tea';

  @override
  String get flavorNoteTropical => 'Tropical';

  @override
  String get historyEmptyFiltered =>
      'No brew records match the current filter.';

  @override
  String get historyErrorFilter => 'Failed to filter history.';

  @override
  String get historyErrorLoad => 'Failed to load history.';

  @override
  String get historyErrorReset => 'Failed to reset history filter.';

  @override
  String get historyFilterAnyDate => 'Any date';

  @override
  String get historyFilterBeanAddAction => 'Use custom text';

  @override
  String get historyFilterBeanDialogConfirm => 'Use text';

  @override
  String get historyFilterBeanDialogHint => 'Bean name';

  @override
  String get historyFilterBeanDialogTitle => 'Filter by Bean';

  @override
  String get historyFilterBeanHint => 'Bean';

  @override
  String get historyFilterClearTooltip => 'Clear filters';

  @override
  String get historyFilterScoreAll => 'All';

  @override
  String get historyFilterScoreHint => 'Score';

  @override
  String historyRoasterPrefix(String roaster) {
    return 'Roaster: $roaster';
  }

  @override
  String historySecondsSuffix(int seconds) {
    return '${seconds}s';
  }

  @override
  String get historyStatsAvg => 'Avg';

  @override
  String get historyStatsBrews => 'Brews';

  @override
  String get historyStatsRated => 'Rated';

  @override
  String get historyTitle => 'Brew History';

  @override
  String get historyTopBrew => 'Top Brew';

  @override
  String inventoryAboutAuthor(String name) {
    return 'Author: $name';
  }

  @override
  String get inventoryAboutOpenGithub => 'Open GitHub Repository';

  @override
  String get inventoryAboutOpenGithubFailed => 'Unable to open GitHub link.';

  @override
  String get inventoryAboutTitle => 'About OneBrew';

  @override
  String inventoryAboutVersion(String version) {
    return 'Version: $version';
  }

  @override
  String get inventoryAboutVersionLoading => 'Loading...';

  @override
  String get inventoryAboutVersionUnavailable => 'Unavailable';

  @override
  String get inventoryActionCreate => 'Create';

  @override
  String get inventoryActionDelete => 'Delete';

  @override
  String get inventoryActionSave => 'Save';

  @override
  String get inventoryBeanCreated => 'Bean created.';

  @override
  String get inventoryBeanFormAddTitle => 'Add Bean';

  @override
  String get inventoryBeanFormEditTitle => 'Edit Bean';

  @override
  String get inventoryBeanFormLabelName => 'Bean name';

  @override
  String get inventoryBeanFormLabelOrigin => 'Origin';

  @override
  String get inventoryBeanFormLabelRoastLevel => 'Roast level';

  @override
  String get inventoryBeanFormLabelRoaster => 'Roaster';

  @override
  String get inventoryBeanFormNameRequired => 'Please enter bean name.';

  @override
  String get inventoryBeanUpdated => 'Bean updated successfully.';

  @override
  String get inventoryConflictGrinderNameExists =>
      'A grinder with the same name already exists.';

  @override
  String get inventoryDeleteBeanTitle => 'Delete Bean';

  @override
  String get inventoryDeleteBeanTooltip => 'Delete bean';

  @override
  String get inventoryDeleteGrinderTitle => 'Delete Grinder';

  @override
  String get inventoryDeleteGrinderTooltip => 'Delete grinder';

  @override
  String inventoryDeletePrompt(String name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get inventoryEditBeanTooltip => 'Edit bean';

  @override
  String get inventoryEditGrinderTooltip => 'Edit grinder';

  @override
  String get inventoryEmptyBeans => 'No beans found.';

  @override
  String get inventoryEmptyGrinders => 'No grinders found.';

  @override
  String inventoryErrorWithDetails(String details) {
    return 'Error: $details';
  }

  @override
  String get inventoryFabTooltipAddBean => 'Add bean';

  @override
  String get inventoryFabTooltipAddGrinder => 'Add grinder';

  @override
  String inventoryFailedToDeleteBean(String error) {
    return 'Failed to delete bean: $error';
  }

  @override
  String inventoryFailedToDeleteGrinder(String error) {
    return 'Failed to delete grinder: $error';
  }

  @override
  String inventoryFailedToSaveBean(String error) {
    return 'Failed to save bean: $error';
  }

  @override
  String inventoryFailedToSaveGrinder(String error) {
    return 'Failed to save grinder: $error';
  }

  @override
  String inventoryFailedToSaveTag(String tag, String error) {
    return 'Failed to save \"$tag\": $error';
  }

  @override
  String get inventoryGrinderCreated => 'Grinder created successfully.';

  @override
  String get inventoryGrinderFormAddTitle => 'Add Grinder';

  @override
  String get inventoryGrinderFormEditTitle => 'Edit Grinder';

  @override
  String get inventoryGrinderFormLabelMaxClick => 'Max click';

  @override
  String get inventoryGrinderFormLabelMinClick => 'Min click';

  @override
  String get inventoryGrinderFormLabelName => 'Name';

  @override
  String get inventoryGrinderFormLabelStep => 'Step';

  @override
  String get inventoryGrinderFormLabelUnit => 'Unit';

  @override
  String get inventoryGrinderFormNameRequired => 'Please enter grinder name.';

  @override
  String inventoryGrinderMetaStep(num step) {
    return 'step $step';
  }

  @override
  String get inventoryGrinderUpdated => 'Grinder updated successfully.';

  @override
  String get inventoryLanguageTitle => 'Language';

  @override
  String inventoryMetaAdded(String date) {
    return 'Added $date';
  }

  @override
  String inventoryMetaUseCount(int count) {
    return 'Use $count';
  }

  @override
  String inventoryQuickGrinderSetupDescription(String tag) {
    return 'Configure \"$tag\". Leave blank to use defaults.';
  }

  @override
  String get inventoryQuickGrinderSetupLabelMax => 'Max';

  @override
  String get inventoryQuickGrinderSetupLabelMin => 'Min';

  @override
  String get inventoryQuickGrinderSetupLabelStep => 'Step';

  @override
  String get inventoryQuickGrinderSetupLabelUnit => 'Unit';

  @override
  String get inventoryQuickGrinderSetupSaveGrinder => 'Save Grinder';

  @override
  String get inventoryQuickGrinderSetupTitle => 'Quick Grinder Setup';

  @override
  String get inventoryQuickGrinderSetupUseDefaults => 'Use Defaults';

  @override
  String get inventoryQuickGrinderSetupValidationError =>
      'Please enter a valid range and step.';

  @override
  String get inventorySearchBeansHint => 'Search beans';

  @override
  String get inventorySearchGrindersHint => 'Search grinders';

  @override
  String get inventorySmartTagAddBean => 'Add bean';

  @override
  String get inventorySmartTagAddGrinder => 'Add grinder';

  @override
  String get inventorySmartTagDialogAddBean => 'Add Coffee Bean';

  @override
  String get inventorySmartTagDialogAddGrinder => 'Add Grinder';

  @override
  String get inventorySmartTagDialogHintBeanName => 'Bean name';

  @override
  String get inventorySmartTagDialogHintGrinderName => 'Grinder name';

  @override
  String get inventorySmartTagEmptyBeansYet => 'No beans yet';

  @override
  String get inventorySmartTagEmptyGrindersYet => 'No grinders yet';

  @override
  String get inventorySmartTagHint => 'Type to add...';

  @override
  String get inventoryTabBeans => 'Beans';

  @override
  String get inventoryTabGrinders => 'Grinders';

  @override
  String get inventoryTemplatePickerEmptyHint =>
      'Save one brew first, then reuse it here in one tap.';

  @override
  String get inventoryTemplatePickerFooter =>
      'Showing latest 3 brews only. Tap a chip to reuse.';

  @override
  String get inventoryTemplatePickerTitle => 'Brew Again (Templates)';

  @override
  String get inventoryTooltipAbout => 'About';

  @override
  String get inventoryTooltipDebugRerunOnboarding => 'Debug: Re-run onboarding';

  @override
  String get inventoryTooltipLanguage => 'Language';

  @override
  String get inventoryTooltipRecordPreferences => 'Record Preferences';

  @override
  String get inventoryValidationInvalid => 'Invalid';

  @override
  String get inventoryValidationMustBeGreaterThanMin => 'Must be > min';

  @override
  String get inventoryValidationMustBeGreaterThanZero => 'Must be > 0';

  @override
  String get inventoryValidationRangeTooLarge => 'Range too large';

  @override
  String get inventoryValidationRequired => 'Required';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSimplifiedChinese => 'Simplified Chinese';

  @override
  String get languageSystemDefault => 'System Default';

  @override
  String get navBrew => 'Brew';

  @override
  String get navHistory => 'History';

  @override
  String get navManage => 'Manage';

  @override
  String get onboardingParamListSubtitle =>
      'Hide defaults or add custom parameters.';

  @override
  String get onboardingParamListTitle => 'Parameter list';

  @override
  String get onboardingPrimaryFinish => 'Finish';

  @override
  String get onboardingPrimaryNext => 'Next';

  @override
  String get onboardingPrimaryNextMethod => 'Next Method';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingStepChooseMethodsSubtitle =>
      'Select at least one method to start. You can add one custom method for your workflow.';

  @override
  String get onboardingStepChooseMethodsTitle => 'Choose brew methods';

  @override
  String get onboardingTagline => 'Focus on one brew at a time.';

  @override
  String get onboardingWelcomeTo => 'Welcome to';

  @override
  String get posterMetricBloom => 'BLOOM';

  @override
  String get posterMetricDose => 'DOSE';

  @override
  String get posterMetricGrind => 'GRIND';

  @override
  String get posterMetricPour => 'POUR';

  @override
  String get posterMetricRatio => 'RATIO';

  @override
  String get posterMetricRoom => 'ROOM';

  @override
  String get posterMetricTemp => 'TEMP';

  @override
  String get posterMetricTime => 'TIME';

  @override
  String get posterMetricWater => 'WATER';

  @override
  String get posterMetricYield => 'YIELD';

  @override
  String get posterScoreAcid => 'ACID';

  @override
  String get posterScoreBitter => 'BITTER';

  @override
  String get posterScoreBody => 'BODY';

  @override
  String get posterScoreSweet => 'SWEET';

  @override
  String get progressiveExpandShowLess => 'Show less';

  @override
  String get progressiveExpandShowMore => 'Show more';

  @override
  String get ratingFlavorNotesTitle => 'Flavor Notes';

  @override
  String get ratingLabelAcidity => 'Acidity';

  @override
  String get ratingLabelBitterness => 'Bitterness';

  @override
  String get ratingLabelBody => 'Body';

  @override
  String get ratingLabelSweetness => 'Sweetness';

  @override
  String get ratingModeProfessional => 'Professional';

  @override
  String get ratingModeQuick => 'Quick';

  @override
  String get ratingMoodTitle => 'Mood';

  @override
  String get ratingProScoresTitle => 'Professional Scores';

  @override
  String get ratingQuickTitle => 'Quick Rating';

  @override
  String get ratingSave => 'Save rating';

  @override
  String get ratingSaving => 'Saving...';

  @override
  String get ratingSheetSubtitle =>
      'Saved successfully. Add a quick score or detailed flavor notes.';

  @override
  String get ratingSheetTitle => 'Rate this brew';

  @override
  String get ratingSkipForNow => 'Skip for now';

  @override
  String ratingStarTooltip(int star) {
    return '$star star';
  }

  @override
  String get routeInvalidHistoryDetailId => 'Invalid history detail id.';

  @override
  String sharePreviewSaveFailed(String details) {
    return 'Failed to save poster: $details';
  }

  @override
  String get sharePreviewSavePoster => 'Save Poster';

  @override
  String get sharePreviewSaved => 'Poster saved to your photo library.';

  @override
  String get sharePreviewSaving => 'Saving...';

  @override
  String get sharePreviewTitle => 'Share your brew';

  @override
  String get singleSelectAddAction => 'Add new';

  @override
  String get singleSelectDialogConfirm => 'Add';

  @override
  String get singleSelectDialogHint => 'Name';

  @override
  String get singleSelectDialogTitle => 'Add item';

  @override
  String get singleSelectEmptyState => 'No suggestions yet';

  @override
  String get singleSelectHint => 'Select an option';

  @override
  String get timerPhaseBloom => 'Bloom';

  @override
  String get timerPhaseBrewing => 'Brewing';

  @override
  String get timerPhaseDone => 'Done ✓';

  @override
  String get timerPhaseReady => 'Ready';
}
