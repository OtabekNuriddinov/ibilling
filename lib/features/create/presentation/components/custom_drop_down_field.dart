import 'package:flutter/material.dart';
import 'package:ibilling/features/contracts/presentation/barrel.dart';

class CustomDropDownField extends StatefulWidget {
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? hint;
  final String? label;
  final String? errorText;

  const CustomDropDownField({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hint,
    this.label,
    this.errorText,
  });

  @override
  State<CustomDropDownField> createState() => _CustomDropDownFieldState();
}

class _CustomDropDownFieldState extends State<CustomDropDownField> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isOpen = false;
  }

  void _showDropdown() {
    if (_isOpen) {
      _removeOverlay();
      return;
    }
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;
    final dropdownHeight = 220.0;

    final spaceBelow = screenHeight - offset.dy - size.height;
    final spaceAbove = offset.dy;

    bool openUpwards = spaceBelow < dropdownHeight && spaceAbove > spaceBelow;

    _overlayEntry = _createOverlayEntry(
      openUpwards: openUpwards,
      buttonOffset: offset,
      buttonSize: size,
    );
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isOpen = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dropdown = CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _showDropdown,
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.black,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: AppColors.white1,
              width: 0.5,
            )
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.value ?? widget.hint ?? '',
                    style: TextStyle(
                      color: widget.value != null
                          ? AppColors.white1
                          : AppColors.white1.withOpacity(0.5),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: const Color(0xFF404040),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isOpen
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.black,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null) ...[
            Text(
              widget.label!,
              style: AppTextStyles.textFieldTextStyle.copyWith(
                color: AppColors.white1,
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
            SizedBox(height: 8),
          ],
          dropdown,
          if (widget.errorText != null) ...[
            SizedBox(height: 6),
            Text(
              widget.errorText!,
              style: TextStyle(color: Colors.red, fontSize: 13),
            ),
          ],
        ],
      ),
    );
  }

  OverlayEntry _createOverlayEntry({required bool openUpwards, required Offset buttonOffset, required Size buttonSize}) {
    return OverlayEntry(
      builder: (context) => Positioned(
        width: buttonSize.width,
        left: buttonOffset.dx,
        top: openUpwards
            ? buttonOffset.dy - 220 - 4
            : buttonOffset.dy + buttonSize.height + 4,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, 0),
          child: Material(
            elevation: 12,
            borderRadius: BorderRadius.circular(8),
            color: AppColors.dark,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 180),
              constraints: BoxConstraints(
                maxHeight: 220,
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: widget.items.length,
                itemBuilder: (context, index) {
                  final item = widget.items[index];
                  final isSelected = widget.value == item;
                  return InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      widget.onChanged(item);
                      _removeOverlay();
                      setState(() {});
                    },
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.darkGreen.withOpacity(0.08) : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              item,
                              style: TextStyle(
                                color: isSelected ? AppColors.darkGreen : Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.darkGreen
                                    : const Color(0xFF666666),
                                width: 2,
                              ),
                            ),
                            child: isSelected
                                ? Center(
                                    child: Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: AppColors.darkGreen,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}