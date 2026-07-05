import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/deal_model.dart';

abstract class DealsRemoteDataSource {
  Future<List<DealModel>> getDeals({String? salonId});
}

class DealsRemoteDataSourceImpl implements DealsRemoteDataSource {
  DealsRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  @override
  Future<List<DealModel>> getDeals({String? salonId}) async {
    final path =
        salonId != null ? ApiConstants.salonDeals(salonId) : ApiConstants.deals;
    final response = await _client.get(path);
    final list = response.data['data'] as List<dynamic>? ?? response.data as List;
    return list
        .map((e) => DealModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
