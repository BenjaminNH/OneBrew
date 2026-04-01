import 'package:one_brew/l10n/app_localizations.dart';

import '../../domain/entities/brew_param_definition.dart';
import '../../domain/entities/brew_param_key.dart';
import 'grind_simple_label_localizer.dart';

String localizedParamLabel({
  required AppLocalizations l10n,
  String? paramKey,
  required String fallbackName,
}) {
  switch (paramKey) {
    case BrewParamKeys.coffeeWeight:
    case BrewParamKeys.coffeeDose:
      return l10n.brewParamLabelCoffeeDose;
    case BrewParamKeys.waterWeight:
      return l10n.brewParamLabelWaterWeight;
    case BrewParamKeys.yieldAmount:
      return l10n.brewParamLabelYield;
    case BrewParamKeys.brewRatio:
      return l10n.brewParamLabelBrewRatio;
    case BrewParamKeys.waterTemp:
      return l10n.brewParamLabelWaterTemp;
    case BrewParamKeys.grindSize:
      return l10n.brewParamLabelGrindSize;
    case BrewParamKeys.brewTime:
      return l10n.brewParamLabelBrewTime;
    case BrewParamKeys.extractionTime:
      return l10n.brewParamLabelExtractionTime;
    case BrewParamKeys.bloomTime:
      return l10n.brewParamLabelBloomTime;
    case BrewParamKeys.bloomWater:
      return l10n.brewParamLabelBloomWater;
    case BrewParamKeys.pourMethod:
      return l10n.brewParamLabelPourMethod;
    case BrewParamKeys.agitation:
      return l10n.brewParamLabelAgitation;
    case BrewParamKeys.filter:
      return l10n.brewParamLabelFilter;
    case BrewParamKeys.dripper:
      return l10n.brewParamLabelDripper;
    case BrewParamKeys.pressure:
      return l10n.brewParamLabelPressure;
    case BrewParamKeys.preInfusion:
      return l10n.brewParamLabelPreInfusion;
    case BrewParamKeys.distribution:
      return l10n.brewParamLabelDistribution;
    case BrewParamKeys.tamping:
      return l10n.brewParamLabelTamping;
    default:
      return fallbackName;
  }
}

String localizedParamLabelForDefinition(
  BrewParamDefinition definition,
  AppLocalizations l10n,
) {
  return localizedParamLabel(
    l10n: l10n,
    paramKey: definition.resolvedParamKey,
    fallbackName: definition.name,
  );
}

String localizedParamValue({
  required AppLocalizations l10n,
  String? paramKey,
  required String value,
}) {
  switch (paramKey) {
    case BrewParamKeys.grindSize:
      return localizeGrindSimpleLabel(l10n, value);
    default:
      return value;
  }
}
