import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sneak_peak/pages/user%20screens/see%20all%20page/this%20controllers/selected_types_button_riverpod.dart';
import 'package:sneak_peak/pages/user%20screens/see%20all%20page/widget/data_list_widget.dart';
import 'package:sneak_peak/pages/user%20screens/see%20all%20page/widget/outlined_button.dart';
import 'package:sneak_peak/utils/model%20bottom%20sheets/price_hight_to_low_sheet.dart';
import 'package:sneak_peak/widgets/custom%20sliver%20app%20bar/custom_sliverappbar.dart';

class SeeAllPage extends ConsumerStatefulWidget {
  const SeeAllPage({super.key, required this.fileName});
  static const pageName = 'see_all';
  final String fileName;
  @override
  ConsumerState<SeeAllPage> createState() => _SeeAllPageState();
}

class _SeeAllPageState extends ConsumerState<SeeAllPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _appBar(),
            _selectedButton(),

            _isHighOrLow(),

            Consumer(
              builder: (context, y, child) {
                var title = y.watch(selectedButtonProvider);
                return DataListWidget(
                  fileName: widget.fileName,
                  gender: title == 'All' ? '' : title,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _appBar() {
    return CustomSliverAppBar(
      isTrailing: true,
      title:
          (widget.fileName != 'allfeatures') ? widget.fileName : 'All features',
      leadingOnTap: () {
        GoRouter.of(context).pop(context);
      },

      leadingIcon: CupertinoIcons.back,
      // pinned: true,
      trailingIcon: Icons.sort,
      widget: _popupMenuButton(),
      onTrailing: () {
        pricesLowOrHighBottomSheet(
          context,
          lowToHigh:
              () =>
                  ref
                      .read(genderListDataProvider.notifier)
                      .sortByPriceLowToHigh(),
          hightToLow:
              () =>
                  ref
                      .read(genderListDataProvider.notifier)
                      .sortByPriceHighToLow(),
        );
      },
    );
  }

  Widget _popupMenuButton() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'low_high') {
          ref.read(genderListDataProvider.notifier).sortByPriceLowToHigh();
        } else if (value == 'high_low') {
          ref.read(genderListDataProvider.notifier).sortByPriceHighToLow();
        }
      },
      itemBuilder: (BuildContext context) {
        return const [
          PopupMenuItem(value: 'low_high', child: Text('Price: Low to High')),
          PopupMenuItem(value: 'high_low', child: Text('Price: High to Low')),
        ];
      },
      icon: const Icon(Icons.sort),
    );
  }

  Widget _selectedButton() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      sliver: SliverToBoxAdapter(
        child: Wrap(
          spacing: 7,
          children:
              data.map((e) {
                return MyOutlinedButton(
                  isSelected: ref.watch(selectedButtonProvider) == e.name,
                  title: e.name,
                  onClicked: () {
                    ref.read(selectedButtonProvider.notifier).toggeled(e.name);
                  },
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget _isHighOrLow() {
    return SliverPadding(
      padding: EdgeInsets.only(top: 10),
      sliver: SliverToBoxAdapter(
        child: Consumer(
          builder: (context, x, child) {
            var highOrLowTitle = x.watch(genderListDataProvider).highOrLowPrive;
            return highOrLowTitle != ''
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      highOrLowTitle,
                      style: const TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
                : const SizedBox();
          },
        ),
      ),
    );
  }
}

List<({String name, int index})> data = const [
  (name: 'All', index: 0),
  (name: 'Women', index: 1),
  (name: 'Men', index: 2),
  (name: 'Kidz', index: 3),
];
