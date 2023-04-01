import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import '../../models/main_category_model.dart';

class MainCategoryWidget extends StatefulWidget {
  final String? selectedCat;
  const MainCategoryWidget({Key? key, this.selectedCat}) : super(key: key);

  @override
  State<MainCategoryWidget> createState() => _MainCategoryWidgetState();
}

class _MainCategoryWidgetState extends State<MainCategoryWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FirestoreListView<MainCategory>(
        query: mainCategoryCollection(widget.selectedCat),
        itemBuilder: (context, snapshot) {
          MainCategory mainCategory = snapshot.data();
          return ExpansionTile(
            title: Text(
              mainCategory.mainCategory!,
            ),
            children: [
              
            ],
          );
        },
      ),
    );
  }
}
