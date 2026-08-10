import 'dart:developer';
import 'dart:io';
import 'package:a_tareqaak/core/routes/app_routes.dart';
import 'package:a_tareqaak/main.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class LaunchUrlHelper {
  static Future<void> whatsapp(String phone, [String? message]) async {
    String url() {
      if (Platform.isAndroid) {
        return "https://wa.me/$phone/?text=${Uri.encodeComponent(message ?? '')}";
      } else {
        return "https://api.whatsapp.com/send?phone=$phone&text=${Uri.encodeComponent(message ?? '')}";
      }
    }

    await launchUrl(Uri.parse(url()));
  }

  static Future<void> call(String phone) async {
    await launchUrl(Uri(scheme: 'tel', path: phone));
  }

  static Future<void> launchUrlPage(String url) async {
    final Uri uri = Uri.parse(url);

    if (await _handleInternalDeepLink(uri)) {
      return;
    }

    if (!await launchUrl(uri)) {
      log('****************Could not launch $url');
    }
  }

  static Future<bool> _handleInternalDeepLink(Uri uri) async {
    if (!(uri.scheme == 'https' || uri.scheme == 'http')) return false;

    final String host = uri.host.toLowerCase();
    if (host != 'qwafil.sa' && host != 'www.qwafil.sa') return false;

    final context = navigatorKey.currentContext;
    if (context == null) return false;

    final List<String> segments = uri.pathSegments.where((segment) => segment.isNotEmpty).toList();

    // if (segments.isNotEmpty && segments.first == 'annual-auctions') {
    //   if (segments.length > 1) {
    //     final location = await resolveAnnualAuctionDeepLinkLocation(segments[1]);
    //     if (location != null && context.mounted) {
    //       GoRouter.of(context).push(location);
    //       return true;
    //     }
    //     return false;
    //   }
    //
    //   GoRouter.of(context).push(AnnualAuctionsRoute(initialTabIndex: 0, showTabBar: false).location);
    //   return true;
    // }
    //
    // if (segments.isNotEmpty && segments.first == 'offer_details' && segments.length > 1) {
    //   final offerId = segments[1];
    //   GoRouter.of(context).push(
    //     OfferDetailsRoute(
    //       id: offerId,
    //       heroTag: null,
    //       isDashboard: false,
    //     ).location,
    //   );
    //   return true;
    // }
    //
    // if (segments.isNotEmpty && segments.first == 'auctions_details' && segments.length > 1) {
    //   final auctionId = segments[1];
    //   GoRouter.of(context).push(
    //     AuctionsDetailsRoute(
    //       id: auctionId,
    //       heroTag: '',
    //       isSingleAuction: false,
    //       isDashboard: false,
    //     ).location,
    //   );
    //   return true;
    // }

    final queryString = uri.query.isEmpty ? '' : '?${uri.query}';
    GoRouter.of(context).push('${uri.path}$queryString');
    return true;
  }
}
