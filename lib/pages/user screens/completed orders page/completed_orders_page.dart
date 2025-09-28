import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sneak_peak/controllers/cross_fade_anim_riverpod.dart';
import 'package:sneak_peak/pages/user%20screens/completed%20orders%20page/widgets/completed_data_widget.dart';
import 'package:sneak_peak/pages/user%20screens/completed%20orders%20page/widgets/completed_no_data_widget.dart';
import 'package:sneak_peak/pages/user%20screens/to%20ship%20page/controllers/to_ship_stream_riverpod.dart';
import 'package:sneak_peak/widgets/custom%20sliver%20app%20bar/custom_sliverappbar.dart';

class CompletedPage extends ConsumerStatefulWidget {
  const CompletedPage({super.key});
  static const pageName = 'completed_orders';

  @override
  ConsumerState<CompletedPage> createState() => _CompletedPageState();
}

class _CompletedPageState extends ConsumerState<CompletedPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(crossFadeProvider.notifier).toggeled();
      ref.invalidate(toShipStreamProvider);
    });
  }

  @override
  Widget build(BuildContext contextX) {
    print('Completed order page build called');
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 5,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Center(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            CustomSliverAppBar(
              leadingOnTap: () => GoRouter.of(contextX).pop(),
              leadingIcon: CupertinoIcons.back,
              title: 'Completed orders history',
            ),
            const CompletedDataWidget(),
            const CompletedNoDataWidget(),
          ],
        ),
      ),
    );
  }
}
