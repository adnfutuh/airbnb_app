import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../provider/favorite_provider.dart';

class WishlistsScreen extends StatelessWidget {
  const WishlistsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = FavoriteProvider.of(context);
    final favoriteItems = provider.favorites;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Edit",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 35),
                const Text(
                  "WishlistsScreen",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                favoriteItems.isEmpty
                    ? const Text(
                        "No Favorites items yet",
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : SizedBox(
                        height: MediaQuery.of(context).size.height * 0.68,
                        child: GridView.builder(
                          itemCount: favoriteItems.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8),
                          itemBuilder: (context, index) {
                            String favorite = favoriteItems[index];
                            return FutureBuilder(
                              future: FirebaseFirestore.instance
                                  .collection("myAppCpollection")
                                  .doc(favorite)
                                  .get(),
                              builder: (context, snapShot) {
                                if (snapShot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                if (!snapShot.hasData ||
                                    snapShot.data == null) {
                                  return const Center(
                                    child: Text("Error loading favorites"),
                                  );
                                }
                                var favoriteItem = snapShot.data!;
                                bool isFavorite =
                                    provider.isExist(snapShot.data!);

                                return Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                            favoriteItem['image'],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: InkWell(
                                        onTap: () {
                                          provider.toggleFavorite(favoriteItem);
                                        },
                                        child: Icon(
                                          Icons.favorite,
                                          color: isFavorite
                                              ? Colors.red
                                              : Colors.black54,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 8,
                                      left: 8,
                                      right: 8,
                                      child: Container(
                                        color: Colors.black.withOpacity(0.6),
                                        padding: const EdgeInsets.all(4),
                                        child: Text(
                                          favoriteItem['title'],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
