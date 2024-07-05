import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  // todo: userId, providerId, list of service IDs, list of selected time slots
  static Future<void> createBooking(
      {required String userId,
      required String providerId,
      required String bookingOn,
      required List<int> services,
      required List<String> timeSlots}) async {
    try {
      await FirebaseFirestore.instance
          .collection(
              'bookings') // Replace 'users' with your actual collection name
          .doc()
          .set({
            'user_id': userId,
            'provider_id': providerId,
            'services': services,
            'time_slots': timeSlots,
            'booking_on': bookingOn,
            'created_at': DateTime.now()
          });
    } catch (e) {
      throw Exception("Failed to create booking!");
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