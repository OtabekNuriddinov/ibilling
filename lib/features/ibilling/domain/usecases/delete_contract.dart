
import 'package:dartz/dartz.dart';
import 'package:ibilling/barrel.dart';
import 'package:ibilling/core/error/failure.dart';

class DeleteContract{
  final ContractRepository contractRepository;

  DeleteContract({required this.contractRepository});

  Future<Either<Failure,void>> call(String id)async{
    return await contractRepository.deleteContract(id);
  }
}