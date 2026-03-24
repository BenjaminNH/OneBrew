import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:one_brew/l10n/l10n.dart';

import '../constants/app_colors.dart';
import '../constants/app_durations.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';
import 'app_input_style.dart';

/// OneBrew Tag/Chip Input with Autocomplete
/// A text field that converts typed input into removable Chip tags.
/// Used for bean names, equipment identifiers, and flavor notes.
///
/// Features:
/// - Ghost text / placeholder
/// - Typed text → Chip on submit (Enter or comma)
/// - Autocomplete dropdown from [suggestions]
/// - Neumorphic debossed field style
///
/// Usage:
/// ```dart
/// AppChipInput(
///   tags: _selectedTags,
///   suggestions: _beanSuggestions,
///   hintText: 'Add coffee bean…',
///   onTagsChanged: (tags) => setState(() => _selectedTags = tags),
/// )
/// ```
class AppChipInput extends StatefulWidget {
  const AppChipInput({
    super.key,
    required this.tags,
    required this.onTagsChanged,
    this.suggestions = const [],
    this.hintText,
    this.maxTags,
    this.enabled = true,
    this.labelText,
    this.singleSelection = false,
    this.onSubmit,
    this.onInputChanged,
    this.suggestionVisibility = AppSuggestionVisibility.enabled,
  });

  /// Currently selected tags (controlled)
  final List<String> tags;

  /// Callback when tag list changes
  final ValueChanged<List<String>> onTagsChanged;

  /// Autocomplete suggestions (shown in dropdown)
  final List<String> suggestions;

  /// Input placeholder text
  final String? hintText;

  /// Maximum number of tags allowed (null = unlimited)
  final int? maxTags;

  /// Whether the input is interactive
  final bool enabled;

  /// Optional label shown above the input
  final String? labelText;

  /// If true, only one tag is allowed at a time (replaces previous)
  final bool singleSelection;

  /// Called when the user submits a value (tag added)
  final Future<void> Function(String)? onSubmit;

  /// Called when the raw input text changes.
  final ValueChanged<String>? onInputChanged;
  final AppSuggestionVisibility suggestionVisibility;

  @override
  State<AppChipInput> createState() => _AppChipInputState();
}

class _AppChipInputState extends State<AppChipInput> {
  static const int _maxVisibleSuggestions = 5;

