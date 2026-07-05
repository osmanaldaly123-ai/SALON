import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/salon_model.dart';

abstract class SalonsRemoteDataSource {
  Future<List<SalonModel>> getSalons({String? query});
  Future<SalonModel> getSalonById(String id);
}

class SalonsRemoteDataSourceImpl implements SalonsRemoteDataSource {
  SalonsRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  @override
  Future<List<SalonModel>> getSalons({String? query}) async {
    final response = await _client.get(
      ApiConstants.salons,
      queryParameters: query != null ? {'q': query} : null,
    );
    final list = response.data['data'] as List<dynamic>? ?? response.data as List;
    return list
        .map((e) => SalonModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<SalonModel> getSalonById(String id) async {
    final response = await _client.get(ApiConstants.salonById(id));
    final data = response.data['data'] as Map<String, dynamic>? ??
        response.data as Map<String, dynamic>;
    return SalonModel.fromJson(data);
  }
}
