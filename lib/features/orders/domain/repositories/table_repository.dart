import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/table_entity.dart';

abstract class TableRepository {
  Future<Either<Failure, TableEntity>> getTableByQr(String qrCode);
  Future<Either<Failure, void>> occupyTable(int tableId);
}
