import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../brew_logger/brew_logger_providers.dart';
import '../../../brew_logger/domain/entities/brew_method.dart';
import '../../../brew_logger/domain/entities/brew_param_definition.dart';
import '../../../brew_logger/domain/entities/brew_param_value.dart';
import '../../../brew_logger/domain/repositories/brew_param_repository.dart';
import '../../domain/entities/brew_detail.dart';
import '../../domain/usecases/get_brew_detail.dart';
import '../../history_providers.dart';

class BrewParamEntry {
  const BrewParamEntry({
    required this.name,
    required this.value,
    required this.sortOrder,
  });

  final String name;
  final String value;
  final int sortOrder;
}

class BrewDetailState {
  const BrewDetailState({
    this.isLoading = false,
    this.detail,
    this.paramEntries = const <BrewParamEntry>[],
    this.errorMessage,
  });

  final bool isLoading;
  final BrewDetail? detail;
  final List<BrewParamEntry> paramEntries;
  final String? errorMessage;

  BrewDetailState copyWith({
    bool? isLoading,
    Object? detail = _sentinel,
    List<BrewParamEntry>? paramEntries,
    Object? errorMessage = _sentinel,
  }) {
    return BrewDetailState(
      isLoading: isLoading ?? this.isLoading,
      detail: detail == _sentinel ? this.detail : detail as BrewDetail?,
      paramEntries: paramEntries ?? this.paramEntries,
      errorMessage: errorMessage == _sentinel
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}

const _sentinel = Object();
const Set<String> _durationSemanticParamKeys = {'brewtime', 'extractiontime'};

class BrewDetailController extends Notifier<BrewDetailState> {
  BrewDetailController(this.brewId);

  final int brewId;
  late GetBrewDetail _getBrewDetail;
  late BrewParamRepository _paramRepository;
  Map<int, BrewParamDefinition>? _definitionCacheById;

  @override
  BrewDetailState build() {
    final repository = ref.watch(historyRepositoryProvider);
    _paramRepository = ref.watch(brewParamRepositoryProvider);
    _getBrewDetail = GetBrewDetail(repository);
    Future.microtask(load);
    return const BrewDetailState(isLoading: true);
  }

  Future<void> load() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final detail = await _getBrewDetail(brewId);
      if (detail == null) {
        state = state.copyWith(
          isLoading: false,
          detail: null,
          errorMessage: 'Brew record not found.',
        );
        return;
      }
      final entries = await _loadParamEntries(brewId);
      state = state.copyWith(isLoading: false, detail: detail);
      state = state.copyWith(paramEntries: entries);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        detail: null,
        errorMessage: 'Failed to load brew detail: $e',
      );
    }
  }

  Future<List<BrewParamEntry>> _loadParamEntries(int brewId) async {
    final values = await _paramRepository.getParamValuesForBrew(brewId);
    if (values.isEmpty) return const <BrewParamEntry>[];

    final definitionMap = await _loadDefinitionMapById();
    final entries = <BrewParamEntry>[];
    for (final value in values) {
      var definition = definitionMap[value.paramId];
      if (definition == null) {
        definition = await _paramRepository.getParamDefinitionById(
          value.paramId,
        );
        if (definition != null) {
          definitionMap[value.paramId] = definition;
          _definitionCacheById = definitionMap;
        }
      }
      if (definition == null) continue;
      if (_isDurationSemanticParam(definition.name)) continue;
      final formatted = _formatParamValue(definition, value);
      if (formatted == null) continue;
      entries.add(
        BrewParamEntry(
          name: definition.name,
          value: formatted,
          sortOrder: definition.sortOrder,
        ),
      );
    }

    entries.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return entries;
  }

  Future<Map<int, BrewParamDefinition>> _loadDefinitionMapById() async {
    final cached = _definitionCacheById;
    if (cached != null) {
      return cached;
    }

    final definitionsByMethod = await Future.wait(
      BrewMethod.values.map(_paramRepository.getParamDefinitions),
    );
    final map = <int, BrewParamDefinition>{};
    for (final definitions in definitionsByMethod) {
      for (final definition in definitions) {
        map[definition.id] = definition;
      }
    }
    _definitionCacheById = map;
    return map;
  }

  String? _formatParamValue(
    BrewParamDefinition definition,
    BrewParamValue value,
  ) {
    switch (definition.type) {
      case ParamType.number:
        final number = value.valueNumber;
        if (number == null) return null;
        final formatted = number % 1 == 0
            ? number.toStringAsFixed(0)
            : number.toStringAsFixed(1);
        final unit = definition.unit?.trim();
        return unit == null || unit.isEmpty ? formatted : '$formatted $unit';
      case ParamType.text:
        final text = value.valueText?.trim();
        if (text == null || text.isEmpty) return null;
        return text;
    }
  }

  bool _isDurationSemanticParam(String name) {
    final normalized = name
        .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '')
        .toLowerCase();
    return _durationSemanticParamKeys.contains(normalized);
  }
}

final brewDetailControllerProvider =
    NotifierProvider.family<BrewDetailController, BrewDetailState, int>(
      BrewDetailController.new,
    );
