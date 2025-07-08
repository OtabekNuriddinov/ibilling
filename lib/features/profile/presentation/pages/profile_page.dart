import 'package:ibilling/features/contracts/presentation/barrel.dart';
import 'package:ibilling/core/utils/app_dialogs.dart';
import 'package:ibilling/features/ibilling/data/datasources/ibilling_local_datasource.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedLang = 2;

  @override
  void initState() {
    super.initState();
    _loadLang();
  }

  int getCurrentLanguageIndex() {
    final currentLocale = context.locale;
    switch (currentLocale.languageCode) {
      case 'uz':
        return 0;
      case 'ru':
        return 1;
      case 'en':
        return 2;
      default:
        return 2;
    }
  }

  Future<void> _loadLang() async {
    final lang = await IBillingLocalDataSource.loadSelectedIndex();
    setState(() {
      _selectedLang = lang;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentLangIndex = getCurrentLanguageIndex();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkest,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(AppIcons.appBarIcon),
            SizedBox(width: 2.5.w),
            Text("profile".tr(), style: AppTextStyles.appbarTextStyle),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.dark,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.teal,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Otabek Abdusamatov",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
                                fontSize: 17.sp,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "graphic_designer".tr(),
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: AppColors.white2,
                                fontSize: 14.5.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.5.h),
                  _profileInfoRow("${"date_of_birth".tr()}:", "16.09.2001"),
                  SizedBox(height: 1.5.h),
                  _profileInfoRow("${"phone_number".tr()}:", "+998 97 721 06 88"),
                  SizedBox(height: 1.5.h),
                  _profileInfoRow("${"e_mail".tr()}:", "predatorhunter041@gmail.com"),
                ],
              ),
            ),
            SizedBox(height: 1.7.h),
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(6),
                onTap: () async {
                  final result = await AppDialogs.languageDialog(context, currentLangIndex);

                  if (result != null) {
                    setState(() {
                      _selectedLang = result;
                    });
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: AppColors.dark,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 6.w),
                    child: Row(
                      children: [
                        Text(
                          currentLangIndex == 0
                              ? "O'zbek (Latin)"
                              : currentLangIndex == 1
                              ? "Русский"
                              : "English (USA)",
                          style: AppTextStyles.cardTextStyle.copyWith(
                            fontSize: 14.7.sp,
                          ),
                        ),
                        Spacer(),
                        SvgPicture.asset(
                          currentLangIndex == 0
                              ? 'assets/flags/uzbek.svg'
                              : currentLangIndex == 1
                              ? 'assets/flags/russia.svg'
                              : 'assets/flags/usa.svg',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.tr(),
          style: AppTextStyles.cardTextStyle,
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.cardTextStyle.copyWith(
              fontWeight: FontWeight.w400,
              color: AppColors.white.withAlpha(100),
            ),
          ),
        ),
      ],
    );
  }
}
