import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/theme/theme_helper.dart';
import '../../../cart/domain/entities/cart_entity.dart';

class QrScannerPage extends StatefulWidget {
  final CartEntity cart;
  const QrScannerPage({super.key, required this.cart});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool _isScanning = true;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  // لا نحتاج dispose() بعد الآن - المكتبة تتعامل معه تلقائياً
  // @override
  // void dispose() {
  //   controller?.dispose();
  //   super.dispose();
  // }

  String? extractTableId(String qr) {
    // Try different QR code patterns
    final patterns = [
      RegExp(r'TABLE_(\d+)_'), // TABLE_123_
      RegExp(r'table:(\d+)'), // table:123
      RegExp(r'^(\d+)$'), // Just numbers
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(qr.toLowerCase());
      if (match != null) {
        return match.group(1);
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      appBar: AppBar(
        backgroundColor: ThemeHelper.getBackgroundColor(context),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: ThemeHelper.getPrimaryTextColor(context),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'مسح QR الطاولة',
          style: AppTextStyles.senBold18(
            context,
          ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Instructions
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(16.w),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.lightPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: AppColors.lightPrimary.withOpacity(0.3),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.qr_code_scanner,
                  color: AppColors.lightPrimary,
                  size: 32.sp,
                ),
                SizedBox(height: 8.h),
                Text(
                  'وجه الكاميرا نحو QR الموجود على الطاولة',
                  style: AppTextStyles.senMedium14(
                    context,
                  ).copyWith(color: AppColors.lightPrimary),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // QR Scanner
          Expanded(
            flex: 5,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  overlay: QrScannerOverlayShape(
                    borderColor: AppColors.lightPrimary,
                    borderRadius: 16.r,
                    borderLength: 40.w,
                    borderWidth: 4.w,
                    cutOutSize: 250.w,
                  ),
                ),
              ),
            ),
          ),

          // Status and result
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isScanning && result == null) ...[
                      Icon(
                        Icons.search,
                        color: ThemeHelper.getSecondaryTextColor(context),
                        size: 32.sp,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'جاري البحث عن QR...',
                        style: AppTextStyles.senMedium16(context).copyWith(
                          color: ThemeHelper.getSecondaryTextColor(context),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ] else if (result != null) ...[
                      Icon(Icons.check_circle, color: Colors.green, size: 32.sp),
                      SizedBox(height: 8.h),
                      Text(
                        'تم العثور على QR!',
                        style: AppTextStyles.senBold16(
                          context,
                        ).copyWith(color: Colors.green),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'الكود: ${result?.code ?? ''}',
                        style: AppTextStyles.senRegular14(context).copyWith(
                          color: ThemeHelper.getSecondaryTextColor(context),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],

                    SizedBox(height: 16.h),

                    // Retry button
                    if (!_isScanning)
                      ElevatedButton.icon(
                        onPressed: _retryScanning,
                        icon: Icon(Icons.refresh, size: 20.sp),
                        label: Text(
                          'إعادة المحاولة',
                          style: AppTextStyles.senMedium16(context),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.lightPrimary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 12.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (_isScanning && result == null) {
        setState(() {
          result = scanData;
          _isScanning = false;
        });

        final qrString = scanData.code ?? '';
        controller.pauseCamera();

        if (qrString.isNotEmpty) {
          // Return the QR code back to the table selection step
          Navigator.of(context).pop({'qrCode': qrString, 'success': true});
        } else {
          _showErrorAndRetry('QR code غير صالح!');
        }
      }
    });
  }

  void _retryScanning() {
    setState(() {
      result = null;
      _isScanning = true;
    });
    controller?.resumeCamera();
  }

  void _showErrorAndRetry(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'إعادة المحاولة',
          textColor: Colors.white,
          onPressed: _retryScanning,
        ),
      ),
    );

    setState(() {
      _isScanning = false;
    });
  }
}