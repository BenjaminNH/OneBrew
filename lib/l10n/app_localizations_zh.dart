// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get actionAdd => '添加';

  @override
  String get actionBrewAgain => '再萃取一次';

  @override
  String get actionCancel => '取消';

  @override
  String get actionDelete => '删除';

  @override
  String get actionGoBack => '返回';

  @override
  String get actionRetry => '重试';

  @override
  String get actionShare => '分享';

  @override
  String get appTitle => 'OneBrew';

  @override
  String get brewActionAddCustomParameter => '添加自定义参数';

  @override
  String get brewActionAddParameter => '添加参数';

  @override
  String get brewActionApply => '应用';

  @override
  String get brewActionClear => '清除';

  @override
  String get brewAddParamFieldDefaultLabel => '默认值（可选）';

  @override
  String get brewAddParamFieldMaxLabel => '最大值';

  @override
  String get brewAddParamFieldMinLabel => '最小值';

  @override
  String get brewAddParamFieldNameHint => '例如：流速';

  @override
  String get brewAddParamFieldStepLabel => '步长（可选）';

  @override
  String get brewAddParamFieldTypeLabel => '类型';

  @override
  String get brewAddParamFieldUnitHint => '例如：g、ml、bar';

  @override
  String get brewAddParamFieldUnitLabel => '单位（可选）';

  @override
  String get brewAddParamSheetTitle => '新参数';

  @override
  String get brewAddParamValidationDefaultWithinRange => '默认值必须在范围内。';

  @override
  String get brewAddParamValidationMaxGreaterThanMin => '最大值必须大于最小值。';

  @override
  String get brewAddParamValidationMaxRequired => '请输入最大值。';

  @override
  String get brewAddParamValidationMinRequired => '请输入最小值。';

  @override
  String get brewAddParamValidationNameRequired => '请输入名称。';

  @override
  String get brewAddParamValidationStepPositive => '步长必须大于 0。';

  @override
  String brewAdjustDialogTitle(String label) {
    return '调整 $label';
  }

  @override
  String brewAdjustedToNearestStep(String value, String unit) {
    return '已调整到最近的步进：$value$unit';
  }

  @override
  String get brewAdvancedBloomLabel => '闷蒸';

  @override
  String get brewAdvancedBloomSemantic => '闷蒸时间（秒）';

  @override
  String get brewAdvancedCoarsenessHint => '选择粗细';

  @override
  String get brewAdvancedCoarsenessLabel => '粗细';

  @override
  String get brewAdvancedEquipmentLabel => '磨豆机 / 器具';

  @override
  String get brewAdvancedGrindClicksLabel => '刻度';

  @override
  String get brewAdvancedGrindClicksSemantic => '研磨刻度';

  @override
  String get brewAdvancedGrindModeGrinder => '磨豆机';

  @override
  String get brewAdvancedGrindModePro => '专业（μm）';

  @override
  String get brewAdvancedGrindModeSimple => '简易';

  @override
  String get brewAdvancedGrindSizeLabel => '研磨粒径（μm）';

  @override
  String get brewAdvancedPourMethodHint => '例如：螺旋、脉冲、中心';

  @override
  String get brewAdvancedPourMethodLabel => '注水方式';

  @override
  String get brewAdvancedSelectGrinderHint => '选择磨豆机…';

  @override
  String get brewAdvancedTempLabel => '水温';

  @override
  String get brewAdvancedTempSemantic => '水温';

  @override
  String get brewBeanHint => '搜索或添加咖啡豆…';

  @override
  String get brewBeanLabel => '咖啡豆';

  @override
  String get brewCustomMethodDefaultName => '自定义';

  @override
  String get brewCustomMethodDelete => '删除';

  @override
  String brewCustomMethodDisplay(String name) {
    return '自定义方式：$name';
  }

  @override
  String get brewCustomMethodNameHint => '例如：AeroPress';

  @override
  String get brewCustomMethodNameLabel => '方式名称';

  @override
  String get brewCustomMethodRename => '重命名';

  @override
  String get brewCustomMethodSave => '保存';

  @override
  String get brewCustomMethodSheetTitle => '自定义萃取方式';

  @override
  String get brewCustomMethodWantAnother => '需要另一种方式？点此添加';

  @override
  String get brewDetailAddRating => '添加评分';

  @override
  String get brewDetailDeleteFailed => '删除失败。';

  @override
  String get brewDetailDeleteTooltip => '删除记录';

  @override
  String get brewDetailDeleted => '已删除记录。';

  @override
  String get brewDetailEditRating => '编辑评分';

  @override
  String get brewDetailGrindClickUnitDefault => '格';

  @override
  String get brewDetailGrindModeEquipment => '器具';

  @override
  String get brewDetailGrindModePro => '专业';

  @override
  String get brewDetailGrindModeSimple => '简易';

  @override
  String get brewDetailLabelAcidity => '酸度';

  @override
  String get brewDetailLabelBean => '咖啡豆';

  @override
  String get brewDetailLabelBitterness => '苦度';

  @override
  String get brewDetailLabelBloomTime => '闷蒸时间';

  @override
  String get brewDetailLabelBody => '醇厚';

  @override
  String get brewDetailLabelBrewedAt => '萃取时间';

  @override
  String get brewDetailLabelCoffee => '粉量';

  @override
  String get brewDetailLabelCreatedAt => '创建时间';

  @override
  String get brewDetailLabelDuration => '时长';

  @override
  String get brewDetailLabelFlavorNotes => '风味';

  @override
  String get brewDetailLabelGrindClick => '刻度';

  @override
  String get brewDetailLabelGrindEquipment => '器具';

  @override
  String get brewDetailLabelGrindLabel => '描述';

  @override
  String get brewDetailLabelGrindMicrons => '粒径';

  @override
  String get brewDetailLabelGrindMode => '模式';

  @override
  String get brewDetailLabelNotes => '备注';

  @override
  String get brewDetailLabelOrigin => '产地';

  @override
  String get brewDetailLabelPourMethod => '注水方式';

  @override
  String get brewDetailLabelQuick => '快速';

  @override
  String get brewDetailLabelRatio => '比例';

  @override
  String get brewDetailLabelRoastLevel => '烘焙度';

  @override
  String get brewDetailLabelRoaster => '烘焙商';

  @override
  String get brewDetailLabelRoomTemp => '室温';

  @override
  String get brewDetailLabelSweetness => '甜度';

  @override
  String get brewDetailLabelUpdatedAt => '更新时间';

  @override
  String get brewDetailLabelWater => '水量';

  @override
  String get brewDetailLabelWaterTemp => '水温';

  @override
  String get brewDetailLabelWaterType => '水质';

  @override
  String get brewDetailNotFound => '未找到萃取记录。';

  @override
  String brewDetailQuickScore(int score) {
    return '$score/5';
  }

  @override
  String get brewDetailRatingEmpty => '还没有评分。';

  @override
  String get brewDetailRatingUpdated => '评分已更新。';

  @override
  String get brewDetailSectionBasic => '基础';

  @override
  String get brewDetailSectionBrewParams => '萃取参数';

  @override
  String get brewDetailSectionEnvironment => '环境';

  @override
  String get brewDetailSectionGrind => '研磨';

  @override
  String get brewDetailSectionMeta => '信息';

  @override
  String get brewDetailSectionRating => '评分';

  @override
  String get brewDetailSectionRecordedParams => '参数';

  @override
  String get brewDetailTitle => '萃取详情';

  @override
  String get brewDetailUnrated => '未评分';

  @override
  String get brewEnableMethodInPreferences => '请先在偏好中启用至少一种萃取方式。';

  @override
  String get brewEnableMethodToConfigureParams => '启用一种方式以配置参数。';

  @override
  String get brewErrorInvalidNumber => '请输入有效数字。';

  @override
  String brewErrorValueOutOfRange(double min, double max) {
    return '数值必须在 $min 和 $max 之间。';
  }

  @override
  String get brewErrorValueRequired => '请输入数值。';

  @override
  String get brewGrindModeLabel => '研磨模式';

  @override
  String get brewGrindSimpleCoarse => '较粗';

  @override
  String get brewGrindSimpleExtraCoarse => '极粗';

  @override
  String get brewGrindSimpleExtraFine => '极细';

  @override
  String get brewGrindSimpleFine => '较细';

  @override
  String get brewGrindSimpleMedium => '中';

  @override
  String get brewGrindSimpleMediumCoarse => '中粗';

  @override
  String get brewGrindSimpleMediumFine => '中细';

  @override
  String get brewLabelCoffee => '粉量';

  @override
  String get brewLabelDose => '粉量';

  @override
  String get brewLabelWater => '水量';

  @override
  String get brewLabelYield => '出杯量';

  @override
  String get brewMethodNameEspresso => '意式';

  @override
  String get brewMethodNamePourOver => '手冲';

  @override
  String get brewMethodSelectorLabel => '萃取方式';

  @override
  String get brewMethodsUnavailable => '萃取方式不可用。';

  @override
  String get brewNoParamsConfiguredYet => '该方式暂未配置任何参数。';

  @override
  String get brewParamLabelAgitation => '扰流';

  @override
  String get brewParamLabelBloomTime => '闷蒸时间';

  @override
  String get brewParamLabelBloomWater => '闷蒸水量';

  @override
  String get brewParamLabelBrewRatio => '比例';

  @override
  String get brewParamLabelBrewTime => '萃取时间';

  @override
  String get brewParamLabelCoffeeDose => '粉量';

  @override
  String get brewParamLabelDistributionTamping => '布粉 / 压粉';

  @override
  String get brewParamLabelExtractionTime => '萃取时间';

  @override
  String get brewParamLabelFilterDripper => '滤杯 / 滤纸';

  @override
  String get brewParamLabelGrindSize => '研磨';

  @override
  String get brewParamLabelPourMethod => '注水方式';

  @override
  String get brewParamLabelPreInfusion => '预浸泡时间';

  @override
  String get brewParamLabelPressure => '压力';

  @override
  String get brewParamLabelWaterTemp => '水温';

  @override
  String get brewParamLabelWaterWeight => '水量';

  @override
  String get brewParamLabelYield => '出杯量';

  @override
  String get brewParamTypeNumber => '数字';

  @override
  String get brewParamTypeText => '文本';

  @override
  String get brewPreferencesSectionMethodsSubtitle => '选择哪些方式显示在“萃取”页。';

  @override
  String get brewPreferencesSectionMethodsTitle => '萃取方式';

  @override
  String get brewPreferencesSectionParamsSubtitle => '为每种方式隐藏默认参数或添加自定义参数。';

  @override
  String get brewPreferencesSectionParamsTitle => '参数列表';

  @override
  String get brewPreferencesSubtitle => '设置默认萃取方式与参数列表。';

  @override
  String get brewPreferencesTitle => '记录偏好';

  @override
  String get brewRatingSaved => '评分已保存！';

  @override
  String brewRatioBadge(String ratio) {
    return '1 : $ratio';
  }

  @override
  String get brewRenameCustomMethodSheetTitle => '重命名自定义方式';

  @override
  String get brewSaveActionDisabled => '开始计时后可保存';

  @override
  String get brewSaveActionReady => '保存';

  @override
  String get brewSaveRecordSemantics => '保存萃取记录';

  @override
  String get brewSaveSuccessMessage => '已保存。你可以现在评分，或稍后在历史详情中评分。';

  @override
  String get brewSaveSuccessRateNow => '立即评分';

  @override
  String brewSemanticValue(String label) {
    return '$label 值';
  }

  @override
  String brewSemanticWeight(String label) {
    return '$label 重量';
  }

  @override
  String brewTemplateApplied(String beanName) {
    return '已应用模板：$beanName';
  }

  @override
  String get brewTemplateLoadedFromHistory => '已从历史加载模板';

  @override
  String brewTemplateSubtitle(
    String coffeeGrams,
    String waterGrams,
    String duration,
  ) {
    return '${coffeeGrams}g -> ${waterGrams}g | $duration';
  }

  @override
  String get brewTemplatesUnavailable => '当前暂时无法使用模板。';

  @override
  String get brewTextFieldHintEnterText => '输入文本';

  @override
  String brewTimerAdjustStepTooltip(int seconds) {
    return '调整倒计时 $seconds 秒';
  }

  @override
  String get brewTimerBrew => '萃取';

  @override
  String get brewTimerDecreaseTargetSemantics => '减少倒计时';

  @override
  String brewTimerDecreaseTargetTooltip(int seconds) {
    return '倒计时减少 $seconds 秒';
  }

  @override
  String get brewTimerEnableTargetToUseCountdown => '开启倒计时后可使用倒计时模式';

  @override
  String get brewTimerIncreaseTargetSemantics => '增加倒计时';

  @override
  String brewTimerIncreaseTargetTooltip(int seconds) {
    return '倒计时增加 $seconds 秒';
  }

  @override
  String get brewTimerPause => '暂停';

  @override
  String get brewTimerReset => '重置计时器';

  @override
  String get brewTimerResume => '继续';

  @override
  String get brewTimerSwitchToCountUp => '切换为正计时';

  @override
  String get brewTimerSwitchToCountdown => '切换为倒计时';

  @override
  String get brewTimerTargetOff => '倒计时：关闭';

  @override
  String get brewTimerTargetOn => '关闭倒计时';

  @override
  String brewTimerTargetValue(String time) {
    return '倒计时 $time';
  }

  @override
  String get brewTimerToggleCountdownSemantics => '切换计时模式';

  @override
  String get brewTimerUseTarget => '开启倒计时';

  @override
  String get brewTooltipDeleteParameter => '删除参数';

  @override
  String get brewUntitledBrew => '未命名萃取';

  @override
  String get brewValueLabel => '数值';

  @override
  String brewValueLabelWithUnit(String unit) {
    return '数值（$unit）';
  }

  @override
  String get chipInputAddMore => '继续添加…';

  @override
  String get chipInputHint => '输入后按回车…';

  @override
  String get commonName => '名称';

  @override
  String dateDaysAgo(int count) {
    return '$count 天前';
  }

  @override
  String get dateJustNow => '刚刚';

  @override
  String dateMinutesAgo(int count) {
    return '$count 分钟前';
  }

  @override
  String get dateThisWeek => '本周';

  @override
  String get dateToday => '今天';

  @override
  String dateTodayAt(String time) {
    return '今天 $time';
  }

  @override
  String get dateYesterday => '昨天';

  @override
  String dateYesterdayAt(String time) {
    return '昨天 $time';
  }

  @override
  String get deleteBrewDialogBody => '删除这条萃取记录？此操作不可撤销。';

  @override
  String get deleteBrewDialogTitle => '删除萃取记录';

  @override
  String get flavorNoteBerry => '莓果';

  @override
  String get flavorNoteCaramel => '焦糖';

  @override
  String get flavorNoteChocolate => '巧克力';

  @override
  String get flavorNoteCitrus => '柑橘';

  @override
  String get flavorNoteClean => '干净';

  @override
  String get flavorNoteFloral => '花香';

  @override
  String get flavorNoteHerbal => '草本';

  @override
  String get flavorNoteNutty => '坚果';

  @override
  String get flavorNoteSpice => '香料';

  @override
  String get flavorNoteStoneFruit => '核果';

  @override
  String get flavorNoteTea => '茶感';

  @override
  String get flavorNoteTropical => '热带水果';

  @override
  String get historyEmptyFiltered => '没有记录符合当前筛选条件。';

  @override
  String get historyErrorFilter => '筛选历史失败。';

  @override
  String get historyErrorLoad => '加载历史失败。';

  @override
  String get historyErrorReset => '重置筛选失败。';

  @override
  String get historyFilterAnyDate => '任意日期';

  @override
  String get historyFilterBeanAddAction => '自定义文本';

  @override
  String get historyFilterBeanDialogConfirm => '使用';

  @override
  String get historyFilterBeanDialogHint => '咖啡豆名称';

  @override
  String get historyFilterBeanDialogTitle => '按咖啡豆筛选';

  @override
  String get historyFilterBeanHint => '豆子';

  @override
  String get historyFilterClearTooltip => '清除筛选';

  @override
  String get historyFilterScoreAll => '全部';

  @override
  String get historyFilterScoreHint => '评分';

  @override
  String historyRoasterPrefix(String roaster) {
    return '烘焙商：$roaster';
  }

  @override
  String historySecondsSuffix(int seconds) {
    return '$seconds秒';
  }

  @override
  String get historyStatsAvg => '均分';

  @override
  String get historyStatsBrews => '杯数';

  @override
  String get historyStatsRated => '已评分';

  @override
  String get historyTitle => '萃取历史';

  @override
  String get historyTopBrew => '高分';

  @override
  String inventoryAboutAuthor(String name) {
    return '作者：$name';
  }

  @override
  String get inventoryAboutOpenGithub => '打开 GitHub 仓库';

  @override
  String get inventoryAboutOpenGithubFailed => '无法打开 GitHub 链接。';

  @override
  String get inventoryAboutTitle => '关于 OneBrew';

  @override
  String inventoryAboutVersion(String version) {
    return '版本：$version';
  }

  @override
  String get inventoryAboutVersionLoading => '加载中…';

  @override
  String get inventoryAboutVersionUnavailable => '不可用';

  @override
  String get inventoryActionCreate => '创建';

  @override
  String get inventoryActionDelete => '删除';

  @override
  String get inventoryActionSave => '保存';

  @override
  String get inventoryBeanCreated => '咖啡豆已创建。';

  @override
  String get inventoryBeanFormAddTitle => '新增咖啡豆';

  @override
  String get inventoryBeanFormEditTitle => '编辑咖啡豆';

  @override
  String get inventoryBeanFormLabelName => '咖啡豆名称';

  @override
  String get inventoryBeanFormLabelOrigin => '产地';

  @override
  String get inventoryBeanFormLabelRoastLevel => '烘焙度';

  @override
  String get inventoryBeanFormLabelRoaster => '烘焙商';

  @override
  String get inventoryBeanFormNameRequired => '请输入咖啡豆名称。';

  @override
  String get inventoryBeanUpdated => '咖啡豆已更新。';

  @override
  String get inventoryConflictGrinderNameExists => '已存在同名磨豆机。';

  @override
  String get inventoryDeleteBeanTitle => '删除咖啡豆';

  @override
  String get inventoryDeleteBeanTooltip => '删除咖啡豆';

  @override
  String get inventoryDeleteGrinderTitle => '删除磨豆机';

  @override
  String get inventoryDeleteGrinderTooltip => '删除磨豆机';

  @override
  String inventoryDeletePrompt(String name) {
    return '删除“$name”？';
  }

  @override
  String get inventoryEditBeanTooltip => '编辑咖啡豆';

  @override
  String get inventoryEditGrinderTooltip => '编辑磨豆机';

  @override
  String get inventoryEmptyBeans => '没有找到咖啡豆。';

  @override
  String get inventoryEmptyGrinders => '没有找到磨豆机。';

  @override
  String inventoryErrorWithDetails(String details) {
    return '错误：$details';
  }

  @override
  String get inventoryFabTooltipAddBean => '新增咖啡豆';

  @override
  String get inventoryFabTooltipAddGrinder => '新增磨豆机';

  @override
  String inventoryFailedToDeleteBean(String error) {
    return '删除咖啡豆失败：$error';
  }

  @override
  String inventoryFailedToDeleteGrinder(String error) {
    return '删除磨豆机失败：$error';
  }

  @override
  String inventoryFailedToSaveBean(String error) {
    return '保存咖啡豆失败：$error';
  }

  @override
  String inventoryFailedToSaveGrinder(String error) {
    return '保存磨豆机失败：$error';
  }

  @override
  String inventoryFailedToSaveTag(String tag, String error) {
    return '保存“$tag”失败：$error';
  }

  @override
  String get inventoryGrinderCreated => '磨豆机已创建。';

  @override
  String get inventoryGrinderFormAddTitle => '新增磨豆机';

  @override
  String get inventoryGrinderFormEditTitle => '编辑磨豆机';

  @override
  String get inventoryGrinderFormLabelMaxClick => '最大刻度';

  @override
  String get inventoryGrinderFormLabelMinClick => '最小刻度';

  @override
  String get inventoryGrinderFormLabelName => '名称';

  @override
  String get inventoryGrinderFormLabelStep => '步长';

  @override
  String get inventoryGrinderFormLabelUnit => '单位';

  @override
  String get inventoryGrinderFormNameRequired => '请输入磨豆机名称。';

  @override
  String inventoryGrinderMetaStep(num step) {
    return '步长 $step';
  }

  @override
  String get inventoryGrinderUpdated => '磨豆机已更新。';

  @override
  String get inventoryLanguageTitle => '语言';

  @override
  String inventoryMetaAdded(String date) {
    return '添加于 $date';
  }

  @override
  String inventoryMetaUseCount(int count) {
    return '使用 $count 次';
  }

  @override
  String inventoryQuickGrinderSetupDescription(String tag) {
    return '配置“$tag”。留空将使用默认值。';
  }

  @override
  String get inventoryQuickGrinderSetupLabelMax => '最大';

  @override
  String get inventoryQuickGrinderSetupLabelMin => '最小';

  @override
  String get inventoryQuickGrinderSetupLabelStep => '步长';

  @override
  String get inventoryQuickGrinderSetupLabelUnit => '单位';

  @override
  String get inventoryQuickGrinderSetupSaveGrinder => '保存磨豆机';

  @override
  String get inventoryQuickGrinderSetupTitle => '磨豆机快速设置';

  @override
  String get inventoryQuickGrinderSetupUseDefaults => '使用默认值';

  @override
  String get inventoryQuickGrinderSetupValidationError => '请输入有效的范围和步长。';

  @override
  String get inventorySearchBeansHint => '搜索咖啡豆';

  @override
  String get inventorySearchGrindersHint => '搜索磨豆机';

  @override
  String get inventorySmartTagAddBean => '新增咖啡豆';

  @override
  String get inventorySmartTagAddGrinder => '新增磨豆机';

  @override
  String get inventorySmartTagDialogAddBean => '添加咖啡豆';

  @override
  String get inventorySmartTagDialogAddGrinder => '添加磨豆机';

  @override
  String get inventorySmartTagDialogHintBeanName => '咖啡豆名称';

  @override
  String get inventorySmartTagDialogHintGrinderName => '磨豆机名称';

  @override
  String get inventorySmartTagEmptyBeansYet => '暂无咖啡豆';

  @override
  String get inventorySmartTagEmptyGrindersYet => '暂无磨豆机';

  @override
  String get inventorySmartTagHint => '输入以添加…';

  @override
  String get inventoryTabBeans => '咖啡豆';

  @override
  String get inventoryTabGrinders => '磨豆机';

  @override
  String get inventoryTemplatePickerEmptyHint => '先保存一条萃取记录，再在这里一键复用。';

  @override
  String get inventoryTemplatePickerFooter => '仅显示最近 3 条萃取记录。点按即可复用。';

  @override
  String get inventoryTemplatePickerTitle => '再萃取一次（模板）';

  @override
  String get inventoryTooltipAbout => '关于';

  @override
  String get inventoryTooltipDebugRerunOnboarding => '调试：重新运行引导';

  @override
  String get inventoryTooltipLanguage => '语言';

  @override
  String get inventoryTooltipRecordPreferences => '记录偏好';

  @override
  String get inventoryValidationInvalid => '无效';

  @override
  String get inventoryValidationMustBeGreaterThanMin => '必须大于最小值';

  @override
  String get inventoryValidationMustBeGreaterThanZero => '必须大于 0';

  @override
  String get inventoryValidationRangeTooLarge => '范围过大';

  @override
  String get inventoryValidationRequired => '必填';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSimplifiedChinese => '简体中文';

  @override
  String get languageSystemDefault => '跟随系统';

  @override
  String get navBrew => '萃取';

  @override
  String get navHistory => '历史';

  @override
  String get navManage => '管理';

  @override
  String get onboardingParamListSubtitle => '隐藏默认参数或添加自定义参数。';

  @override
  String get onboardingParamListTitle => '参数列表';

  @override
  String get onboardingPrimaryFinish => '完成';

  @override
  String get onboardingPrimaryNext => '下一步';

  @override
  String get onboardingPrimaryNextMethod => '下一个方式';

  @override
  String get onboardingSkip => '跳过';

  @override
  String get onboardingStepChooseMethodsSubtitle =>
      '至少选择一种方式开始使用。也可以添加自定义方式来匹配你的习惯。';

  @override
  String get onboardingStepChooseMethodsTitle => '选择萃取方式';

  @override
  String get onboardingTagline => 'Focus on one brew at a time.';

  @override
  String get onboardingWelcomeTo => 'Welcome to';

  @override
  String get posterMetricBloom => '闷蒸';

  @override
  String get posterMetricDose => '粉量';

  @override
  String get posterMetricGrind => '研磨';

  @override
  String get posterMetricPour => '注水';

  @override
  String get posterMetricRatio => '比例';

  @override
  String get posterMetricRoom => '室温';

  @override
  String get posterMetricTemp => '水温';

  @override
  String get posterMetricTime => '时间';

  @override
  String get posterMetricWater => '水质';

  @override
  String get posterMetricYield => '出杯';

  @override
  String get posterScoreAcid => '酸';

  @override
  String get posterScoreBitter => '苦';

  @override
  String get posterScoreBody => '醇';

  @override
  String get posterScoreSweet => '甜';

  @override
  String get progressiveExpandShowLess => '收起';

  @override
  String get progressiveExpandShowMore => '展开更多';

  @override
  String get ratingFlavorNotesTitle => '风味';

  @override
  String get ratingLabelAcidity => '酸度';

  @override
  String get ratingLabelBitterness => '苦度';

  @override
  String get ratingLabelBody => '醇厚';

  @override
  String get ratingLabelSweetness => '甜度';

  @override
  String get ratingModeProfessional => '专业';

  @override
  String get ratingModeQuick => '快速';

  @override
  String get ratingMoodTitle => '心情';

  @override
  String get ratingProScoresTitle => '专业评分';

  @override
  String get ratingQuickTitle => '快速评分';

  @override
  String get ratingSave => '保存评分';

  @override
  String get ratingSaving => '保存中…';

  @override
  String get ratingSheetSubtitle => '已保存。你可以快速评分，或记录更详细的风味。';

  @override
  String get ratingSheetTitle => '为这杯打分';

  @override
  String get ratingSkipForNow => '先跳过';

  @override
  String ratingStarTooltip(int star) {
    return '$star 星';
  }

  @override
  String get routeInvalidHistoryDetailId => '无效的历史记录详情 ID。';

  @override
  String sharePreviewSaveFailed(String details) {
    return '保存海报失败：$details';
  }

  @override
  String get sharePreviewSavePoster => '保存海报';

  @override
  String get sharePreviewSaved => '海报已保存到相册。';

  @override
  String get sharePreviewSaving => '保存中…';

  @override
  String get sharePreviewTitle => '分享你的萃取';

  @override
  String get singleSelectAddAction => '新增';

  @override
  String get singleSelectDialogConfirm => '添加';

  @override
  String get singleSelectDialogHint => '名称';

  @override
  String get singleSelectDialogTitle => '添加项目';

  @override
  String get singleSelectEmptyState => '暂无建议项';

  @override
  String get singleSelectHint => '请选择';

  @override
  String get timerPhaseBloom => '闷蒸';

  @override
  String get timerPhaseBrewing => '萃取中';

  @override
  String get timerPhaseDone => '完成 ✓';

  @override
  String get timerPhaseReady => '准备就绪';
}

