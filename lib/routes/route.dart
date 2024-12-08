import 'package:airbnb_app/screens/explore_screen.dart';
import 'package:airbnb_app/screens/login_screen.dart';
import 'package:airbnb_app/screens/messages_screen.dart';
import 'package:airbnb_app/screens/navbar.dart';
import 'package:airbnb_app/screens/place_detail_screen.dart';
import 'package:airbnb_app/screens/trip_screen.dart';
import 'package:airbnb_app/screens/wishlists_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/profile_screen.dart';

class RoutesConfig {
  static final GoRouter appRouter = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        navigatorKey: GlobalKey<NavigatorState>(),
        builder: (context, state, child) {
          return Navbar(child: child);
        },
        routes: [
          GoRoute(
            path: '/explore',
            builder: (context, state) => const ExploreScreen(),
          ),
          GoRoute(
            path: '/wishlist',
            builder: (context, state) => const WishlistsScreen(),
          ),
          GoRoute(
            path: '/trip',
            builder: (context, state) => const TripScreen(),
          ),
          GoRoute(
            path: '/message',
            builder: (context, state) => const MessagesScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/detail',
        builder: (context, state) {
          final place = state.extra as QueryDocumentSnapshot;
          return PlaceDetailScreen(place: place);
        },
      ),
    ],
  );
}
