import 'package:ibilling/features/contracts/presentation/barrel.dart';

sealed class AppTextStyles {
  static TextStyle tableCalendarDateStyle = TextStyle(
    color: AppColors.white4,
    fontFamily: 'Ubuntu',
    fontSize: 18.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle cardTextStyle = TextStyle(
    color: AppColors.white2,
    fontSize: 15.5.sp,
    fontFamily: 'Ubuntu',
    fontWeight: FontWeight.w500,
  );

  static TextStyle numberTextStyle = TextStyle(
      color: AppColors.white1,
      fontWeight: FontWeight.w700,
      fontSize: 16.sp,
      fontFamily: 'Ubuntu'
  );

  static TextStyle noAreMadeTextStyle = TextStyle(
    color: AppColors.white2,
    fontSize: 16.sp,
    fontFamily: "Poppins",
    fontWeight: FontWeight.w600,
  );

  static TextStyle filterAboveTextStyle = TextStyle(
    color: AppColors.white.withAlpha(100),
    fontWeight: FontWeight.w500,
    fontFamily: 'Ubuntu',
    fontSize: 18.sp,
  );

  static TextStyle appbarTextStyle = TextStyle(
    color: AppColors.white,
    fontSize: 18.sp,
    fontFamily: 'Ubuntu',
    fontWeight: FontWeight.w500,
  );

  static TextStyle aboveTextFieldStyle = TextStyle(
    color: AppColors.white.withAlpha(100),
    fontFamily: 'Ubuntu',
    fontSize: 15.5.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle textFieldTextStyle = TextStyle(
    color: AppColors.white,
    fontFamily: 'Ubuntu',
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle languageTextStyle = TextStyle(
    color: AppColors.white2,
    fontFamily: 'Ubuntu',
    fontSize: 16.5.sp,
    fontWeight: FontWeight.w400,
  );

}