/// The translations for Chinese, using the Han script (`zh_Hans`).
class AppLocalizationsZhHans extends AppLocalizationsZh {
  AppLocalizationsZhHans() : super('zh_Hans');

  @override
  String get actionAdd => '添加';

  @override
  String get actionBrewAgain => '再萃取一次';

  @override
  String get actionCancel => '取消';

  @override
  String get actionDelete => '删除';

  @override
  String get actionGoBack => '返回';

  @override
  String get actionRetry => '重试';

  @override
  String get actionShare => '分享';

  @override
  String get appTitle => 'OneBrew';

  @override
  String get brewActionAddCustomParameter => '添加自定义参数';

  @override
  String get brewActionAddParameter => '添加参数';

  @override
  String get brewActionApply => '应用';

  @override
  String get brewActionClear => '清除';

  @override
  String get brewAddParamFieldDefaultLabel => '默认值（可选）';

  @override
  String get brewAddParamFieldMaxLabel => '最大值';

  @override
  String get brewAddParamFieldMinLabel => '最小值';

  @override
  String get brewAddParamFieldNameHint => '例如：流速';

  @override
  String get brewAddParamFieldStepLabel => '步长（可选）';

  @override
  String get brewAddParamFieldTypeLabel => '类型';

  @override
  String get brewAddParamFieldUnitHint => '例如：g、ml、bar';

