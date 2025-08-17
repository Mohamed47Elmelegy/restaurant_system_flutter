import 'package:restaurant_system_flutter/features/orders/data/models/order_item_model.dart';
import 'package:restaurant_system_flutter/features/orders/data/models/place_order_request_model.dart';
import 'package:restaurant_system_flutter/features/orders/domain/entities/order_entity.dart';
import '../../domain/repositories/check_out_repository.dart';
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



