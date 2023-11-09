import 'dart:convert';

import 'package:models/models.dart';
import 'package:http/http.dart' as http;

import '../../consts/api.dart';

abstract class VillageRepository {
  Future<Settlement?> upgradeBuilding({required ConstructionRequest request});
}

class VillageRepositoryImpl implements VillageRepository {
  @override
  Future<Settlement?> upgradeBuilding({required ConstructionRequest request}) async {
    final url = Uri.http(baseURL, '/settlement/654c444d5676e7ca48ca25fb/construction');
    final response = await http.post(url, body: json.encode(request));
    final map = json.decode(response.body) as Map<String, dynamic>;
    final settlement = Settlement.fromJson(map);
    return settlement;
  }
}
