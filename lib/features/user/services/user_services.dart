import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_task2/constants/error_handling.dart';
import 'package:flutter_task2/constants/global_varaibles.dart';
import 'package:flutter_task2/constants/utils.dart';
import 'package:flutter_task2/model/user_model.dart';
import 'package:http/http.dart' as http;

class UserServices {
  Future<User?> createNewUser({
    required BuildContext context,
    required User user,
  }) async {
    try {
      print(">>> Before Creating user: ${user.toJson()}");
      final res = await http.post(
        Uri.parse('$uri/api/create-user'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'name':user.name,
          'email': user.email,
          'age':user.age.toString(),
          
        })
      );
      final data = jsonDecode(res.body);
      print(">>> After Creating user: ${user.toJson()}");
      print('Data in create user $data and user ${jsonEncode(user.toJson())}');
    User?  createdUser;
      httpErrorHandling(
        context: context,
        response: res,
        onSuccess: () {
        createdUser = User.fromJson(data);
        print('Created user data: ${createdUser!.toJson()}');
        showSnackBar(context: context, text: "User created successfully!");
        
        },
        
      );
      return createdUser;
    } catch (e) {
      showSnackBar(context: context, text: e.toString());
     return null;
    }
    
  }
 Future<List<User>> getUsers({
  required BuildContext context,
  String? query, // optional search param
}) async {
  List<User> users = [];
  try {
    final Uri url;
    if (query != null && query.isNotEmpty) {
      url = Uri.parse('$uri/api/get-user?name=$query');
    } else {
      url = Uri.parse('$uri/api/get-user');
    }

    final res = await http.get(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );
    
   
    httpErrorHandling(
      context: context,
      response: res,
      onSuccess: () {
        final data = jsonDecode(res.body);
       for(var data in data){
        users.add(User.fromJson(data));
       }
      },
    );
    return users;
  } catch (e) {
    showSnackBar(context: context, text: e.toString());
  }
  return users;
}
  // Future<List<User>> getAllUser({required BuildContext context}) async {
  //   try {
  //     List<User> user = [];
  //     final res = await http.get(
  //       Uri.parse('$uri/api/get-user'),
  //       headers: {'Content-Type': 'application/json; charset=UTF-8'},
  //     );
     
  //     final data = jsonDecode(res.body);
     
  //     httpErrorHandling(
  //       context: context,
  //       response: res,
  //       onSuccess: () {
  //         for (var data in data) {
  //           user.add(User.fromJson(data));
  //         }
  //         showSnackBar(context: context, text: "User Data Loaded Successfully");
  //       },
  //     );
  //     return user;
  //   } catch (e) {
  //     showSnackBar(context: context, text: e.toString());
  //     return [];
  //   }
  // }
   Future<User?> deleteUser({
    required BuildContext context,
     required User user,
   }) async {
    try {
      
      final res = await http.delete(
        Uri.parse('$uri/api/delete-user/${user.userId}'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'name':user.name
        })
      );
     
      final data = jsonDecode(res.body);
      User? deletedUser;
      httpErrorHandling(
        context: context,
        response: res,
        onSuccess: () {
          deletedUser = User.fromJson(data);
          showSnackBar(context: context, text: "User Deleted Successfully");
        },
      );
      return deletedUser;
    } catch (e) {
      showSnackBar(context: context, text: e.toString());
      return null;
    }
  }
  Future<User?> updateUser({
    required BuildContext context,
     required User user,
   }) async {
    try {
      
      final res = await http.put(
        Uri.parse('$uri/api/update-user/${user.userId}'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'name':user.name
        })
      );
     
      final data = jsonDecode(res.body);
      User? updatedUser ;
      httpErrorHandling(
        context: context,
        response: res,
        onSuccess: () {
          updatedUser  = User.fromJson(data);
          updatedUser!.copyWith(name: user.name );
          showSnackBar(context: context, text: "User Updated Successfully");
        },
      );
      return updatedUser;
    } catch (e) {
      showSnackBar(context: context, text: e.toString());
      return null;
    }
  }
  
}
