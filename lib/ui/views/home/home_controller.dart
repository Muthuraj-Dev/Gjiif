import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tjw1/core/model/tjw/banner_event_response.dart';
import 'package:tjw1/core/model/tjw/today_rate_card.dart';

import '../../../locator.dart';
import '../../../services/api_base_service.dart';
import '../../../services/appconfig_service.dart';
import '../../../services/request_method.dart';

class HomeController extends GetxController {
  RxBool isLoading = false.obs;

  RxList<String> bannerImages = <String>[].obs;
  RxList<EventsList> eventList = <EventsList>[].obs;

  RxList<RateCardData> rateCardDataList = <RateCardData>[].obs;

  RxInt currentImageIndex = 0.obs;

  final config = locator<AppConfigService>().config;

  // Banner/rate-card data now requires an auth token, so it is not fetched
  // in onInit() (this controller is created pre-login to satisfy
  // DashboardScreen's Get.find()) - it's kicked off from OtpController
  // right after OTP verification succeeds instead.

  Future<void> fetchBannerEvent({bool forceRefresh = false}) async {
    try {
      isLoading(true);
      BannerEventResponse response =
          await ApiBaseService.request<BannerEventResponse>(
            'SQ/GetBannerForHomeScreen',
            method: RequestMethod.GET,
            authenticated: true,
          );

      if (response.status == "200") {
        final newBannerUrls =
            response.bannerEventData?.bannerList
                    ?.map((e) => e.bannerURL ?? '')
                    .toList() ??
                [];

        if (forceRefresh) {
          // Banner URLs are stable even when the backend swaps the image
          // behind them, so CachedNetworkImage would otherwise keep
          // serving the stale bytes it already has for that URL.
          final urlsToEvict = {...bannerImages, ...newBannerUrls}
            ..removeWhere((url) => url.isEmpty);
          for (final url in urlsToEvict) {
            await CachedNetworkImage.evictFromCache(url);
          }
        }

        bannerImages.assignAll(newBannerUrls);
        eventList.value = response.bannerEventData?.eventsList ?? [];
      }
    } catch (e) {
      print('Error fetching products: $e');
    } finally {
      isLoading(false);
    }
  }
  String getMonth(String? date) {
    if (date == null || date.isEmpty) return "--";

    try {
      return DateFormat('MMM')
          .format(DateTime.parse(date))
          .toUpperCase();
    } catch (_) {
      return "--";
    }
  }
  String getDay(String? date) {
    if (date == null || date.isEmpty) return "--";

    try {
      return DateFormat('d').format(DateTime.parse(date));
    } catch (_) {
      return "--";
    }
  }
  String getYear(String? date) {
    if (date == null || date.isEmpty) return "--";

    try {
      return DateFormat('yyyy').format(DateTime.parse(date));
    } catch (_) {
      return "--";
    }
  }

  String getFormattedDate(String? date) {
    if (date == null || date.isEmpty) return "";

    try {
      return DateFormat('dd MMM yyyy')
          .format(DateTime.parse(date));
    } catch (_) {
      return date;
    }
  }

  DateTime? rateDatetime;

  fetchRateCard() async {
    try {
      isLoading(true);
      TodaysRateCard response = await ApiBaseService.request<TodaysRateCard>(
        'SQ/TodaysRateCard',
        method: RequestMethod.GET,
        authenticated: true,
      );

      if (response.status == "200") {
        rateCardDataList.value = response.rateCardData ?? [];

        String rawDate = response.rateCardData?.first.rateDate ?? '';

        print("========== $rawDate");
        rateDatetime = DateTime.parse(rawDate);
      }
    } catch (e) {
      print('Error fetching products: $e');
    } finally {
      isLoading(false);
    }
  }

  void updateBanners() {
    bannerImages.clear();
    final newConfig = locator<AppConfigService>().config;
    if (newConfig.banners != null && newConfig.banners!.isNotEmpty) {
      bannerImages.assignAll(newConfig.banners!);
    }
    bannerImages.refresh();
  }

  Future<bool> refreshRemoteConfig() async {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: Duration(seconds: 10),
          minimumFetchInterval: Duration(seconds: 0),
        ),
      );
      bool activated = await remoteConfig.fetchAndActivate();
      if (activated) {
        final rawJson = remoteConfig.getString('config');
        final Map<String, dynamic> configMap = jsonDecode(rawJson);
        locator<AppConfigService>().setConfig(configMap);
        updateBanners();
      }
      return activated;
    } catch (e) {
      debugPrint('Failed to refresh === remote config: $e');
      return false;
    }
  }
}

