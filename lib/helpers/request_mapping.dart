import 'dart:convert';

abstract class RequestMapping {
  RequestMapping(String dataRequest)
      : data = jsonDecode(dataRequest) as Map<String, dynamic> {
    map();
  }

  RequestMapping.empty() : data = <String, dynamic>{};

  final Map<String, dynamic> data;

  void map();
}