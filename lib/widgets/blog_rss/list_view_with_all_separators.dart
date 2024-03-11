import 'package:flutter/material.dart';

class ListViewWithAllSeparators<T> extends StatelessWidget {
  const ListViewWithAllSeparators(
      {Key? key, required this.items, required this.itemBuilder})
      : super(key: key);
  final List<T> items;
  final Widget Function(BuildContext context, T item) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: items.length + 2,
      separatorBuilder: (_, __) => const Divider(height: 0.5),
      itemBuilder: (context, index) {
        if (index == 0 || index == items.length + 1) {
          return Container(); // zero height: not visible
        }
        return itemBuilder(context, items[index - 1]);
      },
    );
  }
}
