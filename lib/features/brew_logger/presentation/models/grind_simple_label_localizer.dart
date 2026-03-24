import '../../../../l10n/app_localizations.dart';

String localizeGrindSimpleLabel(AppLocalizations l10n, String storageValue) {
  switch (storageValue.trim()) {
    case 'Extra Fine':
      return l10n.brewGrindSimpleExtraFine;
    case 'Fine':
      return l10n.brewGrindSimpleFine;
    case 'Medium Fine':
      return l10n.brewGrindSimpleMediumFine;
    case 'Medium':
      return l10n.brewGrindSimpleMedium;
    case 'Medium Coarse':
      return l10n.brewGrindSimpleMediumCoarse;
    case 'Coarse':
      return l10n.brewGrindSimpleCoarse;
    case 'Extra Coarse':
      return l10n.brewGrindSimpleExtraCoarse;
    default:
      return storageValue;
  }
}
