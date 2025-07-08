import 'package:easy_localization/easy_localization.dart';
import 'package:ibilling/barrel.dart';
import 'package:ibilling/core/utils/app_dialogs.dart';
import 'package:ibilling/core/utils/app_snackbar.dart';
import 'package:ibilling/features/contracts/presentation/barrel.dart';
import 'package:ibilling/features/ibilling/data/model/contract_model.dart';
import 'package:ibilling/features/ibilling/data/datasources/ibilling_local_datasource.dart';
import 'package:ibilling/features/ibilling/presentation/widgets/contracts_row.dart';

class ContractDetailsPage extends StatefulWidget {
  final ContractModel contract;
  final int displayIndex;
  const ContractDetailsPage({
    super.key,
    required this.contract,
    required this.displayIndex,
  });

  @override
  State<ContractDetailsPage> createState() => _ContractDetailsPageState();
}

class _ContractDetailsPageState extends State<ContractDetailsPage> {

  final TextEditingController controller = TextEditingController();
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    _checkIfSaved();
  }

  Future<void> _checkIfSaved() async {
    final saved = await IBillingLocalDataSource.getSavedContracts();
    setState(() {
      isSaved = saved.any((c) => c.id == widget.contract.id);
    });
  }

  Future<void> _toggleSave() async {
    if (isSaved) {
      await IBillingLocalDataSource.removeSavedContract(widget.contract.id!);
      AppSnackBar.showSnackBar(context, "Removed from saved");
    } else {
      await IBillingLocalDataSource.saveContract(widget.contract);
      AppSnackBar.showSnackBar(context, "Saved");
    }
    _checkIfSaved();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ContractBloc, ContractState>(
        listener: (context, state){
          if (state.status == ContractListStatus.success) {
            AppSnackBar.showSnackBar(context, "contract_successfully_deleted".tr());
            Future.delayed(Duration(milliseconds: 500), () {
              if (mounted) {
                context.go('/contracts');
              }
            });
          }
          if (state.status == ContractListStatus.failure) {
            debugPrint("failed_to_delete_contract".tr());
          }
        },
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          backgroundColor: AppColors.darkest,
          leading: Padding(
            padding: EdgeInsets.only(
              top: 1.6.h,
              bottom: 1.6.h,
              left: 3.6.w,
              right: 0.4.w,
            ),
            child: SvgPicture.asset(AppIcons.paperIcon),
          ),
          title: Text(
            "№ ${widget.contract.id}",
            style: AppTextStyles.tableCalendarDateStyle,
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 2.2.w),
              child: GestureDetector(
                onTap: _toggleSave,
                child: Icon(
                  isSaved ? Icons.bookmark : Icons.bookmark_border,
                  color: AppColors.white4,
                  size: 23.sp,
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 3.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: AppColors.dark,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ContractCardRow(
                            contract: widget.contract,
                            startWord: '${"fishers_full_name".tr()}: ',
                            endWord: widget.contract.fullName,
                          ),
                          SizedBox(height: 1.5.h),
                          ContractCardRow(
                            contract: widget.contract,
                            startWord: '${"status_of_the_contract".tr()}: ',
                            endWord: widget.contract.statusLabel.tr(),
                          ),
                          SizedBox(height: 1.5.h),
                          ContractCardRow(
                            contract: widget.contract,
                            startWord: '${"amount".tr()}: ',
                            endWord: widget.contract.amount,
                          ),
                          SizedBox(height: 1.5.h),
                          ContractCardRow(
                            contract: widget.contract,
                            startWord: '${"last_invoice".tr()}: ',
                            endWord: "№ ${widget.contract.lastInvoiceNumber}",
                          ),
                          SizedBox(height: 1.5.h),
                          ContractCardRow(
                            contract: widget.contract,
                            startWord: '${"number_of_invoices".tr()}: ',
                            endWord: widget.contract.numberOfInvoices.toString(),
                          ),
                          SizedBox(height: 1.5.h),
                          ContractCardRow(
                            contract: widget.contract,
                            startWord: '${"address_of_the_organization".tr()}: ',
                            endWord: widget.contract.address,
                          ),
                          SizedBox(height: 1.5.h),
                          ContractCardRow(
                            contract: widget.contract,
                            startWord: '${"itn_iec_of_the_organization".tr()}: ',
                            endWord: widget.contract.inn,
                          ),
                          SizedBox(height: 1.5.h),
                          ContractCardRow(
                            contract: widget.contract,
                            startWord: '${"created_at".tr()}: ',
                            endWord: DateFormat(
                              'HH:mm, d MMMM, yyyy',
                            ).format(widget.contract.date),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: "delete_contract".tr(),
                        textColor: AppColors.red,
                        backColor: AppColors.red.withAlpha(50),
                        onTap: () async{
                          final comment = await AppDialogs.showDeleteCommentDialog(context);
                          if(comment != null && widget.contract.id != null && mounted){
                            context.read<ContractBloc>().add(DeleteContractEvent(id: widget.contract.id!));
                          }
                        },
                      ),
                    ),
                    SizedBox(width: 4.5.w),
                    Expanded(
                      child: CustomButton(
                        text: "create_contract".tr(),
                        textColor: AppColors.white7,
                        backColor: AppColors.darkGreen,
                        onTap: () {
                          context.go('/new_contract');
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
                Text(
                  "${"other_contracts_with".tr()}\n${widget.contract.fullName}",
                  style: AppTextStyles.numberTextStyle.copyWith(
                    fontSize: 17.sp,
                    color: AppColors.white2,
                  ),
                ),
                SizedBox(height: 1.h),
                BlocBuilder<ContractBloc, ContractState>(
                  builder: (context, state) {
                    final otherContracts = state.contracts
                        .where(
                          (c) =>
                      c.fullName == widget.contract.fullName &&
                          c.id != widget.contract.id,
                    )
                        .toList();
                    if (otherContracts.isEmpty) {
                      return Builder(
                        builder: (context) {
                          return Padding(
                            padding: EdgeInsets.only(left: 26.w, top: 6.h),
                            child: Text(
                              "No other contracts",
                              style: TextStyle(
                                color: AppColors.white.withAlpha(100),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                              ),
                            ),
                          );
                        }
                      );
                    }
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: otherContracts.length,
                      itemBuilder: (context, index) {
                        return ContractCard(
                          contract: ContractModel.fromEntity(
                            otherContracts[index],
                          ),
                          displayIndex: index + 1,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
