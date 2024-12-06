import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../components/display_place.dart';
import '../components/display_total_price.dart';
import '../components/search_bar_filter.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final CollectionReference categoryCollection =
      FirebaseFirestore.instance.collection("AppCategory");

  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const SearchBarFilter(),
            listOfCategoryItems(size),
            const Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    DisplayTotalPrice(),
                    SizedBox(height: 15),
                    DisplayPlace(),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // floatingActionButton: const MapWithCustomInfoWindows(),
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> listOfCategoryItems(Size size) {
    return StreamBuilder(
      stream: categoryCollection.snapshots(),
      builder: (context, streamSnapshot) {
        if (streamSnapshot.hasData) {
          return Stack(
            children: [
              const Positioned(
                left: 0,
                right: 0,
                top: 80,
                child: Divider(
                  color: Colors.black12,
                ),
              ),
              SizedBox(
                height: size.height * 0.12,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.horizontal,
                  itemCount: streamSnapshot.data!.docs.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                          top: 20,
                          right: 20,
                          left: 20,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 32,
                              width: 40,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Image.network(
                                streamSnapshot.data!.docs[index]['image'],
                                color: selectedIndex == index
                                    ? Colors.black
                                    : Colors.black45,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              streamSnapshot.data!.docs[index]['title'],
                              style: TextStyle(
                                fontSize: 13,
                                color: selectedIndex == index
                                    ? Colors.black
                                    : Colors.black45,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 3,
                              width: 50,
                              color: selectedIndex == index
                                  ? Colors.black
                                  : Colors.transparent,
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
