
import 'package:ibilling/barrel.dart';

class DeleteContract{
  final ContractRepository contractRepository;

  DeleteContract({required this.contractRepository});

  Future<void> call(String id)async{
    await contractRepository.deleteContract(id);
  }
}