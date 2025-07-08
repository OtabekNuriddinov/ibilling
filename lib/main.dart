import 'package:easy_localization/easy_localization.dart';
import 'package:ibilling/app.dart';
import 'barrel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await setUpServiceLocator();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<ContractBloc>()),
        BlocProvider(create: (context) => getIt<InvoiceBloc>()),
      ],
      child: EasyLocalization(
        supportedLocales: [Locale('uz'), Locale('en'), Locale('ru')],
        path: "assets/translations",
        fallbackLocale: Locale('en'),
        child: const IBilling(),
      ),
    ),
  );
}
