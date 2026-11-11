import 'package:BabyCentric/application/app_colors.dart';
import 'package:flutter/material.dart';

class SizePickerWidget extends StatefulWidget {
  const SizePickerWidget({super.key, required this.sizes});
  final List<String> sizes;
  @override
  State<SizePickerWidget> createState() => _SizePickerWidgetState();
}

class _SizePickerWidgetState extends State<SizePickerWidget> {
  String? _selectedSize;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: getSizeItems()),
    );
  }

  List<Widget> getSizeItems() {
    List<Widget> _sizeList = [];
    for (String size in widget.sizes) {
      _sizeList.add(
        getColorItemWidget(
          sizeText: size,
          onTap: () {
            _selectedSize = size;
            setState(() {});
          },
          isSelected: _selectedSize == size,
        ),
      );
    }
    return _sizeList;
  }

  Widget getColorItemWidget({
    required String sizeText,
    required VoidCallback onTap,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.themeColor : null,
          shape: BoxShape.circle,
          border: Border.all(width: 1, style: BorderStyle.solid),
        ),
        child: Text(
          sizeText,
          style: TextStyle(
            color: isSelected ? Colors.white : null,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
