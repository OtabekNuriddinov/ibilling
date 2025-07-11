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
      listener: (context, state) async{
        if (state.status == ContractListStatus.success && state.lastAction == ContractAction.delete) {
          await IBillingLocalDataSource.removeSavedContract(widget.contract.id!);
          AppSnackBar.showSnackBar(
            context,
            "contract_successfully_deleted".tr(),
          );
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
          padding: EdgeInsets.only(left: 16, right: 16),
          child: ListView(
            children: [
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 310,
                decoration: BoxDecoration(
                  color: AppColors.dark,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ContractCardRow(
                        contract: widget.contract,
                        startWord: "fishers_full_name".tr(),
                        endWord: widget.contract.fullName,
                      ),
                      const SizedBox(height: 12),
                      ContractCardRow(
                        contract: widget.contract,
                        startWord: "status_of_the_contract".tr(),
                        endWord: CommonMethods.statusLabelToKey(
                          widget.contract.statusLabel,
                        ).tr(),
                      ),
                      const SizedBox(height: 12),
                      ContractCardRow(
                        contract: widget.contract,
                        startWord: "amount".tr(),
                        endWord: widget.contract.amount,
                      ),
                      const SizedBox(height: 12),
                      ContractCardRow(
                        contract: widget.contract,
                        startWord: "last_invoice".tr(),
                        endWord: "№ ${widget.contract.lastInvoiceNumber}",
                      ),
                      const SizedBox(height: 12),
                      ContractCardRow(
                        contract: widget.contract,
                        startWord: "number_of_invoices".tr(),
                        endWord: widget.contract.numberOfInvoices.toString(),
                      ),
                      const SizedBox(height: 12),
                      ContractCardRow(
                        contract: widget.contract,
                        startWord: "address_of_the_organization".tr(),
                        endWord: widget.contract.address,
                      ),
                      const SizedBox(height: 12),
                      ContractCardRow(
                        contract: widget.contract,
                        startWord: "itn_iec_of_the_organization".tr(),
                        endWord: widget.contract.inn,
                      ),
                      const SizedBox(height: 12),
                      ContractCardRow(
                        contract: widget.contract,
                        startWord: "created_at".tr(),
                        endWord: DateFormat(
                          'HH:mm, d MMMM, yyyy',
                        ).format(widget.contract.date),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: "delete_contract".tr(),
                      textColor: AppColors.red,
                      backColor: AppColors.red.withAlpha(50),
                      onTap: () async {
                        final comment =
                        await AppDialogs.showDeleteCommentDialog(context);
                        if (!mounted) return;
                        if (comment != null &&
                            widget.contract.id != null && comment.trim().isNotEmpty) {
                          context.read<ContractBloc>().add(
                            DeleteContractEvent(id: widget.contract.id!),
                          );
                        }
                        else if(comment!=null && comment.trim().isEmpty){
                          AppSnackBar.showSnackBar(context, "Please write a comment before deleting");
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
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
              const SizedBox(height: 40),
              if(context.locale == Locale('uz'))
                Text(
                  "${widget.contract.fullName} ning\n${"other_contracts_with".tr()}",
                  style: AppTextStyles.numberTextStyle.copyWith(
                    fontSize: 17.sp,
                    color: AppColors.white2,
                  ),
                )
              else
                Text(
                  "${"other_contracts_with".tr()}\n${widget.contract.fullName}",
                  style: AppTextStyles.numberTextStyle.copyWith(
                    fontSize: 17.sp,
                    color: AppColors.white2,
                  ),
                ),

              const SizedBox(height: 20),
              BlocBuilder<ContractBloc, ContractState>(
                builder: (context, state) {
                  final otherContracts = state.contracts
                      .where(
                        (c) =>
                    c.fullName.trim().toLowerCase() ==
                        widget.contract.fullName
                            .trim()
                            .toLowerCase() &&
                        c.id != widget.contract.id,
                  )
                      .toList();
                  if (state.isLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (otherContracts.isEmpty) {
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
                  return ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: otherContracts.length,
                    separatorBuilder: (_, __) => SizedBox(height: 1.h),
                    itemBuilder: (context, index) {
                      final contract = otherContracts[index];
                      return ContractCard(
                        contract: ContractModel.fromEntity(contract),
                        displayIndex: int.tryParse(contract.id ?? '0') ?? 0,
                        onPressed: () {
                          context.go('/contracts/contract_details', extra: {
                            'contract': contract,
                            'displayIndex': int.tryParse(contract.id??"0") ?? 0
                          });
                        },
                      );
                    },
                  );
                },
              ),
            ],
          )
        ),
      ),
    );
  }
}
