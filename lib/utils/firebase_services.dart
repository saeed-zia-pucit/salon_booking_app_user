import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salon_app/models/booking_model.dart';
import 'package:salon_app/models/provider_response_model.dart';
import 'package:salon_app/models/service_response_model.dart';
import 'package:salon_app/utils/functions.dart';

class FirebaseServices {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<List<ServiceResponseModel>> getServices() async {
    final querySnapshot = await _firestore.collection('services').get();
    final services = querySnapshot.docs.map((doc) {
      return ServiceResponseModel.fromJson(doc.data());
    }).toList();
    return services;
  }

  //* We'll fetch the provider data to show his/her offered services and available time slots for booking
  static Future<ProviderResponseModel> getSalonProvider() async {
    try {
      // Fetch the first provider from the 'users' collection
      final QuerySnapshot querySnapshot =
          await _firestore.collection('users').limit(1).get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception("No documents found in the collection.");
      }

      final DocumentSnapshot doc = querySnapshot.docs.first;
      final data = doc.data() as Map<String, dynamic>?;

      if (data == null) {
        throw Exception("Document data is null.");
      }

      return ProviderResponseModel.fromJson(data);
    } catch (e) {
      log("Error fetching salon provider: ${e.toString()}");
      throw Exception("Failed to fetch salon provider data.");
    }
  }

  //* Create new booking for salon provider
  static Future<void> createBooking(
      {
      required String bookingOn,
      required List<int> services,
      required List<String> timeSlots}) async {
    try {
      await FirebaseFirestore.instance
          .collection(
              'bookings') // Replace 'users' with your actual collection name
          .doc()
          .set({
        'user': {
          'user_id': spUtil?.user.uid,
          'name': spUtil?.user.name,
          'email': spUtil?.user.email,
          'profile_image': spUtil?.user.imageUrl
        },
        'provider': {
          'provider_id': spUtil?.provider.uid,
          'name': spUtil?.provider.name,
          'email': spUtil?.provider.email,
          'profile_image':
              (spUtil?.provider.store?.coverImages?.isNotEmpty ?? false)
                  ? spUtil?.provider.store?.coverImages?.first
                  : ''
        },
        'services': services,
        'time_slots': timeSlots,
        'booking_on': bookingOn,
        'created_at': DateTime.now()
      });
    } catch (e) {
      throw Exception("Failed to create booking!");
    }
  }

  //* Fetch bookings based on booking date
  static Future<List<BookingModel>> getBookings(
      {required String bookingDate}) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('bookings')
          .where('booking_on', isEqualTo: bookingDate)
          .get();

      List<BookingModel> bookings = [];
      bookings = snapshot.docs
          .map((doc) =>
              BookingModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return bookings;
    } catch (e) {
      throw Exception("Failed to fetch bookings!");
    }
  }

  //* Fetch current user's bookings only
  static Future<List<BookingModel>> getUserBookings() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('bookings')
          .where('user.user_id', isEqualTo: spUtil?.user.uid)
          .get();

      List<BookingModel> bookings = [];
      bookings = snapshot.docs
          .map((doc) =>
              BookingModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return bookings;
    } catch (e) {
      throw Exception("Failed to fetch bookings!");
    }
  }

  static Future<void> deleteAccount() async {
    try {
      await FirebaseFirestore.instance
          .collection(
              'users') // Replace 'users' with your actual collection name
          .doc(spUtil?.user.uid)
          .delete();
    } catch (error) {
      print('Error deleting document: $error');
    }
  }
}