  @override
  String get brewAddParamFieldUnitLabel => '单位（可选）';

  @override
  String get brewAddParamSheetTitle => '新参数';

  @override
  String get brewAddParamValidationDefaultWithinRange => '默认值必须在范围内。';

  @override
  String get brewAddParamValidationMaxGreaterThanMin => '最大值必须大于最小值。';

  @override
  String get brewAddParamValidationMaxRequired => '请输入最大值。';

  @override
  String get brewAddParamValidationMinRequired => '请输入最小值。';

  @override
  String get brewAddParamValidationNameRequired => '请输入名称。';

  @override
  String get brewAddParamValidationStepPositive => '步长必须大于 0。';

  @override
  String brewAdjustDialogTitle(String label) {
    return '调整 $label';
  }

  @override
  String brewAdjustedToNearestStep(String value, String unit) {
    return '已调整到最近的步进：$value$unit';
  }

  @override
  String get brewAdvancedBloomLabel => '闷蒸';

  @override
  String get brewAdvancedBloomSemantic => '闷蒸时间（秒）';

  @override
  String get brewAdvancedCoarsenessHint => '选择粗细';

  @override
  String get brewAdvancedCoarsenessLabel => '粗细';

  @override
  String get brewAdvancedEquipmentLabel => '磨豆机 / 器具';

