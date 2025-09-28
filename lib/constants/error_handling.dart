import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_task2/constants/utils.dart';
import 'package:http/http.dart';

void httpErrorHandling({
  required BuildContext context,
  required Response response,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
    case 201:
      onSuccess();
      break;
    case 400:
    case 409:
   
      showSnackBar(context: context, text: jsonDecode(response.body)['message']);
    case 500:
    
      showSnackBar(context: context, text: jsonDecode(response.body)['error']);
    default:
      showSnackBar(context: context, text: response.body);
  }
}
