import 'package:cached_network_image/cached_network_image.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:movie/actions/adapt.dart';
import 'package:movie/actions/imageurl.dart';
import 'package:movie/models/enums/imagesize.dart';
import 'package:movie/models/imagemodel.dart';
import 'package:movie/style/themestyle.dart';
import 'package:movie/views/detail_page/action.dart';
import 'package:shimmer/shimmer.dart';

import 'state.dart';

Widget buildView(StillState state, Dispatch dispatch, ViewService viewService) {
  Widget _buildStill() {
    return SliverToBoxAdapter(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: Adapt.px(30),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Adapt.px(40)),
              child: Text(
                'Stills',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: Adapt.px(35)),
              ),
            ),
            SizedBox(
              height: Adapt.px(30),
            ),
            Container(
              height: Adapt.px(180),
              child: state.imagesmodel.backdrops.length == 0
                  ? _ShimmerList()
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: Adapt.px(40)),
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (_, __) =>
                          SizedBox(width: Adapt.px(30)),
                      itemCount: state.imagesmodel.backdrops.length,
                      itemBuilder: (_, index) {
                        final d = state.imagesmodel.backdrops[index];
                        return _ImageCell(
                          data: d,
                          index: index,
                          onTap: () => dispatch(
                              MovieDetailPageActionCreator.stillImageTapped(
                                  index)),
                        );
                      }),
            ),
            SizedBox(
              height: Adapt.px(50),
            ),
          ],
        ),
      ),
    );
  }

  return _buildStill();
}

class _ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = ThemeStyle.getTheme(context);
    return Shimmer.fromColors(
        baseColor: _theme.primaryColorDark,
        highlightColor: _theme.primaryColorLight,
        child: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: Adapt.px(40)),
          scrollDirection: Axis.horizontal,
          separatorBuilder: (_, __) => SizedBox(width: Adapt.px(30)),
          itemCount: 3,
          itemBuilder: (_, __) => Container(
            width: Adapt.px(320),
            height: Adapt.px(180),
            decoration: BoxDecoration(
                color: const Color(0xFFEEEEEE),
                borderRadius: BorderRadius.circular(Adapt.px(20))),
          ),
        ));
  }
}

class _ImageCell extends StatelessWidget {
  final int index;
  final ImageData data;
  final Function onTap;
  const _ImageCell({@required this.data, this.index, this.onTap});
  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = ThemeStyle.getTheme(context);
    final String url = ImageUrl.getUrl(data.filePath, ImageSize.w500);
    return GestureDetector(
      key: ValueKey('image${data.filePath}'),
      onTap: onTap,
      child: Hero(
          tag: url + index.toString(),
          child: Container(
            width: Adapt.px(320),
            height: Adapt.px(180),
            decoration: BoxDecoration(
                color: _theme.primaryColorDark,
                borderRadius: BorderRadius.circular(Adapt.px(15)),
                image: DecorationImage(
                    fit: BoxFit.cover, image: CachedNetworkImageProvider(url))),
          )),
    );
  }
}
