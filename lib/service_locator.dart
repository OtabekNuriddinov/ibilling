import 'package:ibilling/features/ibilling/domain/usecases/delete_contract.dart';
import 'barrel.dart';

final getIt = GetIt.instance;

Future<void> setUpServiceLocator() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  getIt.registerLazySingleton<IBillingRemoteDataSource>(
    () => IBillingRemoteDataSource(),
  );
  getIt.registerLazySingleton<ContractRepository>(
    () => ContractRepositoryImpl(getIt<IBillingRemoteDataSource>()),
  );
  getIt.registerLazySingleton<InvoiceRepository>(
    () => InvoiceRepositoryImpl(getIt<IBillingRemoteDataSource>()),
  );

  getIt.registerLazySingleton<AddContract>(
    () => AddContract(getIt<ContractRepository>()),
  );
  getIt.registerLazySingleton<GetContracts>(
    () => GetContracts(getIt<ContractRepository>()),
  );

  getIt.registerLazySingleton<AddInvoice>(
    () => AddInvoice(getIt<InvoiceRepository>()),
  );
  getIt.registerLazySingleton<GetInvoices>(
    () => GetInvoices(getIt<InvoiceRepository>()),
  );

  getIt.registerLazySingleton<ContractBloc>(
    () => ContractBloc(
      getIt<AddContract>(),
      getIt<GetContracts>(),
      getIt<DeleteContract>(),
    ),
  );
  getIt.registerLazySingleton<InvoiceBloc>(
    () => InvoiceBloc(getIt<AddInvoice>(), getIt<GetInvoices>()),
  );

  getIt.registerLazySingleton<DeleteContract>(
    () => DeleteContract(contractRepository: getIt()),
  );
}
