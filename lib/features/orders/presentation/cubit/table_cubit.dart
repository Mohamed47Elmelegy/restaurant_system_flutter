import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/table_entity.dart';
import '../../domain/repositories/table_repository.dart';

part 'table_state.dart';

class TableCubit extends Cubit<TableState> {
  final TableRepository repository;
  TableCubit(this.repository) : super(TableInitial());

  Future<void> getTableByQr(String qrCode) async {
    emit(TableLoading());
    final result = await repository.getTableByQr(qrCode);
    result.fold(
      (failure) => emit(TableError(failure.message)),
      (table) => emit(TableLoaded(table)),
    );
  }

  Future<void> occupyTable(int tableId) async {
    emit(TableOccupying());
    final result = await repository.occupyTable(tableId);
    result.fold(
      (failure) => emit(TableError(failure.message)),
      (_) => emit(TableOccupied()),
    );
  }
}
