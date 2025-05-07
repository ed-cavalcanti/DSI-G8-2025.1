import 'package:diainfo/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String navigateBack;
  const SectionHeader({
    super.key,
    required this.title,
    required this.navigateBack,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, navigateBack);
          },
          child: Container(
            width: 38,
            height: 38,
            margin: EdgeInsets.only(right: 10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: grayStrokeColor, // Define a cor da borda
                width: 2.0, // Define a largura da borda (opcional)
              ),
            ),
            child: PhosphorIcon(
              PhosphorIcons.caretLeft(PhosphorIconsStyle.bold),
              color: textPrimaryColor,
              size: 22.0,
              semanticLabel: 'Voltar para a página anterior',
            ),
          ),
        ),
        Text(title, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}
