import 'package:flutter/material.dart';
import 'package:ibilling/features/ibilling/data/model/contract_model.dart';
import 'package:ibilling/features/ibilling/data/model/invoice_model.dart';
import 'package:ibilling/features/ibilling/domain/entities/contract_entity.dart';
import 'package:ibilling/features/ibilling/domain/entities/invoice_entity.dart';
import '../../domain/repositories/contract_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IBillingRemoteDataSource{
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addContract(ContractEntity contract) async {
    try {
    final contractModel = ContractModel.fromEntity(contract);
    final contractMap = contractModel.toJson();
    final newId = DateTime.now().millisecondsSinceEpoch.toString();
    contractMap['id'] = newId;
      final docRef = await FirebaseFirestore.instance.collection('contracts').add(contractMap);
    } catch (e) {
      debugPrint("Something went wrong: $e");
    }
  }

  Future<List<ContractEntity>> fetchContracts() async {
    try{
      final querySnapshot = await firestore.collection('contracts').get();
      debugPrint('Fetched \\${querySnapshot.docs.length} contracts from Firestore');
      final contracts = querySnapshot.docs
          .map((doc) {
        try {
          final model = ContractModel.fromJson(doc.data());
          debugPrint('Loaded contract: \\${model.fullName}');
          return model;
        } catch (e) {
          debugPrint('Error parsing contract: \\$e');
          return null;
        }
      })
          .whereType<ContractModel>()
          .toList();

      contracts.sort((a, b) => (int.tryParse(b.id ?? '0') ?? 0).compareTo(int.tryParse(a.id ?? '0') ?? 0));

      debugPrint('Returning \\${contracts.length} contracts');
      return contracts;
    }catch(e){
      debugPrint("Error fetching contracts: $e");
      return [];
    }
  }

  Future<void> deleteContract(String id) async {
    try {
      final idStr = id;
      debugPrint("Trying to delete contract with id: $idStr");
      final query = await firestore.collection('contracts').where('id', isEqualTo: idStr).get();
      debugPrint("Found \\${query.docs.length} contracts to delete.");
      for (var doc in query.docs) {
        await doc.reference.delete();
        debugPrint("Deleted contract doc: \\${doc.id}");
      }
      if (query.docs.isEmpty) {
        debugPrint("No contract found with id: $idStr. Check Firestore for id type and value.");
      }
    } catch (e) {
      debugPrint("Something went wrong: $e");
    }
  }

  Future<void> addInvoice(InvoiceEntity invoice) async {
    try {
      final invoiceModel = InvoiceModel.fromEntity(invoice);
      final invoiceMap = invoiceModel.toJson();
      final newId = DateTime
          .now()
          .millisecondsSinceEpoch
          .toString();
      invoiceMap['id'] = newId;

      final docRef = await firestore.collection('invoices').add(invoiceMap);
    }catch(e){
      debugPrint("Something went wrong: $e");
    }
  }

  Future<List<InvoiceEntity>> fetchInvoices() async {
    try{
    final querySnapshot = await firestore.collection('invoices').get();
      final invoices = querySnapshot.docs
          .map((doc) => InvoiceModel.fromJson(doc.data()))
          .toList();
      invoices.sort((a, b) => (int.tryParse(a.id ?? '0') ?? 0).compareTo(int.tryParse(b.id ?? '0') ?? 0));
      return invoices;
    }catch(e){
      debugPrint("Something went wrong: $e");
      rethrow;
    }
  }

}
