import 'package:easy_localization/easy_localization.dart';
import '../barrel.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController textController = TextEditingController();
  String query = '';

  @override
  void dispose() {
    super.dispose();
    textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContractBloc, ContractState>(
      builder: (context, state) {
        final contracts = state.contracts;
        final filteredContracts = query.isEmpty
            ? []
            : contracts
                  .where(
                    (contract) =>
                        (contract.fullName.toLowerCase().startsWith(
                          query.toLowerCase(),
                        ) ||
                        contract.inn.toString().startsWith(query)),
                  )
                  .toList();
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.black,
            leading: BackButton(
              color: AppColors.white,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Padding(
              padding: EdgeInsets.only(top: 1.h),
              child: TextField(
                controller: textController,
                cursorColor: AppColors.white,
                style: TextStyle(color: AppColors.white),
                decoration: InputDecoration(
                  border: UnderlineInputBorder(borderSide: BorderSide.none),
                  hintText: "search_by_keywords".tr(),
                  hintStyle: AppTextStyles.cardTextStyle.copyWith(
                    color: AppColors.white.withAlpha(100),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    query = value;
                  });
                },
              ),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 2.7.w),
                child: GestureDetector(
                  onTap: () {
                    textController.clear();
                  },
                  child: Icon(Icons.close, color: AppColors.white),
                ),
              ),
            ],
          ),
          body: filteredContracts.isEmpty
              ? Center(
                  child: NoMadeWidget(
                    text: "no_contracts".tr(),
                    iconUrl: AppIcons.documentIcon,
                  ),
                )
              : ListView.builder(
                  itemCount: filteredContracts.length,
                  itemBuilder: (context, index) {
                    final contract = filteredContracts[index];
                    return ContractCard(
                      onPressed: () {
                        context.go(
                          "/contracts/contract_details",
                          extra: {
                            "contract": contract,
                            "displayIndex": int.tryParse(contract.id ?? "0"),
                          },
                        );
                      },
                      contract: contract,
                      displayIndex: int.tryParse(contract.id ?? '0') ?? 0,
                    );
                  },
                ),
        );
      },
    );
  }
}
