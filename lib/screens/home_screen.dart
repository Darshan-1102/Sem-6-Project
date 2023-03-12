import 'package:book_buddy_5/widgets/banner_widget.dart';
import 'package:book_buddy_5/widgets/brand_highlights.dart';
import 'package:book_buddy_5/widgets/category_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orangeAccent,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: Colors.indigo,
          centerTitle: true,
          title: const Text(
            "Book Buddy",
            style: TextStyle(
                fontSize: 25, color: Colors.white, letterSpacing: 1.5),
          ),
          actions: [
            IconButton(
                onPressed: () {},
                color: Colors.white,
                icon: const Icon(Icons.shopping_cart_outlined))
          ],
        ),
      ),
      body: ListView(
        children: const [
          SearchWidget(),
          SizedBox(
            height: 10,
          ),
          BannerWidget(),
          BrandHighlights(),
          CategoryWidget()
        ],
      ),
    );
  }
}

class SearchWidget extends StatelessWidget {
  const SearchWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 55,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: const TextField(
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                    hintText: 'Search',
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.search)),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.info_outline,
                    size: 12,
                    color: Colors.white,
                  ),
                  Text(
                    ' Quality Books',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  )
                ],
              ),
              Row(
                children: const [
                  Icon(
                    Icons.info_outline,
                    size: 12,
                    color: Colors.white,
                  ),
                  Text(
                    ' Affordable Price',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  )
                ],
              ),
              Row(
                children: const [
                  Icon(
                    Icons.info_outline,
                    size: 12,
                    color: Colors.white,
                  ),
                  Text(
                    ' Trusted Books',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  )
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
