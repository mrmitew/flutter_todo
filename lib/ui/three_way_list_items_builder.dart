import 'package:flutter/material.dart';

typedef Widget ItemWidgetBuilder<T>(BuildContext context, T item);
typedef Widget PlaceholderWidgetBuilder<T>(BuildContext context);

class ThreeWayListItemsBuilder<T> extends StatelessWidget {
  final List<T> items;
  final ItemWidgetBuilder<T> itemWidgetBuilder;
  final PlaceholderWidgetBuilder<T> placeholderWidgetBuilder;

  const ThreeWayListItemsBuilder({
    Key key,
    this.items,
    this.itemWidgetBuilder,
    this.placeholderWidgetBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (items != null) {
      if (items.length > 0) {
        return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return itemWidgetBuilder(context, items[index]);
            });
      } else {
        return placeholderWidgetBuilder(context);
      }
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }
}

class PlaceholderContent extends StatelessWidget {
  PlaceholderContent({
    this.title: 'Nothing Here',
    this.message: 'Add a new item to get started.',
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          Text(title,
              style: TextStyle(fontSize: 32.0, color: Colors.black54),
              textAlign: TextAlign.center),
          Text(message,
              style: TextStyle(fontSize: 16.0, color: Colors.black54),
              textAlign: TextAlign.center),
        ]));
  }
}
