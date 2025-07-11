import '../barrel.dart';

class DialogButton extends StatelessWidget {
  final String iconPath;
  final String label;
  final VoidCallback onTap;

  const DialogButton({super.key,
    required this.iconPath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xFF4E4E4E),
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              SvgPicture.asset(iconPath, width: 24, height: 24),
              const SizedBox(width: 12),
              Text(
                label,
                style: AppTextStyles.cardTextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}