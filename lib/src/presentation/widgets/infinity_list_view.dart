import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_progress_indicator.dart';

class InfinityListView<T> extends StatefulWidget {
  final double? itemExtent;
  final List<T> items;
  final Widget Function(List<T>, int) itemWidget;
  final bool showLoader;
  final Function() fetchNextItems;
  final ScrollController? controller;
  final bool? reverse;
  final EdgeInsetsGeometry? padding;

  const InfinityListView({
    Key? key,
    this.itemExtent,
    required this.items,
    required this.itemWidget,
    required this.showLoader,
    required this.fetchNextItems,
    this.controller,
    this.reverse,
    this.padding
  }) : super(key: key);

  @override
  InfinityListViewState<T> createState() => InfinityListViewState<T>();
}

class InfinityListViewState<T> extends State<InfinityListView<T>> {
  final String _loaderKey = '${UniqueKey().toString()}LoaderKey';

  @override
  void dispose() {
    VisibilityDetectorController.instance.forget(Key(_loaderKey));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      reverse: widget.reverse ?? false,
      padding: widget.padding ?? EdgeInsets.zero,
      itemExtent: widget.itemExtent,
      controller: widget.controller,
      itemCount: widget.items.length + 1,
      itemBuilder: (_, index) {
        if (index < widget.items.length) {
          return widget.itemWidget(
            widget.items, index
          );
        } else {
          return widget.showLoader ?
            VisibilityDetector(
              key: Key(_loaderKey),
              onVisibilityChanged: (info) {
                if (info.visibleFraction > 0) {
                  widget.fetchNextItems();
                }
              },
              child: AppProgressIndicator(size: 25.r)
            ) :
            Container();
        }
      }
    );
  }
}