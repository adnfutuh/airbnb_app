import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> saveMessagesToFirebase() async {
  final CollectionReference ref =
      FirebaseFirestore.instance.collection("MyMessage");
  for (final Message message in messages) {
    final String id =
        DateTime.now().toIso8601String() + Random().nextInt(1000).toString();
    await ref.doc(id).set(message.toMap());
  }
}

class Message {
  final String image;
  final String vendorImage;
  final String name;
  final String date;
  final String description;
  final String duration;

  Message({
    required this.image,
    required this.vendorImage,
    required this.name,
    required this.date,
    required this.description,
    required this.duration,
  });
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'image': image,
      'vendorImage': vendorImage,
      'name': name,
      'date': date,
      'description': description,
      'duration': duration,
    };
  }
}

final List<Message> messages = [
  Message(
    image:
        "https://www.momondo.in/himg/b1/a8/e3/revato-1172876-6930557-765128.jpg",
    vendorImage:
        "https://images.ctfassets.net/h6goo9gw1hh6/2sNZtFAWOdP1lmQ33VwRN3/24e953b920a9cd0ff2e1d587742a2472/1-intro-photo-final.jpg?w=1200&h=992&fl=progressive&q=70&fm=jpg",
    name: "Andrea",
    date: "7/25/23",
    description: "You: Airbnb update: Reservation of the",
    duration: "Sep 24-28, 2024 Stockach",
  ),
  Message(
    image:
        "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0e/de/f7/c3/standard-room.jpg?w=1200&h=-1&s=1",
    vendorImage:
        "https://media.istockphoto.com/id/1300512215/photo/headshot-portrait-of-smiling-ethnic-businessman-in-office.webp?b=1&s=170667a&w=0&k=20&c=TXCiY7rYEvIBd6ibj2bE-VbJu0rRGy3MlHwxt2LHt9w=",
    name: "Nikolaus",
    date: "7/14/23",
    description: "Airbnb update: Reminder - Leave about",
    duration: "Jul 9-14, 2024, Konstanz",
  ),
  Message(
    image: "https://media.timeout.com/images/105162711/image.jpg",
    vendorImage:
        "https://media.istockphoto.com/id/1476171646/photo/young-woman-ready-for-job-business-concept.webp?b=1&s=170667a&w=0&k=20&c=oegktY4Hijr4wOelujTp81I0BJPjD6Q-lb5BpwOj0kA=",
    name: "Manfred & Marcella",
    date: "7/2/23",
    description: "You: Airbnb update: Reservation of the",
    duration: "Oct 2-7, 2024 Khajura",
  ),
];
