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
}
