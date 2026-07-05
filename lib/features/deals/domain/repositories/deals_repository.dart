import '../entities/deal.dart';

abstract class DealsRepository {
  Future<List<Deal>> getDeals({String? salonId});
}
