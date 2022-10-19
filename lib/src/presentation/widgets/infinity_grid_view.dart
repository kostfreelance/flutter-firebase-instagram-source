import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_progress_indicator.dart';

class InfinityGridView<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(List<T>, int) itemWidget;
  final bool showLoader;
  final Function() fetchNextItems;

  const InfinityGridView({
    Key? key,
    required this.items,
    required this.itemWidget,
    required this.showLoader,
    required this.fetchNextItems
  }) : super(key: key);

  @override
  InfinityGridViewState<T> createState() => InfinityGridViewState<T>();
}

class InfinityGridViewState<T> extends State<InfinityGridView<T>> {
  final String _loaderKey = '${UniqueKey().toString()}LoaderKey';

  @override
  void dispose() {
    VisibilityDetectorController.instance.forget(Key(_loaderKey));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1
      ),
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