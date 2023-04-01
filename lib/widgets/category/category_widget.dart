import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';

import '../models/category_model.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({Key? key}) : super(key: key);

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  // List<String> categoryLabel = <String>[
  //   '1st Year',
  //   '2nd Year',
  //   '3rd Year',
  //   '4th Year',
  // ];

  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(
            height: 18,
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Categories for you',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    letterSpacing: 1),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: SizedBox(
              height: 40,
              child: Row(
                children: [
                  Expanded(
                    child: FirestoreListView<Category>(
                      scrollDirection: Axis.horizontal,
                      query: categoryCollection,
                      itemBuilder: (context, snapshot) {
                        Category category = snapshot.data();
                        return Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: ActionChip(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2),
                              ),
                              backgroundColor:
                                  _selectedCategory == category.catName
                                      ? Colors.blue.shade900
                                      : Colors.grey,
                              label: Text(
                                category.catName!,
                                style: TextStyle(
                                  fontSize: 12,
                                  letterSpacing: 0.5,
                                  color: _selectedCategory == category.catName
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  _selectedCategory = category.catName;
                                });
                              }),
                        );
                      },
                    ),
                    // child: ListView.builder(
                    //   scrollDirection: Axis.horizontal,
                    //   itemCount: categoryLabel.length,
                    //   itemBuilder: (BuildContext context, int index) {
                    //     return Padding(
                    //       padding: const EdgeInsets.only(right: 20),
                    //       child: ActionChip(
                    //         padding: EdgeInsets.zero,
                    //         shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(2)
                    //         ),
                    //         backgroundColor: _index==index ? Colors.blue.shade900 : Colors.grey,
                    //         label: Text(categoryLabel[index],
                    //           style: TextStyle(
                    //             fontSize: 12,
                    //             letterSpacing: 0.5,
                    //             color: _index==index ? Colors.white : Colors.black
                    //           ),
                    //         ),
                    //         onPressed: () {
                    //           setState((){
                    //             _index= index;
                    //           });
                    //         },
                    //       ),
                    //     );
                    //   },
                    // )
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.arrow_downward,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
