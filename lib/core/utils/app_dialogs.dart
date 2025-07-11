import 'package:easy_localization/easy_localization.dart';
import 'package:ibilling/features/contracts/presentation/barrel.dart';
import 'package:ibilling/features/ibilling/presentation/widgets/language_option.dart';
import '../../features/ibilling/presentation/widgets/dialog_button_choose.dart';

sealed class AppDialogs {

  static Future<void> showCreateDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return Dialog(
          backgroundColor: AppColors.dark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "what_do_you_want_to_create".tr(),
                  style: AppTextStyles.numberTextStyle.copyWith(
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 24),
                DialogButton(
                  iconPath: AppIcons.paperIcon,
                  label: "contract".tr(),
                  onTap: () {
                    Navigator.pop(context);
                     context.go("/new_contract");
                  },
                ),
                const SizedBox(height: 12),
                DialogButton(
                  iconPath: AppIcons.receiptIcon,
                  label: "invoice".tr(),
                  onTap: () {
                    Navigator.pop(context);
                    context.go("/new_invoice");
                  },
                ),
                const SizedBox(height: 4),
              ],
            ),
        ));
      },
    );
  }

  static Future<int?> languageDialog(BuildContext context, int selectedLang) async {
    int selectedLangInDialog = selectedLang;

    return await showDialog<int>(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: AppColors.dark,
          child: SizedBox(
            height: 36.h,
            width: 80.w,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
              child: StatefulBuilder(
                builder: (context, setStateDialog) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "choose_language".tr(),
                        style: AppTextStyles.numberTextStyle,
                      ),
                      SizedBox(height: 2.h),

                      _buildLanguageOption(
                        context: context,
                        selectedLangInDialog: selectedLangInDialog,
                        index: 0,
                        icon: AppIcons.uzbFlag,
                        label: "O'zbek (Latin)".tr(),
                        onSelected: () => setStateDialog(() {
                          selectedLangInDialog = 0;
                        }),
                      ),

                      SizedBox(height: 1.2.h),

                      _buildLanguageOption(
                        context: context,
                        selectedLangInDialog: selectedLangInDialog,
                        index: 1,
                        icon: AppIcons.rusFlag,
                        label: "Русский".tr(),
                        onSelected: () => setStateDialog(() {
                          selectedLangInDialog = 1;
                        }),
                      ),

                      SizedBox(height: 1.2.h),

                      _buildLanguageOption(
                        context: context,
                        selectedLangInDialog: selectedLangInDialog,
                        index: 2,
                        icon: AppIcons.usaFlag,
                        label: "English (USA)".tr(),
                        onSelected: () => setStateDialog(() {
                          selectedLangInDialog = 2;
                        }),
                      ),

                      SizedBox(height: 2.5.h),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 4.5.h,
                            width: 30.w,
                            child: CustomButton(
                              text: "cancel".tr(),
                              textColor: AppColors.darkGreen,
                              backColor: AppColors.darkGreen.withAlpha(70),
                              onTap: () => Navigator.of(context).pop(),
                            ),
                          ),
                          SizedBox(width: 20),
                          SizedBox(
                            height: 4.5.h,
                            width: 30.w,
                            child: CustomButton(
                              text: "done".tr(),
                              textColor: AppColors.white7,
                              backColor: AppColors.darkGreen,
                              onTap: () async {
                                Locale newLocale;
                                switch (selectedLangInDialog) {
                                  case 0:
                                    newLocale = const Locale('uz');
                                    break;
                                  case 1:
                                    newLocale = const Locale('ru');
                                    break;
                                  case 2:
                                  default:
                                    newLocale = const Locale('en');
                                }

                                await context.setLocale(newLocale);
                                await IBillingLocalDataSource.saveSelectedLangIndex(selectedLangInDialog);
                                Navigator.of(context).pop(selectedLangInDialog);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }


  /// Reusable method for language option
  static Widget _buildLanguageOption({
    required BuildContext context,
    required int selectedLangInDialog,
    required int index,
    required String icon,
    required String label,
    required VoidCallback onSelected,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onSelected,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 13),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  icon,
                  width: 36,
                  height: 24,
                ),
                SizedBox(width: 12),
                Text(label, style: AppTextStyles.languageTextStyle),
              ],
            ),
            LanguageOption(
              selectedLangInDialog: selectedLangInDialog,
              currentIndex: index,
            ),
          ],
        ),
      ),
    );
  }



  static Future<String?> showDeleteCommentDialog(BuildContext context) async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColors.darkest,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "leave_comment_while".tr(),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.cardTextStyle.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller,
                    maxLines: 3,
                    style: TextStyle(color: AppColors.white),
                    decoration: InputDecoration(
                      hintText: "type_comment".tr(),
                      hintStyle: AppTextStyles.cardTextStyle.copyWith(
                        color: AppColors.white.withAlpha(100),
                        fontWeight: FontWeight.w400,
                      ),
                      filled: true,
                      fillColor: AppColors.dark,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: "cancel".tr(),
                          textColor: AppColors.red,
                          backColor: AppColors.red.withAlpha(40),
                          onTap: () {
                            Navigator.pop(context, null);
                          },
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: CustomButton(
                          text: "done".tr(),
                          textColor: AppColors.white7,
                          backColor: AppColors.red,
                          onTap: () {
                            Navigator.pop(context, controller.text.trim());
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}



