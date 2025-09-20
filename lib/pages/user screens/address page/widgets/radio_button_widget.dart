import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RadioButtonAddressWidget extends StatelessWidget {
  const RadioButtonAddressWidget({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: [
          Flexible(
            child: Consumer(
              builder: (context, ref, child) {
                var groupValue = ref.watch(addressCheckboxProvider);
                return Radio(
                  activeColor: Colors.orange,
                  value: title,
                  groupValue: groupValue,
                  onChanged: (value) {
                    log('$value');
                    log(groupValue);
                    ref.read(addressCheckboxProvider.notifier).check(value!);
                  },
                );
              },
            ),
          ),
          Flexible(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

final addressCheckboxProvider =
    StateNotifierProvider.autoDispose<AddressCheckBoxNotifier, String>((ref) {
      return AddressCheckBoxNotifier();
    });

class AddressCheckBoxNotifier extends StateNotifier<String> {
  AddressCheckBoxNotifier() : super('');

  void check(String value) {
    state = value;
  }
}
