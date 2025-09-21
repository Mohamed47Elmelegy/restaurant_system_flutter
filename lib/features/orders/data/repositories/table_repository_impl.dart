import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/table_entity.dart';
import '../../domain/repositories/table_repository.dart';
import '../datasources/table_remote_datasource.dart';

class TableRepositoryImpl implements TableRepository {
  final TableRemoteDataSource remoteDataSource;
  TableRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, TableEntity>> getTableByQr(String qrCode) async {
    try {
      final table = await remoteDataSource.getTableByQr(qrCode);
      return Right(table);
    } catch (e) {
      return Left(ServerFailure.custom(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> occupyTable(int tableId) async {
    try {
      await remoteDataSource.occupyTable(tableId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure.custom(e.toString()));
    }
  }

  @override
  Future<TableEntity> updateTableAvailability({
    required int tableId,
    required bool isAvailable,
  }) async {
    try {
      final table = await remoteDataSource.updateTableAvailability(
        tableId: tableId,
        isAvailable: isAvailable,
      );
      return table;
    } catch (e) {
      throw Exception('Failed to update table availability: $e');
    }
  }

  @override
  Future<List<TableEntity>> getAllTables() async {
    try {
      final tables = await remoteDataSource.getAllTables();
      return tables;
    } catch (e) {
      throw Exception('Failed to get all tables: $e');
    }
  }
}
