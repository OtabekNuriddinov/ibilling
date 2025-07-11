import 'package:easy_localization/easy_localization.dart';
import '../barrel.dart';

class CustomBottomAppbar extends StatelessWidget {
  final Function(int) onChanged;
  final int currentIndex;
  final VoidCallback? onNewPressed;
  const CustomBottomAppbar({super.key, required this.onChanged, required this.currentIndex, this.onNewPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10.h,
      decoration: BoxDecoration(color: AppColors.darkest),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(5, (index) {
            String iconSelected;
            String unselectedIcon;
            String label;
            switch (index) {
              case 0: 
                iconSelected = AppIcons.contractsIcon;
                unselectedIcon = AppIcons.contractsIconUnselected;
                label = "contracts".tr();
                break;
              case 1:
                iconSelected = AppIcons.historyIcon;
                unselectedIcon = AppIcons.historyIconUnselected;
                label = "history".tr();
                break;
              case 2:
                iconSelected = AppIcons.newIcon;
                unselectedIcon = AppIcons.newIconUnSelected;
                label = "new".tr();
                break;
              case 3:
                iconSelected = AppIcons.savedIcon;
                unselectedIcon = AppIcons.savedIconUnSelected;
                label = "saved".tr();
                break;
              case 4:
                iconSelected = AppIcons.profileIcon;
                unselectedIcon = AppIcons.profileIconUnSelected;
                label = "profile".tr();
                break;
              default:
                iconSelected = AppIcons.contractsIcon;
                unselectedIcon = AppIcons.contractsIconUnselected;
                label = "Unknown";
                break;
            }
            final isSelected = currentIndex == index;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  if (index == 2 && onNewPressed != null) {
                    onNewPressed!();
                  } else {
                    onChanged(index);
                  }
                },
                child: TweenAnimationBuilder(
                  tween: Tween<double>(begin: 1.0, end: isSelected ? 1.1 : 1.0),
                  duration: const Duration(milliseconds: 200),
                  builder: (context, scale, child) {
                    return Transform.scale(
                      scale: scale,
                      child: InkWell(
                        onTap: () {
                          if (index == 2 && onNewPressed != null) {
                            onNewPressed!();
                          } else {
                            onChanged(index);
                          }
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            isSelected
                                ? SvgPicture.asset(iconSelected)
                                : SvgPicture.asset(unselectedIcon),
                            SizedBox(height: 0.1.h),
                            Text(
                              label,
                              style: TextStyle(
                                fontFamily: "Ubuntu",
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.white.withAlpha(120),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
