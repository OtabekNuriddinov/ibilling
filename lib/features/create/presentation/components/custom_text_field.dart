import 'package:ibilling/features/contracts/presentation/barrel.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final int maxLines;
  final bool hasInfo;
  const CustomTextField({
    super.key,
    required this.controller,
    this.keyboardType,
    this.maxLines = 1,
    this.hasInfo = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: AppTextStyles.textFieldTextStyle.copyWith(
            color: AppColors.white1,
          ),
          cursorColor: AppColors.white1,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.black,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: AppColors.white1, width: 0.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.white1, width: 0.5),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 16),
          ),
        ),
        if (hasInfo)
          Padding(
            padding: EdgeInsets.only(right: 4.w),
            child: SvgPicture.asset(
              "assets/icons/help_circle.svg",
              height: 25,
              width: 25,
            ),
          ),
      ],
    );
  }
}