  late final TextEditingController _textController;
  late final FocusNode _focusNode;
  List<String> _filteredSuggestions = [];
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _focusNode = FocusNode();
    _textController.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (!_focusNode.hasFocus) {
      setState(() => _showSuggestions = false);
      return;
    }
    _updateSuggestions();
  }

  void _onTextChanged() {
    widget.onInputChanged?.call(_textController.text);
    _updateSuggestions();
  }

  @override
  void didUpdateWidget(covariant AppChipInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.suggestions != widget.suggestions ||
        oldWidget.tags != widget.tags) {
      _updateSuggestions();
    }
  }

  void _updateSuggestions() {
    if (!widget.suggestionVisibility.shouldRenderSuggestions) {
      setState(() {
        _filteredSuggestions = [];
        _showSuggestions = false;
      });
      return;
    }

    if (!_focusNode.hasFocus) return;

    final query = _textController.text.trim().toLowerCase();
    final filtered = widget.suggestions
        .where(
          (s) =>
              !widget.tags.contains(s) &&
              (query.isEmpty || s.toLowerCase().contains(query)),
        )
        .take(_maxVisibleSuggestions)
        .toList();
    setState(() {
      _filteredSuggestions = filtered;
      _showSuggestions = filtered.isNotEmpty;
    });
  }

  Future<void> _addTag(String value) async {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return;
    if (widget.tags.contains(trimmed)) {
      _textController.clear();
      widget.onInputChanged?.call('');
      return;
    }
    if (widget.maxTags != null && widget.tags.length >= widget.maxTags!) return;

    final newTags = widget.singleSelection
        ? [trimmed]
        : [...widget.tags, trimmed];

    widget.onTagsChanged(newTags);
    try {
      if (widget.onSubmit != null) {
        await widget.onSubmit!(trimmed);
      }
    } catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'app_chip_input',
          context: ErrorDescription('while handling chip submit callback'),
        ),
      );
    }

    _textController.clear();
    widget.onInputChanged?.call('');
    setState(() {
      _filteredSuggestions = [];
      _showSuggestions = false;
    });
  }

  void _removeTag(String tag) {
    final newTags = widget.tags.where((t) => t != tag).toList();
    widget.onTagsChanged(newTags);
    HapticFeedback.lightImpact();
  }

  bool get _canAddMore =>
      widget.maxTags == null || widget.tags.length < widget.maxTags!;

  BoxBorder _outlineBorder({required bool focused, bool dropTop = false}) {
    final color = focused
        ? AppInputStyle.focusBorderColor
        : AppInputStyle.borderColor;
    final width = focused ? 1.9 : 1.15;
    return Border(
      left: BorderSide(color: color, width: width),
      right: BorderSide(color: color, width: width),
      bottom: BorderSide(color: color, width: width),
      top: dropTop ? BorderSide.none : BorderSide(color: color, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final hasAttachedSuggestions = _showSuggestions;
    final isFocused = _focusNode.hasFocus;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Label ─────────────────────────────────
        if (widget.labelText != null) ...[
          Text(widget.labelText!, style: AppTextStyles.titleSmall),
          const SizedBox(height: AppSpacing.xs),
        ],

        // ── Input + Chips container ────────────────
        Container(
          key: const Key('app-chip-input-field-shell'),
          decoration:
              AppInputStyle.surfaceDecoration(
                backgroundColor: AppInputStyle.shellColor,
                focused: isFocused,
                border: _outlineBorder(focused: isFocused, dropTop: false),
              ).copyWith(
                borderRadius: hasAttachedSuggestions
                    ? const BorderRadius.vertical(
                        top: Radius.circular(AppSpacing.radiusSm),
                      )
                    : AppInputStyle.borderRadius,
              ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final availableWidth = constraints.maxWidth.isFinite
                  ? constraints.maxWidth
                  : MediaQuery.sizeOf(context).width;
              final minInputWidth = availableWidth < 120
                  ? availableWidth
                  : 120.0;
              final maxInputWidth = (availableWidth * 0.55)
                  .clamp(minInputWidth, availableWidth)
                  .toDouble();

              return Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  // Existing tags as chips
                  ...widget.tags.map(_buildChip),

                  // Text input field
                  if (_canAddMore)
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: minInputWidth,
                        maxWidth: maxInputWidth,
                        minHeight: kMinInteractiveDimension,
                      ),
                      child: TextField(
                        controller: _textController,
                        focusNode: _focusNode,
                        enabled: widget.enabled,
                        style: AppTextStyles.inputText,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText: widget.tags.isEmpty
                              ? (widget.hintText ?? l10n.chipInputHint)
                              : l10n.chipInputAddMore,
                          hintStyle: AppTextStyles.inputHint,
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.md,
                          ),
                        ),
                        onSubmitted: (value) {
                          unawaited(_addTag(value));
                        },
                        textInputAction: TextInputAction.done,
                        onChanged: (_) {}, // handled by listener
                      ),
                    ),
                ],
              );
            },
          ),
        ),

        // ── Autocomplete dropdown ──────────────────
        AnimatedSwitcher(
          duration: AppDurations.chipAppear,
          child: _showSuggestions
              ? _buildSuggestionsDropdown()
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildChip(String tag) {
    return AnimatedContainer(
      duration: AppDurations.chipAppear,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: kMinInteractiveDimension),
        child: Chip(
          label: Text(tag, style: AppTextStyles.labelMedium),
          deleteIcon: const Icon(Icons.close, size: 16),
          onDeleted: widget.enabled ? () => _removeTag(tag) : null,
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          side: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.3),
            width: 1,
          ),
          labelPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          materialTapTargetSize: MaterialTapTargetSize.padded,
        ),
      ),
    );
  }

  Widget _buildSuggestionsDropdown() {
    return Transform.translate(
      offset: const Offset(0, -1),
      child: Container(
        key: const Key('app-chip-input-suggestion-panel'),
        decoration:
            AppInputStyle.surfaceDecoration(
              focused: _focusNode.hasFocus,
              backgroundColor: AppInputStyle.shellColor,
              border: _outlineBorder(
                focused: _focusNode.hasFocus,
                dropTop: true,
              ),
            ).copyWith(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(AppSpacing.radiusSm),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowDark.withValues(alpha: 0.14),
                  offset: const Offset(0, 4),
                  blurRadius: 8,
                ),
              ],
            ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 160),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _filteredSuggestions.map((suggestion) {
                return InkWell(
                  onTap: () {
                    unawaited(_addTag(suggestion));
                  },
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minHeight: kMinInteractiveDimension,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.sm,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.coffee,
                            size: AppSpacing.iconSmall,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              suggestion,
                              style: AppTextStyles.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
