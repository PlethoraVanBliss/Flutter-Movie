import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:movie/actions/Adapt.dart';

import '../../action.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    Theme3State state, Dispatch dispatch, ViewService viewService) {
  Widget _buildHeader() {
    return Row(
      children: <Widget>[
        SizedBox(
          width: Adapt.px(40),
        ),
        Text(
          'Hi , ${state.name}',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: Adapt.px(50),
          ),
        ),
        Expanded(
          child: SizedBox(),
        ),
        IconButton(
          iconSize: Adapt.px(50),
          onPressed: () {
            if (state.islogin)
              dispatch(AccountPageActionCreator.onLogout());
            else
              dispatch(AccountPageActionCreator.onLogin());
          },
          icon: Icon(
            state.islogin ? Icons.exit_to_app : Icons.person_outline,
          ),
        ),
        SizedBox(
          width: Adapt.px(10),
        )
      ],
    );
  }

  Widget _buildGirdCell(String icon, String title, {Function() ontap}) {
    return GestureDetector(
        onTap: ontap,
        child: Container(
          margin: EdgeInsets.fromLTRB(
              Adapt.px(10), Adapt.px(10), Adapt.px(10), Adapt.px(30)),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Adapt.px(20)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    blurRadius: Adapt.px(20),
                    color: Colors.grey[300],
                    offset: Offset(Adapt.px(5), Adapt.px(10)))
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                icon,
                width: Adapt.px(100),
                height: Adapt.px(100),
              ),
              SizedBox(
                height: Adapt.px(10),
              ),
              Text(
                title,
                style: TextStyle(
                    fontSize: Adapt.px(35), fontWeight: FontWeight.bold),
              )
            ],
          ),
        ));
  }

  return Container(
    color: Colors.white,
    child: SafeArea(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: Adapt.px(80),
          ),
          _buildHeader(),
          SizedBox(
            height: Adapt.px(80),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Adapt.px(30)),
            child: GridView.count(
              physics: NeverScrollableScrollPhysics(),
              //mainAxisSpacing: Adapt.px(30),
              crossAxisSpacing: Adapt.px(30),
              shrinkWrap: true,
              crossAxisCount: 2,
              children: <Widget>[
                _buildGirdCell('images/yoda.png', 'Watchlist',
                    ontap: () => dispatch(
                        AccountPageActionCreator.navigatorPush('WatchlistPage',
                            arguments: {'accountid': state.acountIdV3}))),
                _buildGirdCell('images/luke_skywalker.png', 'MyLists',
                    ontap: () => dispatch(
                        AccountPageActionCreator.navigatorPush('MyListsPage',
                            arguments: {'accountid': state.acountIdV4}))),
                _buildGirdCell('images/darth_vader.png', 'Favorites',
                    ontap: () => dispatch(
                        AccountPageActionCreator.navigatorPush('FavoritesPage',
                            arguments: {'accountid': state.acountIdV3}))),
                _buildGirdCell('images/chewbacca.png', 'Recommendations'),
                _buildGirdCell('images/c3po.png', 'MyRated'),
                _buildGirdCell('images/r2d2.png', 'Setting',
                    ontap: () =>
                        dispatch(AccountPageActionCreator.themeChange())),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}