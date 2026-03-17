import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../modules/admin/admin_home.dart';
import '../../../modules/driver/driver_home.dart';
import '../../../modules/passenger/passenger_home.dart';

const String baseUrl = "http://192.168.1.9:8000";

class Service {
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<void> saveTokens(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    if (data['access_token'] != null) {
      await prefs.setString("access_token", data['access_token']);
    }
    if (data['refresh_token'] != null) {
      await prefs.setString("refresh_token", data['refresh_token']);
    }
    if (data['token_type'] != null) {
      await prefs.setString("token_type", data['token_type']);
    }
    if (data['user'] != null) {
      await prefs.setString(
          "user_email", data['user']['email']?.toString() ?? '');
      await prefs.setString(
          "user_type", data['user']['user_type']?.toString() ?? '');
      await prefs.setString(
          "user_name", data['user']['name']?.toString() ?? '');
    }
  }

  Future<Map<String, dynamic>?> refresh_token(String refreshToken) async {
    try {
      final url = Uri.parse("$baseUrl/api/token/refresh/");
      final response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"refresh": refreshToken}));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final body = jsonDecode(response.body);
        return {"access_token": body['access'], "refresh_token": refreshToken};
      }
    } catch (e) {
      print("Error refreshing token: $e");
    }
    return null;
  }

  Future<String?> getValidToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    String? refreshToken = prefs.getString('refresh_token');

    if (token != null && token.isNotEmpty) {
      return token;
    }

    if (refreshToken != null) {
      final newTokens = await refresh_token(refreshToken);
      if (newTokens != null && newTokens['access_token'] != null) {
        await saveTokens(newTokens);
        return newTokens['access_token'];
      }
    }

    return null;
  }

  Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
    required String? userType,
  }) async {
    try {
      final url = Uri.parse("$baseUrl/api/users/create/");

      final response = await http.post(url,
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json"
          },
          body: jsonEncode({
            "email": email,
            "password": password,
            "user_type": userType,
          }));

      final result = _handleResponse(response);

      if (result['success'] == true) {
        await saveTokens(result['data']);
      }
      return result;
    } catch (e) {
      return {"success": false, "error": "Network error : $e"};
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {"success": true, "data": body};
      } else {
        return {"success": false, "error": body};
      }
    } catch (_) {
      return {
        "success": false,
        "error": "invalid server response : ${response.body}"
      };
    }
  }

  Future<Map<String, dynamic>> logIn({
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse("$baseUrl/api/users/login/");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );
      final result = _handleResponse(response);

      if (result['success'] == true) await saveTokens(result['data']);

      return result;
    } catch (e) {
      return {"success": false, "error": "Network error : $e"};
    }
  }

  void navigateBy_user_type(
      {required BuildContext context, required Map<String, dynamic> data}) {
    final user_type = data['user_type'];
    if (user_type == 'driver') {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => Driver_Home()));
    }
    if (user_type == 'rider') {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => PassengerHome()));
    }
    if (user_type == 'admin') {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => AdminHome()));
    }
  }

  Future<Map<String, dynamic>> viewProfile() async {
    final token = await getValidToken();
    if (token == null) {
      return {"success": false, "error": "No valid token"};
    }
    final url = Uri.parse("$baseUrl/api/users/view_profile/");
    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );
      final result = _handleResponse(response);
      return result;
    } catch (e) {
      print("error : $e");
      return {"success": false, "error": "error $e"};
    }
  }

  Future<Map<String, dynamic>> editDriverProfile({
    String? name,
    String? email,
    String? language1,
    String? language2,
    int? phone,
    String? car_model,
    String? license_number,
    String? license_expiry_date,
    int? car_number,
    String? car_color,
  }) async {
    try {
      final token = await getValidToken();
      if (token == null) {
        return {"success": false, "error": "No valid token"};
      }
      final url = Uri.parse("$baseUrl/api/users/update_driver_profile/");
      final response = await http.patch(url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
          body: jsonEncode({
            "name": name,
            "email": email,
            "phone": phone,
            "language1": language1,
            "language2": language2,
            "car_model": car_model,
            "license_number": license_number,
            "license_expiry_date": license_expiry_date,
            "car_number": car_number,
            "car_color": car_color,
          }));
      final result = _handleResponse(response);
      return result;
    } catch (e) {
      print(" error : $e");
      return {
        'success': false,
        'error': e,
      };
    }
  }

  Future<Map<String, dynamic>> editRiderProfile({
    String? name,
    String? email,
    String? language1,
    String? language2,
    int? phone,
  }) async {
    try {
      final token = await getValidToken();
      if (token == null) {
        return {"success": false, "error": "No valid token"};
      }
      final url = Uri.parse("$baseUrl/api/users/update_rider_profile/");
      final response = await http.patch(url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
          body: jsonEncode({
            "name": name,
            "email": email,
            "phone": phone,
            "language1": language1,
            "language2": language2,
          }));
      final result = _handleResponse(response);

      return result;
    } catch (e) {
      print(" error : $e");
      return {
        'success': false,
        'error': e,
      };
    }
  }

  Future<Map<String, dynamic>> createRide({
    required String location,
    required String destination,
    required String depature_time,
    required String arrival_time,
    required String cost,
    required String capacity,
  }) async {
    try {
      final token = await getValidToken();
      if (token == null) {
        return {"success": false, "error": "No valid token"};
      }
      final url = Uri.parse("$baseUrl/api/rides/create/");
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          "location": location,
          "destination": destination,
          "departure_time": depature_time,
          "arrival_time": arrival_time,
          "cost": cost,
          "capacity": int.parse(capacity),
        }),
      );
      final result = _handleResponse(response);

      return result;
    } catch (e) {
      return {"success": false, "error": "Network error : $e"};
    }
  }

  Future<Map<String, dynamic>> updateRide({
    String? location,
    String? destination,
    String? departure_time,
    String? arrival_time,
    String? cost,
    String? capacity,
    required int rideId,
  }) async {
    try {
      final token = await getValidToken();
      if (token == null) {
        return {"success": false, "error": "No valid token"};
      }
      final url = Uri.parse("$baseUrl/api/rides/$rideId/update/");

      final response = await http.patch(url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: jsonEncode({
            "location": location,
            "destination": destination,
            "departure_time": departure_time,
            "arrival_time": arrival_time,
            "cost": cost,
            "capacity": int.tryParse(capacity!),
          }));
      final result = _handleResponse(response);
      return result;
    } catch (e) {
      return {
        "success": false,
        "error": "Network error : $e",
      };
    }
  }

  Future<List<Ride>> getMyRides() async {
    try {
      final token = await getValidToken();
      if (token == null) {
        print(
            "*************\n**********\n*************\nNo valid Token\n****************\n**************\n***************\n");
        return [];
      }
      final url = Uri.parse('$baseUrl/api/rides/myrides/');

      if (token == null || token.isEmpty) {
        print(
            "*****************\n*************\n*******\n NO ACCESS TOKEN FOUND \n***************\n**************\n*********");
      }
      final response = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      });
      final List<dynamic> result = jsonDecode(response.body);
      print(
          "***************\n***************\n*************\n My rides response : ${response.body}\n*********************\n******************\n*****************\n");
      return result.map((e) => Ride.fromJson(e)).toList();
    } catch (e) {
      print(
          "********************\n****************\n Network error : Hello error $e\n******************\n***************\n");
      return [];
    }
  }

  Future<bool> deleteRide(int id) async {
    try {
      final token = await getValidToken();
      if (token == null) {
        print(
            "*************\n**********\n*************\nNo valid Token\n****************\n**************\n****************\n");
        return false;
      }
      final url = Uri.parse('$baseUrl/api/rides/$id/cancel/');

      final response = await http.delete(url, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      });
      final result = _handleResponse(response);
      return result['success'];
    } catch (e) {
      print(
          "********************\n****************\n Network error : Hello error $e\n******************\n***************\n");
      return false;
    }
  }

  Future<Map<String, dynamic>> searchRides({
    required String location,
    required String destination,
  }) async {
    try {
      final token = await getValidToken();
      if (token == null) {
        return {"success": false, "error": "No valid token"};
      }
      final url = Uri.parse("$baseUrl/api/rides/search/").replace(
        queryParameters: {
          'location': location,
          'destination': destination,
        },
      );

      print("Searching rides with URL: $url");

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      final result = _handleResponse(response);
      return result;
    } catch (e) {
      return {
        "success": false,
        "error": "Network error: $e",
      };
    }
  }

  Future<Map<String, dynamic>> createReservation({
    required int rideId,
  }) async {
    try {
      final token = await getValidToken();
      if (token == null) {
        return {"success": false, "error": "No valid token"};
      }

      final url = Uri.parse("$baseUrl/api/rides/reservations/create/");

      print("Creating reservation for ride ID: $rideId");

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          "ride": rideId,
        }),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      final result = _handleResponse(response);
      return result;
    } catch (e) {
      return {
        "success": false,
        "error": "Network error: $e",
      };
    }
  }
}

class Ride {
  final int id;
  final String location;
  final String destination;
  final String departureTime;
  final String arrivalTime;
  final String cost;
  final int capacity;
  final String? carImage;

  Ride(
      {required this.id,
      required this.location,
      required this.destination,
      required this.departureTime,
      required this.arrivalTime,
      required this.cost,
      required this.capacity,
      this.carImage});

  factory Ride.fromJson(Map<String, dynamic> json) {
    String? pathImage = json['car_image'];
    if (pathImage != null && pathImage.isNotEmpty) {
      if (!pathImage.startsWith("http")) {
        pathImage = "$baseUrl$pathImage";
      }
    }
    return Ride(
      id: json['id'],
      location: json['location'],
      destination: json['destination'],
      departureTime: json['departure_time'],
      arrivalTime: json['arrival_time'],
      cost: json['cost'],
      capacity: json['capacity'] != null
          ? int.tryParse(json['capacity'].toString()) ?? 0
          : 0,
      carImage: json['car_image'],
    );
  }
}
