import 'package:cached_network_image/cached_network_image.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:movie/actions/adapt.dart';
import 'package:movie/actions/imageurl.dart';
import 'package:movie/generated/i18n.dart';
import 'package:movie/models/enums/imagesize.dart';
import 'package:movie/models/videolist.dart';
import 'package:movie/style/themestyle.dart';
import 'package:shimmer/shimmer.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    PopularPosterState state, Dispatch dispatch, ViewService viewService) {
  final TextStyle _selectPopStyle = TextStyle(
    fontSize: Adapt.px(24),
    fontWeight: FontWeight.bold,
  );

  final TextStyle _unselectPopStyle =
      TextStyle(fontSize: Adapt.px(24), color: const Color(0xFF9E9E9E));

  final ThemeData _theme = ThemeStyle.getTheme(viewService.context);
  Widget _buildFrontTitel(String title, Widget action,
      {EdgeInsetsGeometry padding =
          const EdgeInsets.symmetric(horizontal: 20)}) {
    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                //color: Colors.black,
                fontSize: Adapt.px(35),
                fontWeight: FontWeight.bold),
          ),
          action
        ],
      ),
    );
  }

  Widget _buildMoreCell() {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: _theme.primaryColorLight,
            borderRadius: BorderRadius.circular(Adapt.px(15)),
          ),
          width: Adapt.px(250),
          height: Adapt.px(350),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  I18n.of(viewService.context).more,
                  style: TextStyle(fontSize: Adapt.px(35)),
                ),
                Icon(Icons.arrow_forward, size: Adapt.px(35))
              ]),
        )
      ],
    );
  }

  Widget _buildbody() {
    VideoListModel model =
        state.showmovie ? state.popularMoives : state.popularTVShows;
    return AnimatedSwitcher(
        transitionBuilder: (widget, animated) {
          return SlideTransition(
            position:
                animated.drive(Tween(begin: Offset(1, 0), end: Offset.zero)),
            child: widget,
          );
        },
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeOut,
        duration: Duration(milliseconds: 300),
        child: Container(
          key: ValueKey(model),
          height: Adapt.px(450),
          child: model.results.length > 0
              ? ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: Adapt.px(30)),
                  scrollDirection: Axis.horizontal,
                  physics: PageScrollPhysics(),
                  shrinkWrap: true,
                  separatorBuilder: (_, index) => SizedBox(width: Adapt.px(30)),
                  itemCount: model.results.length + 1,
                  itemBuilder: (_, index) {
                    if (index == model.results.length) return _buildMoreCell();
                    final d = model.results[index];
                    return _Cell(
                      data: d,
                      onTap: () => dispatch(
                          PopularPosterActionCreator.onCellTapped(
                              d.id,
                              d.backdropPath,
                              state.showmovie ? d.title : d.name,
                              d.posterPath)),
                    );
                  },
                )
              : _ShimmerList(),
        ));
  }

  return Column(
    children: <Widget>[
      _buildFrontTitel(
          I18n.of(viewService.context).popular,
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: () => dispatch(
                    PopularPosterActionCreator.onPopularFilterChanged(true)),
                child: Text(I18n.of(viewService.context).movies,
                    style:
                        state.showmovie ? _selectPopStyle : _unselectPopStyle),
              ),
              SizedBox(
                width: Adapt.px(20),
              ),
              GestureDetector(
                onTap: () => dispatch(
                    PopularPosterActionCreator.onPopularFilterChanged(false)),
                child: Text(I18n.of(viewService.context).tvShows,
                    style:
                        state.showmovie ? _unselectPopStyle : _selectPopStyle),
              )
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: Adapt.px(30))),
      SizedBox(
        height: Adapt.px(30),
      ),
      _buildbody(),
    ],
  );
}

class _ShimmerCell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Adapt.px(250),
      height: Adapt.px(350),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: Adapt.px(250),
            height: Adapt.px(350),
            decoration: BoxDecoration(
              color: const Color(0xFFEEEEEE),
              borderRadius: BorderRadius.circular(Adapt.px(15)),
            ),
          ),
          SizedBox(
            height: Adapt.px(30),
          ),
          Container(
            width: Adapt.px(220),
            height: Adapt.px(30),
            color: const Color(0xFFEEEEEE),
          )
        ],
      ),
    );
  }
}

class _ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = ThemeStyle.getTheme(context);
    return Shimmer.fromColors(
        baseColor: _theme.primaryColorDark,
        highlightColor: _theme.primaryColorLight,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: Adapt.px(30)),
          separatorBuilder: (_, __) => SizedBox(width: Adapt.px(30)),
          itemCount: 4,
          itemBuilder: (_, __) => _ShimmerCell(),
        ));
  }
}

class _Cell extends StatelessWidget {
  final VideoListResult data;
  final Function onTap;
  const _Cell({@required this.data, this.onTap});

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = ThemeStyle.getTheme(context);
    return GestureDetector(
      key: ValueKey(data.id),
      onTap: onTap,
      child: Column(
        children: <Widget>[
          Container(
              width: Adapt.px(250),
              height: Adapt.px(350),
              decoration: BoxDecoration(
                  color: _theme.primaryColorDark,
                  borderRadius: BorderRadius.circular(Adapt.px(15)),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(
                          ImageUrl.getUrl(data.posterPath, ImageSize.w400))))),
          Container(
              //alignment: Alignment.bottomCenter,
              width: Adapt.px(250),
              padding: EdgeInsets.all(Adapt.px(10)),
              child: Text(
                data.title ?? data.name,
                maxLines: 2,
                //textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Adapt.px(28),
                  fontWeight: FontWeight.bold,
                ),
              ))
        ],
      ),
    );
  }
}
