import 'package:another_stepper/dto/stepper_data.dart';
import 'package:another_stepper/widgets/another_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sneak_peak/models/orders_modals.dart';
import 'package:sneak_peak/pages/admin%20screens/orders%20page/controllers/orders_stream_riverpod.dart';
import 'package:sneak_peak/pages/admin%20screens/view%20orders%20page/controllers/strepper_stream_riverpod.dart';
import 'package:sneak_peak/pages/admin%20screens/view%20orders%20page/controllers/update_steps_riverpod.dart';
import 'package:sneak_peak/utils/constant_steps.dart';
import 'package:sneak_peak/utils/dialog%20boxes/loading_dialog.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';

class AdminStepperWidget extends ConsumerStatefulWidget {
  const AdminStepperWidget({super.key, required this.ordersModals});
  final OrdersModals ordersModals;

  @override
  ConsumerState<AdminStepperWidget> createState() => _AdminStepperWidgetState();
}

class _AdminStepperWidgetState extends ConsumerState<AdminStepperWidget> {
  @override
  Widget build(BuildContext context) {
    print('stepper widget build calld');
    ref.listen(updateStepsProvider, (previous, next) {
      if (next!='done') {
        SnackBarHelper.show(next, color: Colors.red);
      }
    },);
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      sliver: SliverToBoxAdapter(
        child: Consumer(
          builder: (context, x, child) {
            var streamProvider = x.watch(
              stepsStreamProvider(widget.ordersModals.id ?? ''),
            );
            return streamProvider.when(
              data:
                  (data) => AnotherStepper(
                    stepperList: stepperList(data),
                    stepperDirection: Axis.vertical,
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
    );
  }

  List<String> statuses = const [
    preparing,
    dispatched,
    outOfDelivery,
    delivered,
  ];

  List<StepperData> stepperList(String step) {
    int currentIndex = statuses.indexOf(step);

    return List.generate(statuses.length, (index) {
      Color color;
      if (index < currentIndex) {
        color = Colors.green;
      } else if (index == currentIndex) {
        color = (index == 3) ? Colors.green : Colors.orange;
      } else {
        color = Colors.grey;
      }
      Color textColor;
      if (index < currentIndex) {
        textColor = Colors.green;
      } else if (index == currentIndex) {
        textColor =
            (index == 3) ? Colors.green : Theme.of(context).primaryColor;
      } else {
        textColor = Colors.grey;
      }

      String title = "";
      String subtitle = "";

      switch (statuses[index]) {
        case preparing:
          title = preparing;
          subtitle = "Preparing your order.";
          break;
        case dispatched:
          title = dispatched;
          subtitle = "Your parcel has been handed over.";
          break;
        case outOfDelivery:
          title = outOfDelivery;
          subtitle =
              "Delivery partner is on the way to deliver your parcel today.";
          break;
        case delivered:
          title = delivered;
          subtitle = "Your order has been successfully delivered.";
          break;
      }

      return StepperData(
        title: StepperText(
          title,

          textStyle: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        subtitle: StepperText(
          subtitle,
          textStyle: TextStyle(color: textColor, fontSize: 10),
        ),
        iconWidget: GestureDetector(
          onTap: ()async {
            loadingDialog(context, '', color: Colors.transparent);
            await ref.read(updateStepsProvider.notifier).updateStep(widget.ordersModals ,title,widget.ordersModals.userUid ?? '');
            ref.invalidate(adminOrdersStreamProvider);
            Navigator.pop(context);
          },
          child: Icon(Icons.check_circle, color: color),
        ),
      );
    });
  }
}

