import '../barrel.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color backColor;
  final Function() onTap;
  const CustomButton({
    super.key,
    required this.text,
    required this.textColor,
    required this.backColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: Size(double.maxFinite, 5.h),
            backgroundColor: backColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)
            )
        ),
        onPressed: onTap,
        child: Text(
          text, style: TextStyle(
            color: textColor,
            fontFamily: "Ubuntu",
            fontWeight: FontWeight.w500,
            fontSize: 15.5.sp
        ),)
    );
  }
}

