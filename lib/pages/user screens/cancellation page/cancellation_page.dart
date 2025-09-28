import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sneak_peak/pages/user%20screens/cancellation%20page/this%20controller/remove_cancelled_order_riverpod.dart';
import 'package:sneak_peak/pages/user%20screens/cancellation%20page/this%20controller/cancellation_stream_riverpod.dart';
import 'package:sneak_peak/pages/user%20screens/cancellation%20page/widgets/cancellation_card_widget.dart';
import 'package:sneak_peak/pages/user%20screens/cancellation%20page/widgets/no_cancellations_widget.dart';
import 'package:sneak_peak/utils/dialog%20boxes/loading_dialog.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';
import 'package:sneak_peak/widgets/custom%20sliver%20app%20bar/custom_sliverappbar.dart';

class CancellationPage extends ConsumerStatefulWidget {
  const CancellationPage({super.key});
  static const pageName = 'cancellation_page';

  @override
  ConsumerState<CancellationPage> createState() => _CancellationPageState();
}

class _CancellationPageState extends ConsumerState<CancellationPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.invalidate(cancellationStreamProvider));
  }

  @override
  Widget build(BuildContext contextx) {
    print('cancelled pagebuild called');
    ref.listen(removerCancelOrderProvider, (previous, next) {
      if (next!='done' && next!='init') {
        SnackBarHelper.show(next, color: Colors.red);
      }
    },);
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
              leadingOnTap: () => GoRouter.of(context).pop(),
              leadingIcon: CupertinoIcons.back,
              title: 'Cancellations',
            ),
            SliverToBoxAdapter(
              child: Center(
                child: Consumer(
                  builder: (context, x, child) {
                    
                    var cancellations = x.watch(
                      cancellationStreamProvider,
                    );
                    return cancellations.when(
                      data:
                          (data) => ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            reverse: true,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return Slidable(
                                key: ValueKey(data[index].id),
                                endActionPane: ActionPane(
                                  motion: ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (context)async{
                                        loadingDialog(context, 'Deleting cancelled item...', );
                                        var isCanecelled= await ref.read(removerCancelOrderProvider.notifier).removeCancelledOrders(data[index],);
                                        Navigator.pop(contextx);
                                        if (isCanecelled) {
                                          SnackBarHelper.show('Deleted successfully');
                                        }
                                      },
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                      label: 'Delete',
                                    ),
                                  ],
                                ),
                                child: CancellationCardWidget(
                                  cartModal: data[index],
                                  myContext: contextx,
                                ),
                              );
                            },
                          ),
                      error: (error, stackTrace) => Text(error.toString()),
                      loading:
                          () => LoadingAnimationWidget.flickr(
                            leftDotColor: Colors.orange,
                            rightDotColor: Colors.blue,
                            size: 35,
                          ),
                    );
                  },
                ),
              ),
            ),
            const NoCancellationWidget(),
          ],
        ),
      ),
    );
  }
}
