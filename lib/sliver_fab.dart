library sliver_fab;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A helper class if you want a FloatingActionButton to be pinned in the FlexibleAppBar
class SliverFab extends StatefulWidget {
  ///List of slivers placed in CustomScrollView
  final List<Widget> slivers;

  ///FloatingActionButton placed on the edge of FlexibleAppBar and rest of view
  final Widget floatingActionButton;

  ///Expanded height of FlexibleAppBar
  final double expandedHeight;

  ///Right margin of [floatingActionButton]
  final double marginRight;

  ///Number of pixels from top from which the [floatingActionButton] should start shrinking.
  ///E.g. If your SliverAppBar is pinned, I would recommend this leaving as default 96.0
  ///     If you want [floatingActionButton] to shrink earlier, increase the value.
  final double topScalingEdge;

  ///Whether or not to show the [floatingActionButton]
  final bool visible;

  SliverFab(
      {@required this.slivers,
      @required this.floatingActionButton,
      this.expandedHeight = 256.0,
      this.marginRight = 16.0,
      this.topScalingEdge = 96.0,
      this.visible = true});

  @override
  State<StatefulWidget> createState() {
    return new SliverFabState();
  }
}

class SliverFabState extends State<SliverFab> {
  ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = new ScrollController();
    scrollController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      new CustomScrollView(
        controller: scrollController,
        slivers: widget.slivers,
      ),
    ];

    if (widget.visible) {
      children.add(_buildFab());
    }

    return new Stack(
      children: children
    );
  }

  Widget _buildFab() {
    final double defaultTopMargin = widget.expandedHeight - 4.0;

    double top = defaultTopMargin;
    double scale = 1.0;
    if (scrollController.hasClients) {
      double offset = scrollController.offset;
      top -= offset;
      if (offset < defaultTopMargin - widget.topScalingEdge) {
        scale = 1.0;
      } else if (offset < defaultTopMargin - widget.topScalingEdge / 2) {
        scale = (defaultTopMargin - widget.topScalingEdge / 2 - offset) /
            (widget.topScalingEdge / 2);
      } else {
        scale = 0.0;
      }
    }

    return new Positioned(
      top: top,
      right: widget.marginRight,
      child: new Transform(
        transform: new Matrix4.identity()..scale(scale, scale),
        alignment: Alignment.center,
        child: widget.floatingActionButton,
      ),
    );
  }
}
