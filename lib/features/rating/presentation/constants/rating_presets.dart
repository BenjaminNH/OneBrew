const List<String> kRatingEmojis = ['😞', '😐', '🙂', '😍', '🤯'];

const List<String> kFlavorWheelNotes = [
  'Citrus',
  'Floral',
  'Berry',
  'Stone Fruit',
  'Chocolate',
  'Caramel',
  'Nutty',
  'Spice',
  'Tea',
  'Tropical',
  'Herbal',
  'Clean',
];

// These note strings are persisted (comma-separated) in rating records.
// Keep them stable; localize display labels only.
String flavorNoteLabel(String note, dynamic l10n) {
  switch (note) {
    case 'Citrus':
      return l10n.flavorNoteCitrus as String;
    case 'Floral':
      return l10n.flavorNoteFloral as String;
    case 'Berry':
      return l10n.flavorNoteBerry as String;
    case 'Stone Fruit':
      return l10n.flavorNoteStoneFruit as String;
    case 'Chocolate':
      return l10n.flavorNoteChocolate as String;
    case 'Caramel':
      return l10n.flavorNoteCaramel as String;
    case 'Nutty':
      return l10n.flavorNoteNutty as String;
    case 'Spice':
      return l10n.flavorNoteSpice as String;
    case 'Tea':
      return l10n.flavorNoteTea as String;
    case 'Tropical':
      return l10n.flavorNoteTropical as String;
    case 'Herbal':
      return l10n.flavorNoteHerbal as String;
    case 'Clean':
      return l10n.flavorNoteClean as String;
    default:
      return note;
  }
}
