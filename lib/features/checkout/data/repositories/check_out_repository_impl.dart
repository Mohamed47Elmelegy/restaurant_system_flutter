import '../../domain/repositories/check_out_repository.dart';
import '../../../orders/data/models/place_order_request_model.dart';
import '../../../orders/data/models/order_item_model.dart';
import '../../../orders/domain/entities/order_entity.dart';
import '../datasources/check_out_remote_data_source.dart';

class CheckOutRepositoryImpl implements CheckOutRepository {
  final CheckOutRemoteDataSource remoteDataSource;
  CheckOutRepositoryImpl(this.remoteDataSource);

  @override
  Future<OrderEntity> placeOrder(
    PlaceOrderRequestModel request,
    List<OrderItemModel> items,
  ) {
    return remoteDataSource.placeOrder(request, items);
  }
}



