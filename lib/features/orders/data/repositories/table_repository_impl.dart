// // lib/features/order/data/repositories/table_repository_impl.dart
// import 'dart:developer';
// import 'package:dartz/dartz.dart';
// import '../../../../core/error/failures.dart';
// import '../datasources/table_remote_datasource.dart';

// /// 🟨 Table Repository Implementation
// /// تنسيق العمليات بين Domain Layer و Data Layer للطاولات
// class TableRepositoryImpl implements TableRepository {
//   final TableRemoteDataSource remoteDataSource;
//   final NetworkInfo networkInfo;

//   const TableRepositoryImpl({
//     required this.remoteDataSource,
//     required this.networkInfo,
//   });

//   @override
//   Future<Either<Failure, TableEntity>> getTableByQRCode(String qrCode) async {
//     if (await networkInfo.isConnected) {
//       try {
//         log('🔄 TableRepositoryImpl: Getting table by QR code: $qrCode');
        
//         final tableModel = await remoteDataSource.getTableByQRCode(qrCode);
        
//         log('✅ TableRepositoryImpl: Table retrieved successfully');
//         log('📄 Table: ${tableModel.name} (ID: ${tableModel.id})');
        
//         return Right(tableModel.toEntity());
//       } catch (e) {
//         log('❌ TableRepositoryImpl: Error getting table by QR - $e');
        
//         // تحديد نوع الخطأ بناءً على رسالة الاستثناء
//         if (e.toString().contains('QR كود غير صحيح') || 
//             e.toString().contains('غير موجودة')) {
//           return Left(ServerFailure(message: 'QR كود غير صحيح أو الطاولة غير موجودة'));
//         } else if (e.toString().contains('محجوزة')) {
//           return Left(ServerFailure(message: 'الطاولة محجوزة حالياً'));
//         } else if (e.toString().contains('خطأ في الشبكة')) {
//           return Left(ServerFailure(message: 'خطأ في الاتصال بالخادم'));
//         }

//         return Left(ServerFailure(message: 'حدث خطأ أثناء جلب بيانات الطاولة'));
//       }
//     } else {
//       log('❌ TableRepositoryImpl: No internet connection');
//       return Left(NetworkFailure(message: 'لا يوجد اتصال بالإنترنت'));
//     }
//   }

//   @override
//   Future<Either<Failure, List<TableEntity>>> getAvailableTables() async {
//     if (await networkInfo.isConnected) {
//       try {
//         log('🔄 TableRepositoryImpl: Getting available tables');
        
//         final tableModels = await remoteDataSource.getAvailableTables();
//         final tables = tableModels.map((model) => model.toEntity()).toList();
        
//         log('✅ TableRepositoryImpl: ${tables.length} tables retrieved');
//         return Right(tables);
//       } catch (e) {
//         log('❌ TableRepositoryImpl: Error getting tables - $e');
        
//         if (e.toString().contains('خطأ في الشبكة')) {
//           return Left(ServerFailure(message: 'خطأ في الاتصال بالخادم'));
//         }

//         return Left(ServerFailure(message: 'حدث خطأ أثناء جلب الطاولات'));
//       }
//     } else {
//       log('❌ TableRepositoryImpl: No internet connection');
//       return Left(NetworkFailure(message: 'لا يوجد اتصال بالإنترنت'));
//     }
//   }

//   @override
//   Future<Either<Failure, void>> occupyTable(int tableId) async {
//     if (await networkInfo.isConnected) {
//       try {
//         log('🔄 TableRepositoryImpl: Occupying table $tableId');
        
//         await remoteDataSource.occupyTable(tableId);
        
//         log('✅ TableRepositoryImpl: Table occupied successfully');
//         return const Right(null);
//       } catch (e) {
//         log('❌ TableRepositoryImpl: Error occupying table - $e');
        
//         if (e.toString().contains('محجوزة')) {
//           return Left(ServerFailure(message: 'الطاولة محجوزة بالفعل'));
//         } else if (e.toString().contains('غير موجودة')) {
//           return Left(ServerFailure(message: 'الطاولة غير موجودة'));
//         } else if (e.toString().contains('خطأ في الشبكة')) {
//           return Left(ServerFailure(message: 'خطأ في الاتصال بالخادم'));
//         }

//         return Left(ServerFailure(message: 'حدث خطأ أثناء حجز الطاولة'));
//       }
//     } else {
//       log('❌ TableRepositoryImpl: No internet connection');
//       return Left(NetworkFailure(message:   'لا يوجد اتصال بالإنترنت'));
//     }
//   }
// }