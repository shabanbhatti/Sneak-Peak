import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/controllers/search_product_riverpod.dart';

class NoSearchWidget extends ConsumerWidget {
  const NoSearchWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var list = ref.watch(searchProductProvider);
    var searchValue = ref.watch(searchValueProvider);
    return (list.isEmpty && searchValue == '')
        ? const SliverFillRemaining(
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search, color: Colors.orange),
                Text(' Search your shoes here'),
              ],
            ),
          ),
        )
        : (list.isEmpty && searchValue.isNotEmpty)
        ? SliverFillRemaining(
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(child: Icon(Icons.search, color: Colors.orange)),
                Flexible(
                  child: Text(
                    ' No Search found ($searchValue)',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        )
        : SliverToBoxAdapter();
  }
}
