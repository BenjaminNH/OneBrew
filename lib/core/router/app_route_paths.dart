/// Canonical route paths used by the app shell.
abstract final class AppRoutePaths {
  static const launch = '/';
  static const brew = '/brew';
  static const manage = '/manage';
  static const history = '/history';
  static const onboarding = '/onboarding';
  static const managePreferences = '/manage/preferences';

  static String historyDetail(int id) => '$history/$id';

  static String brewWithTemplate(int templateRecordId) =>
      '$brew?templateRecordId=$templateRecordId';
}
