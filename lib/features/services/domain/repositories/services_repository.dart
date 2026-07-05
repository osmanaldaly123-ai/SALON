import '../entities/service.dart';

abstract class ServicesRepository {
  Future<List<Service>> getServices({String? salonId});
}
