import 'package:easy_localization/easy_localization.dart';
import 'package:ibilling/barrel.dart';

class CustomCheckBox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String text;
  const CustomCheckBox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged?.call(!value),
      borderRadius: BorderRadius.circular(6),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: value ? AppColors.white6 : Colors.white.withAlpha(100),
                width: 1,
              ),
              color: value ? AppColors.white6 : Colors.transparent,
            ),
            child: Center(
              child: Icon(
                Icons.check,
                size: 10,
                color: value ? Colors.black : Colors.white.withAlpha(100),
              ),
            ),
          ),
          SizedBox(width: 8),
          Text(
            text.tr(),
            style: TextStyle(
              color: value
                  ? AppColors.white6
                  : Colors.white.withAlpha(100),
              fontFamily: 'Ubuntu',
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      )
    );
  }
}




