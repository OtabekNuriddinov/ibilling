import 'package:ibilling/features/contracts/presentation/barrel.dart';

class NoMadeWidget extends StatelessWidget {
  final String text;
  final String iconUrl;
  const NoMadeWidget({
    required this.text,
    required this.iconUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconUrl,
            colorFilter: ColorFilter.mode(
              AppColors.white.withAlpha(100),
              BlendMode.srcIn,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            text,
            style: TextStyle(
              color: AppColors.white.withAlpha(100),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
            ),
          ),
        ],
      );
  }
}