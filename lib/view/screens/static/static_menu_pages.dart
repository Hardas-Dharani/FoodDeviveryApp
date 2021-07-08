import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:provider/provider.dart';

class StaticPages extends StatefulWidget {
  final int pageType;
  final String pageName;


  const StaticPages({Key key, this.pageType, this.pageName});

  @override
  _StaticPagesState createState() => _StaticPagesState();
}

class _StaticPagesState extends State<StaticPages> {
  var _isDarkMode;
  @override
  Widget build(BuildContext context) {
    _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Provider.of<SplashProvider>(context, listen: false)
        .getStaticPageData(context: context, type: widget.pageType);
    return Scaffold(
      backgroundColor:_isDarkMode
          ?Color(0xff000000):Color(0xffF5F5F5),
      body: CustomScrollView(slivers: [
        // App Bar
        SliverAppBar(
          expandedHeight: MediaQuery.of(context).size.height * 0.16,
          floating: false,
          stretch: true,
          elevation: 0,
          pinned: false,
          title: Text('${widget.pageName}'),
          stretchTriggerOffset: 150.0,
          titleSpacing: 0,
          backgroundColor: Color(
              int.parse("#00A4A4".substring(1, 7), radix: 16) + 0xFF000000),
          actionsIconTheme: IconThemeData(opacity: 0.0),
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: [
              StretchMode.zoomBackground,
            ],
            background: Container(
              color: _isDarkMode
                ?Color(0xff000000):Color(0xffF5F5F5),
              child: Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * 0.16,
                    decoration: BoxDecoration(
                      color: Color(
                          int.parse("#00A4A4".substring(1, 7), radix: 16) +
                              0xFF000000),
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(20.0),
                          bottomLeft: Radius.circular(20.0)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        SliverToBoxAdapter(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Consumer<SplashProvider>(builder: (context, splashProvider, child) {
            return splashProvider.staticModel != null &&
                    splashProvider.isStaticPageLoaded
                ? Html(data: splashProvider.staticModel.content)
                : splashProvider.isStaticPageLoaded
                    ? Center(child: Text("No Data Avaialable"))
                    : Center(child: CircularProgressIndicator());
          }),
        ]))
      ]),
    );
  }
}
