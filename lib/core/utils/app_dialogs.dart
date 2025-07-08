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
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<int?> languageDialog(BuildContext context, int selectedLang) async {
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
          return selectedLang;
      }
    }

    int selectedLangInDialog = getCurrentLanguageIndex();

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
              padding: EdgeInsets.only(
                top: 2.h,
                bottom: 1.h,
                left: 3.w,
                right: 3.w,
              ),
              child: StatefulBuilder(
                builder: (context, setStateDialog) {
                  return Padding(
                    padding: EdgeInsets.only(right: 4.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Choose a language".tr(),
                          style: AppTextStyles.numberTextStyle,
                        ),
                        SizedBox(height: 1.h),
                        InkWell(
                          borderRadius: BorderRadius.circular(6),
                          onTap: () async {
                            setStateDialog(() {
                              selectedLangInDialog = 0;
                            });
                          },
                          child: Row(
                            children: [
                              SvgPicture.asset(AppIcons.uzbFlag),
                              Text(
                                "O'zbek (Latin)".tr(),
                                style: AppTextStyles.languageTextStyle,
                              ),
                              Spacer(),
                              LanguageOption(
                                selectedLangInDialog: selectedLangInDialog,
                                currentIndex: 0,
                              ),
                            ],
                          ),
                        ),

                        // Russian
                        InkWell(
                          borderRadius: BorderRadius.circular(6),
                          onTap: () async {
                            setStateDialog(() {
                              selectedLangInDialog = 1;
                            });
                          },
                          child: Row(
                            children: [
                              SvgPicture.asset(AppIcons.rusFlag),
                              Text(
                                "Русский".tr(),
                                style: AppTextStyles.languageTextStyle,
                              ),
                              Spacer(),
                              LanguageOption(
                                selectedLangInDialog: selectedLangInDialog,
                                currentIndex: 1,
                              ),
                            ],
                          ),
                        ),

                        // English
                        InkWell(
                          borderRadius: BorderRadius.circular(6),
                          onTap: () async {
                            setStateDialog(() {
                              selectedLangInDialog = 2;
                            });
                          },
                          child: Row(
                            children: [
                              SvgPicture.asset(AppIcons.usaFlag),
                              Text(
                                "English (USA)".tr(),
                                style: AppTextStyles.languageTextStyle,
                              ),
                              Spacer(),
                              LanguageOption(
                                selectedLangInDialog: selectedLangInDialog,
                                currentIndex: 2,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 1.5.h),
                        Padding(
                          padding: EdgeInsets.only(left: 4.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                height: 4.5.h,
                                width: 30.w,
                                child: CustomButton(
                                  text: "Cancel".tr(),
                                  textColor: AppColors.darkGreen,
                                  backColor: AppColors.darkGreen.withAlpha(70),
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                              SizedBox(width: 4.w),
                              SizedBox(
                                height: 4.5.h,
                                width: 30.w,
                                child: CustomButton(
                                  text: "Done".tr(),
                                  textColor: AppColors.white7,
                                  backColor: AppColors.darkGreen,
                                  onTap: () async {
                                    // Faqat til haqiqatan o'zgargan bo'lsa, locale ni o'zgartirish
                                    final currentIndex = getCurrentLanguageIndex();
                                    if (selectedLangInDialog != currentIndex) {
                                      Locale newLocale;
                                      switch (selectedLangInDialog) {
                                        case 0:
                                          newLocale = const Locale('uz');
                                          break;
                                        case 1:
                                          newLocale = const Locale('ru');
                                          break;
                                        case 2:
                                          newLocale = const Locale('en');
                                          break;
                                        default:
                                          newLocale = const Locale('en');
                                      }

                                      // Locale ni o'zgartirish
                                      await context.setLocale(newLocale);

                                      // Local storage ga saqlash
                                      await IBillingLocalDataSource.saveSelectedLangIndex(selectedLangInDialog);
                                    }

                                    Navigator.of(context).pop(selectedLangInDialog);
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
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
                      fontSize: 16,
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


