import 'brew_method.dart';
import 'brew_param_definition.dart';

abstract final class BrewParamKeys {
  static const customPrefix = 'custom:';
  static const coffeeWeight = 'coffee_weight';
  static const coffeeDose = 'coffee_dose';
  static const waterWeight = 'water_weight';
  static const yieldAmount = 'yield';
  static const brewRatio = 'brew_ratio';
  static const waterTemp = 'water_temp';
  static const grindSize = 'grind_size';
  static const brewTime = 'brew_time';
  static const extractionTime = 'extraction_time';
  static const bloomTime = 'bloom_time';
  static const bloomWater = 'bloom_water';
  static const pourMethod = 'pour_method';
  static const agitation = 'agitation';
  static const filter = 'filter';
  static const dripper = 'dripper';
  static const pressure = 'pressure';
  static const preInfusion = 'pre_infusion_time';
  static const distribution = 'distribution';
  static const tamping = 'tamping';
}

const Set<String> essentialParamKeys = {
  BrewParamKeys.coffeeWeight,
  BrewParamKeys.coffeeDose,
  BrewParamKeys.waterWeight,
  BrewParamKeys.yieldAmount,
  BrewParamKeys.brewRatio,
};

const Set<String> systemBoundParamKeys = {
  BrewParamKeys.coffeeWeight,
  BrewParamKeys.coffeeDose,
  BrewParamKeys.waterWeight,
  BrewParamKeys.yieldAmount,
  BrewParamKeys.brewRatio,
  BrewParamKeys.waterTemp,
  BrewParamKeys.brewTime,
  BrewParamKeys.extractionTime,
  BrewParamKeys.bloomTime,
  BrewParamKeys.pourMethod,
  BrewParamKeys.grindSize,
};

const Set<String> customFlexibleDefaultParamKeys = {
  BrewParamKeys.coffeeWeight,
  BrewParamKeys.waterWeight,
  BrewParamKeys.brewRatio,
};

const Set<String> durationSemanticParamKeys = {
  BrewParamKeys.brewTime,
  BrewParamKeys.extractionTime,
};

String? legacyParamKeyFromName(String name) {
  switch (_normalizeLegacyParamName(name)) {
    case 'coffee_weight':
      return BrewParamKeys.coffeeWeight;
    case 'coffee_dose':
      return BrewParamKeys.coffeeDose;
    case 'water_weight':
      return BrewParamKeys.waterWeight;
    case 'yield':
      return BrewParamKeys.yieldAmount;
    case 'brew_ratio':
      return BrewParamKeys.brewRatio;
    case 'water_temp':
      return BrewParamKeys.waterTemp;
    case 'grind_size':
      return BrewParamKeys.grindSize;
    case 'brew_time':
      return BrewParamKeys.brewTime;
    case 'extraction_time':
      return BrewParamKeys.extractionTime;
    case 'bloom_time':
      return BrewParamKeys.bloomTime;
    case 'bloom_water':
      return BrewParamKeys.bloomWater;
    case 'pour_method':
      return BrewParamKeys.pourMethod;
    case 'agitation':
      return BrewParamKeys.agitation;
    case 'filter':
      return BrewParamKeys.filter;
    case 'dripper':
      return BrewParamKeys.dripper;
    case 'pressure':
      return BrewParamKeys.pressure;
    case 'pre_infusion_time':
      return BrewParamKeys.preInfusion;
    case 'distribution':
      return BrewParamKeys.distribution;
    case 'tamping':
      return BrewParamKeys.tamping;
    default:
      return null;
  }
}

String? resolveParamKey({String? paramKey, required String name}) {
  return paramKey ?? legacyParamKeyFromName(name);
}

String customParamKeyForId(int id) => '${BrewParamKeys.customPrefix}$id';

bool isCustomParamKey(String? paramKey) {
  return paramKey != null && paramKey.startsWith(BrewParamKeys.customPrefix);
}

bool isSystemBoundParam({String? paramKey, required String name}) {
  final resolved = resolveParamKey(paramKey: paramKey, name: name);
  return resolved != null && systemBoundParamKeys.contains(resolved);
}

bool canToggleParam({
  required BrewMethod method,
  String? paramKey,
  required String name,
}) {
  final resolved = resolveParamKey(paramKey: paramKey, name: name);
  if (resolved == null) {
    return true;
  }
  if (method == BrewMethod.custom &&
      customFlexibleDefaultParamKeys.contains(resolved)) {
    return true;
  }
  return !essentialParamKeys.contains(resolved);
}

extension BrewParamDefinitionKeyX on BrewParamDefinition {
  String? get resolvedParamKey =>
      resolveParamKey(paramKey: paramKey, name: name);
}

String _normalizeLegacyParamName(String name) {
  return name
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
      .replaceAll(RegExp(r'^_+|_+$'), '');
}
