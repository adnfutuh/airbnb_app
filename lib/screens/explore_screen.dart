import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../components/display_place.dart';
import '../components/display_total_price.dart';
import '../components/search_bar_filter.dart';
import '../components/google_map.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final CollectionReference categoryCollection =
      FirebaseFirestore.instance.collection("AppCategory");

  int selectedIndex = 0;
  bool isMapVisible = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Column(
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
            Positioned(
              bottom: isMapVisible ? 0 : -size.height * 1,
              left: 0,
              right: 0,
              height: size.height * 0.663,
              child: const GoogleMapFlutter(),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: GestureDetector(
          onTap: () {
            setState(() {
              isMapVisible = !isMapVisible;
            });
          },
          child: Container(
            margin: isMapVisible
                ? const EdgeInsets.symmetric(horizontal: 150, vertical: 10)
                : const EdgeInsets.symmetric(horizontal: 130, vertical: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 5),
                if (!isMapVisible)
                  const Text(
                    "Map",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                const SizedBox(width: 5),
                Icon(
                  isMapVisible ? Icons.close : Icons.map_outlined,
                  color: Colors.white,
                ),
                const SizedBox(width: 5),
              ],
            ),
          ),
        ),
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
