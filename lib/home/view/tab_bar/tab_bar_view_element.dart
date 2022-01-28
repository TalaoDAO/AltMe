import 'package:flutter/material.dart';
import 'package:ssi_crypto_wallet/home/view/tab_bar/tab_bar_view_element_header.dart';

class TabBarViewElement extends StatelessWidget {
  const TabBarViewElement(
    this.child,
    this.name, {
    Key? key,
  }) : super(key: key);
  final Widget child;
  final String name;
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      // Setting floatHeaderSlivers to true is required in order to float
      // the outer slivers over the inner scrollable.
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverOverlapAbsorber(
            // This widget takes the overlapping behavior of the SliverAppBar,
            // and redirects it to the SliverOverlapInjector below. If it is
            // missing, then it is possible for the nested "inner" scroll view
            // below to end up under the SliverAppBar even when the inner
            // scroll view thinks it has not been scrolled.
            // This is not necessary if the "headerSliverBuilder" only builds
            // widgets that do not overlap the next sliver
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverPersistentHeader(
              delegate: _HeaderDelegate(),
              floating: true,
              pinned: true,
            ),
          ),
        ];
      },
      body: SafeArea(
        top: false,
        bottom: false,
        child: Builder(
          // This Builder is needed to provide a BuildContext that is
          // "inside" the NestedScrollView, so that
          // sliverOverlapAbsorberHandleFor() can find the
          // NestedScrollView.
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.only(
                right: 20,
                left: 20,
              ),
              child: Container(
                color: Theme.of(context).colorScheme.surface,
                child: CustomScrollView(
                  // The "controller" and "primary" members should be left
                  // unset, so that the NestedScrollView can control this
                  // inner scroll view.
                  // If the "controller" property is set, then this scroll
                  // view will not be associated with the NestedScrollView.
                  // The PageStorageKey should be unique to this ScrollView;
                  // it allows the list to remember its scroll position when
                  // the tab view is not on the screen.
                  key: PageStorageKey<String>(name),
                  slivers: <Widget>[
                    SliverOverlapInjector(
                      // This is the flip side of the SliverOverlapAbsorber
                      // above.
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context,
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      // In this example, the inner scroll view has
                      // fixed-height list items, hence the use of
                      // SliverFixedExtentList. However, one could use any
                      // sliver widget here, e.g. SliverList or SliverGrid.
                      sliver: child,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: const TabBarViewMainContentElementHeader(),
    );
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
