//import 'dart:convert';

import 'package:espa_admin/models/komentar.dart';
//import 'package:espa_admin/models/usluga.dart';
//import 'package:espa_admin/models/search_result.dart';
import 'package:espa_admin/providers/base_provider.dart';
//import 'package:espa_admin/utils/util.dart';
//import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
//import 'package:http/http.dart';

class KomentarProvider extends BaseProvider<Komentar> {
  KomentarProvider(): super("Komentar");

   @override
  Komentar fromJson(data) {
    // TODO: implement fromJson
    return Komentar.fromJson(data);
  }
}