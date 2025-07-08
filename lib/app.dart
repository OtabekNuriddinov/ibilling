import 'package:easy_localization/easy_localization.dart';
import 'barrel.dart';

class IBilling extends StatelessWidget {
  const IBilling({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: (context, orientation, type){
          return MaterialApp.router(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            debugShowCheckedModeBanner: false,
            routerConfig: router,
            theme: ThemeData(
                scaffoldBackgroundColor: AppColors.black
            ),
          );
        }
    );
  }
}