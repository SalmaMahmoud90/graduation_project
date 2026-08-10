import 'package:permission_handler/permission_handler.dart';

extension PermissionHandlerExtension on Permission {
  Future<void> onPermissionStatus({
    required Function() onDeniedCallback,
    required Function() onGrantedCallback,
    required Function() onPermanentlyDeniedCallback,
    Function()? onRestrictedCallback,
    Function()? onLimitedCallback,
    Function()? onProvisionalCallback,
  }) async {
    PermissionStatus permissionStatus = await status;

    if (permissionStatus.isDenied) {
      onDeniedCallback();
    } else if (permissionStatus.isGranted) {
      onGrantedCallback();
    } else if (permissionStatus.isPermanentlyDenied) {
      onPermanentlyDeniedCallback();
    } else if (permissionStatus.isRestricted && onRestrictedCallback != null) {
      onRestrictedCallback();
    } else if (permissionStatus.isLimited && onLimitedCallback != null) {
      onLimitedCallback();
      } else if (permissionStatus.isProvisional && onProvisionalCallback != null) {
      onProvisionalCallback();
    }

    // If permission is denied, request permission
    if (permissionStatus.isDenied) {
      PermissionStatus newStatus = await request();
      if (newStatus.isGranted) {
        onGrantedCallback();
      } else if (newStatus.isPermanentlyDenied) {
        onPermanentlyDeniedCallback();
      }
    }
  }
}