  @override
  String get brewAdvancedGrindClicksLabel => '刻度';

  @override
  String get brewAdvancedGrindClicksSemantic => '研磨刻度';

  @override
  String get brewAdvancedGrindModeGrinder => '磨豆机';

  @override
  String get brewAdvancedGrindModePro => '专业（μm）';

  @override
  String get brewAdvancedGrindModeSimple => '简易';

  @override
  String get brewAdvancedGrindSizeLabel => '研磨粒径（μm）';

  @override
  String get brewAdvancedPourMethodHint => '例如：螺旋、脉冲、中心';

  @override
  String get brewAdvancedPourMethodLabel => '注水方式';

  @override
  String get brewAdvancedSelectGrinderHint => '选择磨豆机…';

  @override
  String get brewAdvancedTempLabel => '水温';

  @override
  String get brewAdvancedTempSemantic => '水温';

  @override
  String get brewBeanHint => '搜索或添加咖啡豆…';

  @override
  String get brewBeanLabel => '咖啡豆';

  @override
  String get brewCustomMethodDefaultName => '自定义';

  @override
  String get brewCustomMethodDelete => '删除';

  @override
  String brewCustomMethodDisplay(String name) {
    return '自定义方式：$name';
  }

  @override
  String get brewCustomMethodNameHint => '例如：AeroPress';

