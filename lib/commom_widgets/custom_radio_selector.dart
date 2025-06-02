import 'package:flutter/material.dart';

class CustomRadioSelector<T> extends StatelessWidget {
  final T? selectedValue;
  final List<T> options;
  final Map<T, String> labels;
  final Function(T) onValueChanged;
  final Color? activeColor;
  final Color? activeBackgroundColor;
  final Color? inactiveColor;

  const CustomRadioSelector({
    super.key,
    required this.selectedValue,
    required this.options,
    required this.labels,
    required this.onValueChanged,
    this.activeColor = const Color(0xFF4A74DA),
    this.activeBackgroundColor = const Color.fromARGB(15, 74, 115, 218),
    this.inactiveColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = activeBackgroundColor ?? Colors.grey[200];

    return Row(
      children:
          options.map((option) {
            final isSelected = selectedValue == option;
            final index = options.indexOf(option);

            return Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  right: index < options.length - 1 ? 12.0 : 0.0,
                ),
                child: OutlinedButton(
                  onPressed: () {
                    onValueChanged(option);
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor:
                        isSelected ? backgroundColor : Colors.transparent,
                    side: BorderSide(
                      color: isSelected ? activeColor! : inactiveColor!,
                      width: isSelected ? 2.0 : 1.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: Text(
                    labels[option] ?? option.toString(),
                    style: TextStyle(
                      color: isSelected ? activeColor : Colors.grey[700],
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }
}
