part of 'table_cubit.dart';

abstract class TableState {}

class TableInitial extends TableState {}

class TableLoading extends TableState {}

class TableLoaded extends TableState {
  final TableEntity table;
  TableLoaded(this.table);
}

class TableOccupying extends TableState {}

class TableOccupied extends TableState {}

class TableError extends TableState {
  final String message;
  TableError(this.message);
}