  @override
  String get brewCustomMethodNameLabel => '方式名称';

  @override
  String get brewCustomMethodRename => '重命名';

  @override
  String get brewCustomMethodSave => '保存';

  @override
  String get brewCustomMethodSheetTitle => '自定义萃取方式';

  @override
  String get brewCustomMethodWantAnother => '需要另一种方式？点此添加';

  @override
  String get brewDetailAddRating => '添加评分';

  @override
  String get brewDetailDeleteFailed => '删除失败。';

  @override
  String get brewDetailDeleteTooltip => '删除记录';

  @override
  String get brewDetailDeleted => '已删除记录。';

  @override
  String get brewDetailEditRating => '编辑评分';

  @override
  String get brewDetailGrindClickUnitDefault => '格';

  @override
  String get brewDetailGrindModeEquipment => '器具';

  @override
  String get brewDetailGrindModePro => '专业';

  @override
  String get brewDetailGrindModeSimple => '简易';

  @override
  String get brewDetailLabelAcidity => '酸度';

  @override
  String get brewDetailLabelBean => '咖啡豆';

  @override
  String get brewDetailLabelBitterness => '苦度';

  @override
  String get brewDetailLabelBloomTime => '闷蒸时间';

  @override
  String get brewDetailLabelBody => '醇厚';

  @override
  String get brewDetailLabelBrewedAt => '萃取时间';

  @override
  String get brewDetailLabelCoffee => '粉量';

  @override
  String get brewDetailLabelCreatedAt => '创建时间';

  @override
  String get brewDetailLabelDuration => '时长';

  @override
  String get brewDetailLabelFlavorNotes => '风味';

  @override
  String get brewDetailLabelGrindClick => '刻度';

  @override
  String get brewDetailLabelGrindEquipment => '器具';

  @override
  String get brewDetailLabelGrindLabel => '描述';

  @override
  String get brewDetailLabelGrindMicrons => '粒径';

  @override
  String get brewDetailLabelGrindMode => '模式';

  @override
  String get brewDetailLabelNotes => '备注';

  @override
  String get brewDetailLabelOrigin => '产地';

  @override
  String get brewDetailLabelPourMethod => '注水方式';

  @override
  String get brewDetailLabelQuick => '快速';

  @override
  String get brewDetailLabelRatio => '比例';

  @override
  String get brewDetailLabelRoastLevel => '烘焙度';

  @override
  String get brewDetailLabelRoaster => '烘焙商';

  @override
  String get brewDetailLabelRoomTemp => '室温';

  @override
  String get brewDetailLabelSweetness => '甜度';

  @override
  String get brewDetailLabelUpdatedAt => '更新时间';

  @override
  String get brewDetailLabelWater => '水量';

  @override
  String get brewDetailLabelWaterTemp => '水温';

  @override
  String get brewDetailLabelWaterType => '水质';

  @override
  String get brewDetailNotFound => '未找到萃取记录。';

  @override
  String brewDetailQuickScore(int score) {
    return '$score/5';
  }

  @override
  String get brewDetailRatingEmpty => '还没有评分。';

  @override
  String get brewDetailRatingUpdated => '评分已更新。';

