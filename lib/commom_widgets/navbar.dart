import 'package:diainfo/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class Navbar extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTap;
  Navbar({super.key, this.currentIndex = 0, this.onTap});

  final List<PhosphorIconData Function([PhosphorIconsStyle])> navIcons = [
    PhosphorIcons.house,
    PhosphorIcons.mapPin,
    PhosphorIcons.drop,
    PhosphorIcons.pulse,
    PhosphorIcons.user,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      margin: const EdgeInsets.only(right: 24, left: 24, bottom: 48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 20,
            spreadRadius: 8,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(navIcons.length, (index) {
          final isSelected = index == currentIndex;
          return Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: onTap != null ? () => onTap!(index) : null,
              child: Container(
                alignment: Alignment.center,
                child: PhosphorIcon(
                  isSelected
                      ? navIcons[index](PhosphorIconsStyle.fill)
                      : navIcons[index](PhosphorIconsStyle.bold),
                  color: isSelected ? primaryColor : textSecondaryColor,
                  size: 28,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}