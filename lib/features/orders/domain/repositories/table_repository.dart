import 'package:dartz/dartz.dart';
import '../entities/table_entity.dart';
import '../../../../core/error/failures.dart';

abstract class TableRepository {
  Future<Either<Failure, TableEntity>> getTableByQr(String qrCode);
  Future<Either<Failure, void>> occupyTable(int tableId);
}