  @override
  String get brewDetailSectionBasic => '基础';

  @override
  String get brewDetailSectionBrewParams => '萃取参数';

  @override
  String get brewDetailSectionEnvironment => '环境';

  @override
  String get brewDetailSectionGrind => '研磨';

  @override
  String get brewDetailSectionMeta => '信息';

  @override
  String get brewDetailSectionRating => '评分';

  @override
  String get brewDetailSectionRecordedParams => '参数';

  @override
  String get brewDetailTitle => '萃取详情';

  @override
  String get brewDetailUnrated => '未评分';

  @override
  String get brewEnableMethodInPreferences => '请先在偏好中启用至少一种萃取方式。';

  @override
  String get brewEnableMethodToConfigureParams => '启用一种方式以配置参数。';

  @override
  String get brewErrorInvalidNumber => '请输入有效数字。';

  @override
  String brewErrorValueOutOfRange(double min, double max) {
    return '数值必须在 $min 和 $max 之间。';
  }

  @override
  String get brewErrorValueRequired => '请输入数值。';

  @override
  String get brewGrindModeLabel => '研磨模式';

  @override
  String get brewGrindSimpleCoarse => '较粗';

  @override
  String get brewGrindSimpleExtraCoarse => '极粗';

  @override
  String get brewGrindSimpleExtraFine => '极细';

  @override
  String get brewGrindSimpleFine => '较细';

  @override
  String get brewGrindSimpleMedium => '中';

  @override
  String get brewGrindSimpleMediumCoarse => '中粗';

  @override
  String get brewGrindSimpleMediumFine => '中细';

  @override
  String get brewLabelCoffee => '粉量';

  @override
  String get brewLabelDose => '粉量';

  @override
  String get brewLabelWater => '水量';

  @override
  String get brewLabelYield => '出杯量';

  @override
  String get brewMethodNameEspresso => '意式';

  @override
  String get brewMethodNamePourOver => '手冲';

  @override
  String get brewMethodSelectorLabel => '萃取方式';

  @override
  String get brewMethodsUnavailable => '萃取方式不可用。';

  @override
  String get brewNoParamsConfiguredYet => '该方式暂未配置任何参数。';

  @override
  String get brewParamLabelAgitation => '扰流';

  @override
  String get brewParamLabelBloomTime => '闷蒸时间';

  @override
  String get brewParamLabelBloomWater => '闷蒸水量';

  @override
  String get brewParamLabelBrewRatio => '比例';

  @override
  String get brewParamLabelBrewTime => '萃取时间';

  @override
  String get brewParamLabelCoffeeDose => '粉量';

  @override
  String get brewParamLabelDistributionTamping => '布粉 / 压粉';

  @override
  String get brewParamLabelExtractionTime => '萃取时间';

  @override
  String get brewParamLabelFilterDripper => '滤杯 / 滤纸';

  @override
  String get brewParamLabelGrindSize => '研磨';

  @override
  String get brewParamLabelPourMethod => '注水方式';

  @override
  String get brewParamLabelPreInfusion => '预浸泡时间';

  @override
  String get brewParamLabelPressure => '压力';

  @override
  String get brewParamLabelWaterTemp => '水温';

  @override
  String get brewParamLabelWaterWeight => '水量';

  @override
  String get brewParamLabelYield => '出杯量';

  @override
  String get brewParamTypeNumber => '数字';

  @override
  String get brewParamTypeText => '文本';

  @override
  String get brewPreferencesSectionMethodsSubtitle => '选择哪些方式显示在“萃取”页。';

  @override
  String get brewPreferencesSectionMethodsTitle => '萃取方式';

  @override
  String get brewPreferencesSectionParamsSubtitle => '为每种方式隐藏默认参数或添加自定义参数。';

  @override
  String get brewPreferencesSectionParamsTitle => '参数列表';

  @override
  String get brewPreferencesSubtitle => '设置默认萃取方式与参数列表。';

  @override
  String get brewPreferencesTitle => '记录偏好';

  @override
  String get brewRatingSaved => '评分已保存！';

  @override
  String brewRatioBadge(String ratio) {
    return '1 : $ratio';
  }

  @override
  String get brewRenameCustomMethodSheetTitle => '重命名自定义方式';

  @override
  String get brewSaveActionDisabled => '开始计时后可保存';

  @override
  String get brewSaveActionReady => '保存';

  @override
  String get brewSaveRecordSemantics => '保存萃取记录';

  @override
  String get brewSaveSuccessMessage => '已保存。你可以现在评分，或稍后在历史详情中评分。';

  @override
  String get brewSaveSuccessRateNow => '立即评分';

  @override
  String brewSemanticValue(String label) {
    return '$label 值';
  }

  @override
  String brewSemanticWeight(String label) {
    return '$label 重量';
  }

  @override
  String brewTemplateApplied(String beanName) {
    return '已应用模板：$beanName';
  }

  @override
  String get brewTemplateLoadedFromHistory => '已从历史加载模板';

  @override
  String brewTemplateSubtitle(
    String coffeeGrams,
    String waterGrams,
    String duration,
  ) {
    return '${coffeeGrams}g -> ${waterGrams}g | $duration';
  }

  @override
  String get brewTemplatesUnavailable => '当前暂时无法使用模板。';

  @override
  String get brewTextFieldHintEnterText => '输入文本';

  @override
  String brewTimerAdjustStepTooltip(int seconds) {
    return '调整倒计时 $seconds 秒';
  }

  @override
  String get brewTimerBrew => '萃取';

  @override
  String get brewTimerDecreaseTargetSemantics => '减少倒计时';

  @override
  String brewTimerDecreaseTargetTooltip(int seconds) {
    return '倒计时减少 $seconds 秒';
  }

  @override
  String get brewTimerEnableTargetToUseCountdown => '开启倒计时后可使用倒计时模式';

  @override
  String get brewTimerIncreaseTargetSemantics => '增加倒计时';

  @override
  String brewTimerIncreaseTargetTooltip(int seconds) {
    return '倒计时增加 $seconds 秒';
  }

  @override
  String get brewTimerPause => '暂停';

  @override
  String get brewTimerReset => '重置计时器';

  @override
  String get brewTimerResume => '继续';

  @override
  String get brewTimerSwitchToCountUp => '切换为正计时';

  @override
  String get brewTimerSwitchToCountdown => '切换为倒计时';

  @override
  String get brewTimerTargetOff => '倒计时：关闭';

  @override
  String get brewTimerTargetOn => '关闭倒计时';

  @override
  String brewTimerTargetValue(String time) {
    return '倒计时 $time';
  }

  @override
  String get brewTimerToggleCountdownSemantics => '切换计时模式';

  @override
  String get brewTimerUseTarget => '开启倒计时';

  @override
  String get brewTooltipDeleteParameter => '删除参数';

  @override
  String get brewUntitledBrew => '未命名萃取';

  @override
  String get brewValueLabel => '数值';

  @override
  String brewValueLabelWithUnit(String unit) {
    return '数值（$unit）';
  }

