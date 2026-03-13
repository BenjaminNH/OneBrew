import '../../domain/entities/brew_method.dart';

abstract final class BrewParamNames {
  static const coffeeWeight = 'Coffee Weight';
  static const coffeeDose = 'Coffee Dose';
  static const waterWeight = 'Water Weight';
  static const yield = 'Yield';
  static const brewRatio = 'Brew Ratio';
  static const waterTemp = 'Water Temp';
  static const grindSize = 'Grind Size';
  static const brewTime = 'Brew Time';
  static const extractionTime = 'Extraction Time';
  static const bloomTime = 'Bloom Time';
  static const bloomWater = 'Bloom Water';
  static const pourMethod = 'Pour Method';
  static const agitation = 'Agitation';
  static const filterDripper = 'Filter/Dripper';
  static const pressure = 'Pressure';
  static const preInfusion = 'Pre-infusion Time';
  static const distributionTamping = 'Distribution/Tamping';
}

const Set<String> essentialParamNames = {
  BrewParamNames.coffeeWeight,
  BrewParamNames.coffeeDose,
  BrewParamNames.waterWeight,
  BrewParamNames.yield,
  BrewParamNames.brewRatio,
};

const Set<String> systemBoundParamNames = {
  BrewParamNames.coffeeWeight,
  BrewParamNames.coffeeDose,
  BrewParamNames.waterWeight,
  BrewParamNames.yield,
  BrewParamNames.brewRatio,
  BrewParamNames.waterTemp,
  BrewParamNames.brewTime,
  BrewParamNames.extractionTime,
  BrewParamNames.bloomTime,
  BrewParamNames.pourMethod,
  BrewParamNames.grindSize,
};

const Set<String> customFlexibleDefaultParamNames = {
  BrewParamNames.coffeeWeight,
  BrewParamNames.waterWeight,
  BrewParamNames.brewRatio,
};

bool canToggleParam({required BrewMethod method, required String name}) {
  if (method == BrewMethod.custom &&
      customFlexibleDefaultParamNames.contains(name)) {
    return true;
  }
  return !essentialParamNames.contains(name);
}
