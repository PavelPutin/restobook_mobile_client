import 'package:flutter/material.dart';

import '../../model/entities/table_model.dart';

class ChipsInput<T> extends StatefulWidget {
  const ChipsInput({
    super.key,
    required this.values,
    this.decoration = const InputDecoration(),
    this.style,
    this.strutStyle,
    required this.chipBuilder,
    required this.onChanged,
    this.onTap,
    this.onChipTapped,
    this.onSubmitted,
    this.onTextChanged,
  });

  final List<T> values;
  final InputDecoration decoration;
  final TextStyle? style;
  final StrutStyle? strutStyle;

  final Function()? onTap;

  final ValueChanged<List<T>> onChanged;
  final ValueChanged<T>? onChipTapped;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onTextChanged;

  final Widget Function(BuildContext context, T data) chipBuilder;

  @override
  ChipsInputState<T> createState() => ChipsInputState<T>();
}

class ChipsInputState<T> extends State<ChipsInput<T>> {
  @visibleForTesting
  late final ChipsInputEditingController<T> controller;

  String _previousText = '';
  TextSelection? _previousSelection;

  @override
  void initState() {
    super.initState();

    controller = ChipsInputEditingController<T>(
      <T>[...widget.values],
      widget.chipBuilder,
    );
    controller.addListener(_textListener);
  }

  @override
  void dispose() {
    controller.removeListener(_textListener);
    controller.dispose();

    super.dispose();
  }

  void _textListener() {
    final String currentText = controller.text;

    if (_previousSelection != null) {
      final int currentNumber = countReplacements(currentText);
      final int previousNumber = countReplacements(_previousText);

      final int cursorEnd = _previousSelection!.extentOffset;
      final int cursorStart = _previousSelection!.baseOffset;

      final List<T> values = <T>[...widget.values];

      // If the current number and the previous number of replacements are different, then
      // the user has deleted the InputChip using the keyboard. In this case, we trigger
      // the onChanged callback. We need to be sure also that the current number of
      // replacements is different from the input chip to avoid double-deletion.
      if (currentNumber < previousNumber && currentNumber != values.length) {
        if (cursorStart == cursorEnd) {
          values.removeRange(cursorStart - 1, cursorEnd);
        } else {
          if (cursorStart > cursorEnd) {
            values.removeRange(cursorEnd, cursorStart);
          } else {
            values.removeRange(cursorStart, cursorEnd);
          }
        }
        widget.onChanged(values);
      }
    }

    _previousText = currentText;
    _previousSelection = controller.selection;
  }

  static int countReplacements(String text) {
    return text.codeUnits
        .where(
            (int u) => u == ChipsInputEditingController.kObjectReplacementChar)
        .length;
  }

  @override
  Widget build(BuildContext context) {
    controller.updateValues(<T>[...widget.values]);

    return TextFormField(
      minLines: 1,
      maxLines: 3,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: "Столики"
      ),
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.none,
      style: widget.style,
      strutStyle: widget.strutStyle,
      controller: controller,
      onTap: widget.onTap,
      onChanged: (String value) =>
          widget.onTextChanged?.call(controller.textWithoutReplacements),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Поле обязательное";
        }
        return null;
      },
    );
  }
}

class ChipsInputEditingController<T> extends TextEditingController {
  ChipsInputEditingController(this.values, this.chipBuilder)
      : super(
    text: String.fromCharCode(kObjectReplacementChar) * values.length,
  );

  // This constant character acts as a placeholder in the TextField text value.
  // There will be one character for each of the InputChip displayed.
  static const int kObjectReplacementChar = 0xFFFE;

  List<T> values;

  final Widget Function(BuildContext context, T data) chipBuilder;

  /// Called whenever chip is either added or removed
  /// from the outside the context of the text field.
  void updateValues(List<T> values) {
    if (values.length != this.values.length) {
      final String char = String.fromCharCode(kObjectReplacementChar);
      final int length = values.length;
      value = TextEditingValue(
        text: char * length,
        selection: TextSelection.collapsed(offset: length),
      );
      this.values = values;
    }
  }

  String get textWithoutReplacements {
    final String char = String.fromCharCode(kObjectReplacementChar);
    return text.replaceAll(RegExp(char), '');
  }

  String get textWithReplacements => text;

  @override
  TextSpan buildTextSpan(
      {required BuildContext context,
        TextStyle? style,
        required bool withComposing}) {
    final Iterable<WidgetSpan> chipWidgets =
    values.map((T v) => WidgetSpan(child: chipBuilder(context, v)));

    return TextSpan(
      style: style,
      children: <InlineSpan>[
        ...chipWidgets,
        if (textWithoutReplacements.isNotEmpty)
          TextSpan(text: textWithoutReplacements)
      ],
    );
  }
}

class TableInputChip extends StatelessWidget {
  const TableInputChip({
    super.key,
    required this.table,
    required this.onDeleted,
    required this.onSelected,
  });

  final TableModel table;
  final ValueChanged<TableModel> onDeleted;
  final ValueChanged<TableModel> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 3),
      child: InputChip(
        key: ObjectKey(table),
        label: Text("Стол ${table.number}"),
        avatar: CircleAvatar(
          child: Text(table.number.toString()),
        ),
        onDeleted: () => onDeleted(table),
        onSelected: (bool value) => onSelected(table),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.all(2),
      ),
    );
  }
}