  @override
  String get chipInputAddMore => '继续添加…';

  @override
  String get chipInputHint => '输入后按回车…';

  @override
  String get commonName => '名称';

  @override
  String dateDaysAgo(int count) {
    return '$count 天前';
  }

  @override
  String get dateJustNow => '刚刚';

  @override
  String dateMinutesAgo(int count) {
    return '$count 分钟前';
  }

  @override
  String get dateThisWeek => '本周';

  @override
  String get dateToday => '今天';

  @override
  String dateTodayAt(String time) {
    return '今天 $time';
  }

  @override
  String get dateYesterday => '昨天';

  @override
  String dateYesterdayAt(String time) {
    return '昨天 $time';
  }

  @override
  String get deleteBrewDialogBody => '删除这条萃取记录？此操作不可撤销。';

  @override
  String get deleteBrewDialogTitle => '删除萃取记录';

  @override
  String get flavorNoteBerry => '莓果';

  @override
  String get flavorNoteCaramel => '焦糖';

  @override
  String get flavorNoteChocolate => '巧克力';

  @override
  String get flavorNoteCitrus => '柑橘';

  @override
  String get flavorNoteClean => '干净';

  @override
  String get flavorNoteFloral => '花香';

  @override
  String get flavorNoteHerbal => '草本';

  @override
  String get flavorNoteNutty => '坚果';

  @override
  String get flavorNoteSpice => '香料';

  @override
  String get flavorNoteStoneFruit => '核果';

  @override
  String get flavorNoteTea => '茶感';

  @override
  String get flavorNoteTropical => '热带水果';

  @override
  String get historyEmptyFiltered => '没有记录符合当前筛选条件。';

  @override
  String get historyErrorFilter => '筛选历史失败。';

  @override
  String get historyErrorLoad => '加载历史失败。';

  @override
  String get historyErrorReset => '重置筛选失败。';

  @override
  String get historyFilterAnyDate => '任意日期';

  @override
  String get historyFilterBeanAddAction => '自定义文本';

  @override
  String get historyFilterBeanDialogConfirm => '使用';

  @override
  String get historyFilterBeanDialogHint => '咖啡豆名称';

  @override
  String get historyFilterBeanDialogTitle => '按咖啡豆筛选';

  @override
  String get historyFilterBeanHint => '豆子';

  @override
  String get historyFilterClearTooltip => '清除筛选';

  @override
  String get historyFilterScoreAll => '全部';

  @override
  String get historyFilterScoreHint => '评分';

  @override
  String historyRoasterPrefix(String roaster) {
    return '烘焙商：$roaster';
  }

  @override
  String historySecondsSuffix(int seconds) {
    return '$seconds秒';
  }

  @override
  String get historyStatsAvg => '均分';

  @override
  String get historyStatsBrews => '杯数';

  @override
  String get historyStatsRated => '已评分';

  @override
  String get historyTitle => '萃取历史';

  @override
  String get historyTopBrew => '高分';

  @override
  String inventoryAboutAuthor(String name) {
    return '作者：$name';
  }

  @override
  String get inventoryAboutOpenGithub => '打开 GitHub 仓库';

  @override
  String get inventoryAboutOpenGithubFailed => '无法打开 GitHub 链接。';

  @override
  String get inventoryAboutTitle => '关于 OneBrew';

  @override
  String inventoryAboutVersion(String version) {
    return '版本：$version';
  }

  @override
  String get inventoryAboutVersionLoading => '加载中…';

  @override
  String get inventoryAboutVersionUnavailable => '不可用';

  @override
  String get inventoryActionCreate => '创建';

  @override
  String get inventoryActionDelete => '删除';

  @override
  String get inventoryActionSave => '保存';

  @override
  String get inventoryBeanCreated => '咖啡豆已创建。';

  @override
  String get inventoryBeanFormAddTitle => '新增咖啡豆';

  @override
  String get inventoryBeanFormEditTitle => '编辑咖啡豆';

  @override
  String get inventoryBeanFormLabelName => '咖啡豆名称';

  @override
  String get inventoryBeanFormLabelOrigin => '产地';

  @override
  String get inventoryBeanFormLabelRoastLevel => '烘焙度';

  @override
  String get inventoryBeanFormLabelRoaster => '烘焙商';

  @override
  String get inventoryBeanFormNameRequired => '请输入咖啡豆名称。';

  @override
  String get inventoryBeanUpdated => '咖啡豆已更新。';

  @override
  String get inventoryConflictGrinderNameExists => '已存在同名磨豆机。';

  @override
  String get inventoryDeleteBeanTitle => '删除咖啡豆';

  @override
  String get inventoryDeleteBeanTooltip => '删除咖啡豆';

  @override
  String get inventoryDeleteGrinderTitle => '删除磨豆机';

  @override
  String get inventoryDeleteGrinderTooltip => '删除磨豆机';

  @override
  String inventoryDeletePrompt(String name) {
    return '删除“$name”？';
  }

  @override
  String get inventoryEditBeanTooltip => '编辑咖啡豆';

  @override
  String get inventoryEditGrinderTooltip => '编辑磨豆机';

  @override
  String get inventoryEmptyBeans => '没有找到咖啡豆。';

  @override
  String get inventoryEmptyGrinders => '没有找到磨豆机。';

  @override
  String inventoryErrorWithDetails(String details) {
    return '错误：$details';
  }

  @override
  String get inventoryFabTooltipAddBean => '新增咖啡豆';

  @override
  String get inventoryFabTooltipAddGrinder => '新增磨豆机';

  @override
  String inventoryFailedToDeleteBean(String error) {
    return '删除咖啡豆失败：$error';
  }

  @override
  String inventoryFailedToDeleteGrinder(String error) {
    return '删除磨豆机失败：$error';
  }

  @override
  String inventoryFailedToSaveBean(String error) {
    return '保存咖啡豆失败：$error';
  }

  @override
  String inventoryFailedToSaveGrinder(String error) {
    return '保存磨豆机失败：$error';
  }

  @override
  String inventoryFailedToSaveTag(String tag, String error) {
    return '保存“$tag”失败：$error';
  }

  @override
  String get inventoryGrinderCreated => '磨豆机已创建。';

  @override
  String get inventoryGrinderFormAddTitle => '新增磨豆机';

  @override
  String get inventoryGrinderFormEditTitle => '编辑磨豆机';

  @override
  String get inventoryGrinderFormLabelMaxClick => '最大刻度';

  @override
  String get inventoryGrinderFormLabelMinClick => '最小刻度';

  @override
  String get inventoryGrinderFormLabelName => '名称';

  @override
  String get inventoryGrinderFormLabelStep => '步长';

  @override
  String get inventoryGrinderFormLabelUnit => '单位';

  @override
  String get inventoryGrinderFormNameRequired => '请输入磨豆机名称。';

  @override
  String inventoryGrinderMetaStep(num step) {
    return '步长 $step';
  }

  @override
  String get inventoryGrinderUpdated => '磨豆机已更新。';

  @override
  String get inventoryLanguageTitle => '语言';

