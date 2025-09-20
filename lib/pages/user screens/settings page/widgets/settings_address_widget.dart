import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sneak_peak/controllers/users%20controller/address%20riverpod/address_riverpd.dart';
import 'package:sneak_peak/models/address_modal.dart';
import 'package:sneak_peak/pages/user%20screens/address%20page/address_page.dart';

class SettingsAddressWidget extends ConsumerStatefulWidget {
  const SettingsAddressWidget({super.key});

  @override
  ConsumerState<SettingsAddressWidget> createState() => _AddressWidgetState();
}

class _AddressWidgetState extends ConsumerState<SettingsAddressWidget> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(addressProvider.notifier).getAddress());
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Consumer(
        builder: (context, x, _) {
          var address = x.watch(addressProvider);
          return ListTile(
            onTap: () {
              if (address is LoadedSuccessfulyAddressState) {
                if (address.addressModal == null) {
                  GoRouter.of(
                    context,
                  ).pushNamed(AddHomeAddress.pageName, extra: AddressModal());
                } else {
                  GoRouter.of(context).pushNamed(
                    AddHomeAddress.pageName,
                    extra: address.addressModal,
                  );
                }
              }
            },
            leading: CircleAvatar(
              radius: 17,
              backgroundColor: Colors.orange,
              child: Icon(Icons.place_outlined, color: Colors.white, size: 20),
            ),
            title: Text(
              (address is LoadedSuccessfulyAddressState)
                  ? (address.addressModal == null)
                      ? 'Add home address'
                      : 'Update home address'
                  : 'Update home address',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(Icons.arrow_forward_ios_outlined),
          );
        },
      ),
    );
  }
}
