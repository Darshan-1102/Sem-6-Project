import 'package:book_buddy_5_admin/screen/category_screen.dart';
import 'package:book_buddy_5_admin/screen/dashboard_screen.dart';
import 'package:book_buddy_5_admin/screen/main_category_screen.dart';
import 'package:book_buddy_5_admin/screen/sub_category_screen.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCR_K3XynQQYenG20s-4aCc_txUgZy409I",
        appId: "1:57218694636:web:512b93b32208f7a99814c9",
        messagingSenderId: "57218694636",
        projectId: "book-buddy-5",
        storageBucket: "book-buddy-5.appspot.com"
      ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Buddy Admin',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const SideMenu(),
      builder: EasyLoading.init(),
    );
  }
}

class SideMenu extends StatefulWidget {
  static const String id= 'side-menu';
  const SideMenu({Key? key}) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  Widget _selectedScreen = const DashBoardScreen();

  screenSelector(item){
    switch(item.route){
      case DashBoardScreen.id:
        setState((){
          _selectedScreen= const DashBoardScreen();
        });
        break;
      case CategoryScreen.id:
        setState((){
          _selectedScreen = const CategoryScreen();
        });
        break;
      case MainCategoryScreen.id:
        setState((){
          _selectedScreen = const MainCategoryScreen();
        });
        break;
      case SubCategoryScreen.id:
        setState((){
          _selectedScreen = const SubCategoryScreen();
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Book Buddy Admin',
          style: TextStyle(letterSpacing: 1),
        ),
      ),
      sideBar: SideBar(
        items: const [
          AdminMenuItem(
            title: 'Dashboard',
            route: DashBoardScreen.id,
            icon: Icons.dashboard,
          ),
          AdminMenuItem(
            title: 'Categories',
            icon: Icons.category,
            children: [
              AdminMenuItem(
                title: 'Category',
                route: CategoryScreen.id,
                icon: Icons.control_point_duplicate
              ),
              AdminMenuItem(
                title: 'Main Category',
                route: MainCategoryScreen.id,
                icon: Icons.label_important
              ),
              AdminMenuItem(
                title: 'Sub Category',
                route: SubCategoryScreen.id,
                icon: Icons.subject
              ),
            ],
          ),
        ],
        selectedRoute: SideMenu.id,
        onSelected: (item) {
          screenSelector(item);
          // if (item.route != null) {
          //   Navigator.of(context).pushNamed(item.route!);
          // }
        },
        header: Container(
          height: 50,
          width: double.infinity,
          color: const Color(0xff444444),
          child: const Center(
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        footer: Container(
          height: 50,
          width: double.infinity,
          color: const Color(0xff444444),
          child: Center(
            child: Text(
              DateTimeFormat.format(DateTime.now(), format: AmericanDateFormats.dayOfWeek),
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: _selectedScreen,
      ),
    );
  }
}
