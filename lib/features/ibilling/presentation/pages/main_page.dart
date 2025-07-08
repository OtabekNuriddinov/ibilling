import '../barrel.dart';

class MainPage extends StatelessWidget {
  final int currentIndex;
  final Widget child;
  const MainPage({super.key, required this.currentIndex, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: CustomBottomAppbar(
        currentIndex: currentIndex,
        onChanged: (index) {
          if (currentIndex != index) {
            String page = switch (index) {
              0 => "/contracts",
              1 => "/history",
              3 => "/saved",
              4 => "/profile",
              _ => "/contracts",
            };
            context.go(page);
          }
        },
        onNewPressed: (){
          AppDialogs.showCreateDialog(context);
        },
      ),
    );
  }
}
