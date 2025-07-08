import 'package:easy_localization/easy_localization.dart';
import 'package:ibilling/core/theme/app_icons.dart';
import 'package:ibilling/features/contracts/presentation/widgets/no_made_widget.dart';
import 'package:ibilling/features/ibilling/data/model/contract_model.dart';
import 'package:ibilling/features/ibilling/data/datasources/ibilling_local_datasource.dart';

import '../barrel.dart';



class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  DateTime? fromDate;
  DateTime? toDate;
  late Future<List<ContractModel>> _savedContractsFuture;

  @override
  void initState() {
    super.initState();
    _savedContractsFuture = IBillingLocalDataSource.getSavedContracts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonMethods.customAppBar(
        backColor: AppColors.darkest,
        context: context,
        filterPressed: () {
          context.go('/contracts/filter');
        },
        iconPressed: () {
          context.go('/contracts/search');
        },
        title: "saved".tr(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
        child: FutureBuilder<List<ContractModel>>(
          future: _savedContractsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: \\${snapshot.error}'));
            }
            final savedContracts = snapshot.data ?? [];
            if (savedContracts.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 12.h),
                  child: NoMadeWidget(
                    text: "No saved contracts",
                    iconUrl: AppIcons.noMadeSaved,
                  ),
                ),
              );
            }
            return ListView.builder(
              padding: EdgeInsets.only(top: 0),
              itemCount: savedContracts.length,
              itemBuilder: (context, index) {
                final contract = savedContracts[index];
                return Material(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(6),
                  child: InkWell(
                    onTap: (){
                      context.go("/saved/saved_contract_details",extra: {
                      "contract": contract,
                      "displayIndex": index + 1,
                      });
                    },
                    child: ContractCard(
                      contract: contract,
                      displayIndex: index + 1,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _selectDate(BuildContext context, bool isFrom) async {
    final picked = await showCustomDatePicker(
      context: context,
      initialDate: isFrom
          ? (fromDate ?? DateTime.now())
          : (toDate ?? DateTime.now()),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          fromDate = picked;
        } else {
          toDate = picked;
        }
      });
    }
  }
}
