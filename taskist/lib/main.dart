// Task-L-ist

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:taskist/model/my_theme_provider.dart';
import 'package:taskist/screens/todolist.dart';
import 'package:taskist/size_config.dart';
import 'package:taskist/theme.dart';
import 'package:taskist/ui/simple_app_bar.dart';
import 'package:taskist/util/app_constant.dart';

void main() {
  // MaterialPageRoute.debugEnableFadingRoutes = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Portrait mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ChangeNotifierProvider(
      create: (context) => MyThemeModel(),
      child: Consumer<MyThemeModel>(
        builder: (context, theme, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppConstant.appName,
          theme: themeData(context),
          darkTheme: darkThemeData(context),
          themeMode: theme.isLightTheme ? ThemeMode.light : ThemeMode.dark,
          home: MyHomePage(title: AppConstant.appName),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: appBarWidget(context),
      body: Column(
        children: <Widget>[
          Expanded(child: TodoList()),
        ],
      ),
    );
  }

  // Task Manager
  AppBar appBarWidget(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        AppConstant.appName,
        style: TextStyle(
          color: Theme.of(context).accentColor,
          fontSize: 20, // 22
          fontFamily: 'Manrope', // Manrope
          letterSpacing: 2,
        ),
      ),
      actions: [themeModeButton(context)],
    );
  }

  // Light-Dark
  Padding themeModeButton(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: 20),
      child: Consumer<MyThemeModel>(
        builder: (context, theme, child) => InkWell(
          onTap: () => theme.changeTheme(),
          child: SvgPicture.asset(
            theme.isLightTheme
                ? AppConstant.svgSun
                : AppConstant.svgMoon,
            height: 22,
            width: 22,
            color: AppConstant.colorPrimary, 
          ),
        ),
      ),
    );
  }
}
