import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';
import '../constants/app_durations.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';

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
    this.hintText = 'Type and press Enter…',
    this.maxTags,
    this.enabled = true,
    this.labelText,
    this.singleSelection = false,
    this.onSubmit,
  });

  /// Currently selected tags (controlled)
  final List<String> tags;

  /// Callback when tag list changes
  final ValueChanged<List<String>> onTagsChanged;

  /// Autocomplete suggestions (shown in dropdown)
  final List<String> suggestions;

  /// Input placeholder text
  final String hintText;

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

  @override
  State<AppChipInput> createState() => _AppChipInputState();
}

class _AppChipInputState extends State<AppChipInput> {
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
    }
  }

  void _onTextChanged() {
    final query = _textController.text.trim().toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _filteredSuggestions = [];
        _showSuggestions = false;
      });
      return;
    }
    final filtered = widget.suggestions
        .where(
          (s) => s.toLowerCase().contains(query) && !widget.tags.contains(s),
        )
        .take(6)
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

  @override
  Widget build(BuildContext context) {
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
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            boxShadow: AppColors.debossedShadow,
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
                              ? widget.hintText
                              : 'Add more…',
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
    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        boxShadow: AppColors.softShadow,
      ),
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
                      child: Text(suggestion, style: AppTextStyles.bodyMedium),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
