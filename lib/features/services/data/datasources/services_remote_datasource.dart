import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/service_model.dart';

abstract class ServicesRemoteDataSource {
  Future<List<ServiceModel>> getServices({String? salonId});
}

class ServicesRemoteDataSourceImpl implements ServicesRemoteDataSource {
  ServicesRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  @override
  Future<List<ServiceModel>> getServices({String? salonId}) async {
    final path = salonId != null
        ? ApiConstants.salonServices(salonId)
        : ApiConstants.services;
    final response = await _client.get(path);
    final list = response.data['data'] as List<dynamic>? ?? response.data as List;
    return list
        .map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
