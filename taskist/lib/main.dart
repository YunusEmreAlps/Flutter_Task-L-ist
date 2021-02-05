// Task-L-ist
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taskist/size_config.dart';
import 'package:provider/provider.dart';
import 'package:taskist/theme.dart';
import 'package:taskist/screens/todolist.dart';
import 'package:taskist/ui/simple_app_bar.dart';
import 'package:taskist/util/app_constant.dart';
import 'package:taskist/model/my_theme_provider.dart';

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
      appBar: buildAppBar(context),
      body: Column(
        children: <Widget>[
          Expanded(child: TodoList()),
        ],
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        AppConstant.appName,
        style: TextStyle(
          color: Theme.of(context).accentColor,
          fontSize: 22, // 22
          fontFamily: 'Manrope',
          letterSpacing: 2,
        ),
      ),
      actions: [buildAddButton(context)],
    );
  }

  Padding buildAddButton(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: 20),
      child: Consumer<MyThemeModel>(
        builder: (context, theme, child) => InkWell(
          onTap: () => theme.changeTheme(),
          child: SvgPicture.asset(
            theme.isLightTheme
                ? "assets/icons/sun.svg"
                : "assets/icons/moon.svg",
            height: 22,
            width: 22,
            color: Color(0xFFFF97B3),
          ),
        ),
      ),
    );
  }
}