  @override
  String inventoryMetaAdded(String date) {
    return '添加于 $date';
  }

  @override
  String inventoryMetaUseCount(int count) {
    return '使用 $count 次';
  }

  @override
  String inventoryQuickGrinderSetupDescription(String tag) {
    return '配置“$tag”。留空将使用默认值。';
  }

  @override
  String get inventoryQuickGrinderSetupLabelMax => '最大';

  @override
  String get inventoryQuickGrinderSetupLabelMin => '最小';

  @override
  String get inventoryQuickGrinderSetupLabelStep => '步长';

  @override
  String get inventoryQuickGrinderSetupLabelUnit => '单位';

  @override
  String get inventoryQuickGrinderSetupSaveGrinder => '保存磨豆机';

  @override
  String get inventoryQuickGrinderSetupTitle => '磨豆机快速设置';

  @override
  String get inventoryQuickGrinderSetupUseDefaults => '使用默认值';

  @override
  String get inventoryQuickGrinderSetupValidationError => '请输入有效的范围和步长。';

  @override
  String get inventorySearchBeansHint => '搜索咖啡豆';

  @override
  String get inventorySearchGrindersHint => '搜索磨豆机';

  @override
  String get inventorySmartTagAddBean => '新增咖啡豆';

  @override
  String get inventorySmartTagAddGrinder => '新增磨豆机';

  @override
  String get inventorySmartTagDialogAddBean => '添加咖啡豆';

  @override
  String get inventorySmartTagDialogAddGrinder => '添加磨豆机';

  @override
  String get inventorySmartTagDialogHintBeanName => '咖啡豆名称';

  @override
  String get inventorySmartTagDialogHintGrinderName => '磨豆机名称';

  @override
  String get inventorySmartTagEmptyBeansYet => '暂无咖啡豆';

  @override
  String get inventorySmartTagEmptyGrindersYet => '暂无磨豆机';

  @override
  String get inventorySmartTagHint => '输入以添加…';

  @override
  String get inventoryTabBeans => '咖啡豆';

  @override
  String get inventoryTabGrinders => '磨豆机';

  @override
  String get inventoryTemplatePickerEmptyHint => '先保存一条萃取记录，再在这里一键复用。';

  @override
  String get inventoryTemplatePickerFooter => '仅显示最近 3 条萃取记录。点按即可复用。';

  @override
  String get inventoryTemplatePickerTitle => '再萃取一次（模板）';

  @override
  String get inventoryTooltipAbout => '关于';

  @override
  String get inventoryTooltipDebugRerunOnboarding => '调试：重新运行引导';

  @override
  String get inventoryTooltipLanguage => '语言';

  @override
  String get inventoryTooltipRecordPreferences => '记录偏好';

  @override
  String get inventoryValidationInvalid => '无效';

  @override
  String get inventoryValidationMustBeGreaterThanMin => '必须大于最小值';

  @override
  String get inventoryValidationMustBeGreaterThanZero => '必须大于 0';

  @override
  String get inventoryValidationRangeTooLarge => '范围过大';

  @override
  String get inventoryValidationRequired => '必填';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSimplifiedChinese => '简体中文';

  @override
  String get languageSystemDefault => '跟随系统';

  @override
  String get navBrew => '萃取';

  @override
  String get navHistory => '历史';

  @override
  String get navManage => '管理';

  @override
  String get onboardingParamListSubtitle => '隐藏默认参数或添加自定义参数。';

  @override
  String get onboardingParamListTitle => '参数列表';

  @override
  String get onboardingPrimaryFinish => '完成';

  @override
  String get onboardingPrimaryNext => '下一步';

  @override
  String get onboardingPrimaryNextMethod => '下一个方式';

  @override
  String get onboardingSkip => '跳过';

  @override
  String get onboardingStepChooseMethodsSubtitle =>
      '至少选择一种方式开始使用。也可以添加自定义方式来匹配你的习惯。';

  @override
  String get onboardingStepChooseMethodsTitle => '选择萃取方式';

  @override
  String get onboardingTagline => 'Focus on one brew at a time.';

  @override
  String get onboardingWelcomeTo => 'Welcome to';

  @override
  String get posterMetricBloom => '闷蒸';

  @override
  String get posterMetricDose => '粉量';

  @override
  String get posterMetricGrind => '研磨';

  @override
  String get posterMetricPour => '注水';

  @override
  String get posterMetricRatio => '比例';

  @override
  String get posterMetricRoom => '室温';

  @override
  String get posterMetricTemp => '水温';

  @override
  String get posterMetricTime => '时间';

  @override
  String get posterMetricWater => '水质';

  @override
  String get posterMetricYield => '出杯';

  @override
  String get posterScoreAcid => '酸';

  @override
  String get posterScoreBitter => '苦';

  @override
  String get posterScoreBody => '醇';

  @override
  String get posterScoreSweet => '甜';

  @override
  String get progressiveExpandShowLess => '收起';

  @override
  String get progressiveExpandShowMore => '展开更多';

  @override
  String get ratingFlavorNotesTitle => '风味';

  @override
  String get ratingLabelAcidity => '酸度';

  @override
  String get ratingLabelBitterness => '苦度';

  @override
  String get ratingLabelBody => '醇厚';

  @override
  String get ratingLabelSweetness => '甜度';

  @override
  String get ratingModeProfessional => '专业';

  @override
  String get ratingModeQuick => '快速';

  @override
  String get ratingMoodTitle => '心情';

  @override
  String get ratingProScoresTitle => '专业评分';

  @override
  String get ratingQuickTitle => '快速评分';

  @override
  String get ratingSave => '保存评分';

  @override
  String get ratingSaving => '保存中…';

  @override
  String get ratingSheetSubtitle => '已保存。你可以快速评分，或记录更详细的风味。';

  @override
  String get ratingSheetTitle => '为这杯打分';

  @override
  String get ratingSkipForNow => '先跳过';

  @override
  String ratingStarTooltip(int star) {
    return '$star 星';
  }

  @override
  String get routeInvalidHistoryDetailId => '无效的历史记录详情 ID。';

  @override
  String sharePreviewSaveFailed(String details) {
    return '保存海报失败：$details';
  }

  @override
  String get sharePreviewSavePoster => '保存海报';

  @override
  String get sharePreviewSaved => '海报已保存到相册。';

  @override
  String get sharePreviewSaving => '保存中…';

  @override
  String get sharePreviewTitle => '分享你的萃取';

  @override
  String get singleSelectAddAction => '新增';

  @override
  String get singleSelectDialogConfirm => '添加';

  @override
  String get singleSelectDialogHint => '名称';

  @override
  String get singleSelectDialogTitle => '添加项目';

  @override
  String get singleSelectEmptyState => '暂无建议项';

  @override
  String get singleSelectHint => '请选择';

  @override
  String get timerPhaseBloom => '闷蒸';

  @override
  String get timerPhaseBrewing => '萃取中';

  @override
  String get timerPhaseDone => '完成 ✓';

  @override
  String get timerPhaseReady => '准备就绪';
}
