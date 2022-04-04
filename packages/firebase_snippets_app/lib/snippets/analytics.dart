// Copyright 2022 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// ignore_for_file: non_constant_identifier_names, avoid_print, unused_local_variable

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_snippets_app/snippets/snippet_base.dart';

class AnalyticsSnippets extends DocSnippet {
  @override
  void runAll() {
    analytics_startLoggingEvents();
    analytics_predefinedEvents();
    analytics_setUserProperties();
    analytics_trackScreens();
    setUserId_setUserId();
    measureECommerce_implementation();
    measureAdRevenue_moPub();
  }

  void analytics_startLoggingEvents() async {
    // [START analytics_start_logging_events]
    await FirebaseAnalytics.instance.logBeginCheckout(
        value: 10.0,
        currency: 'USD',
        items: [
          AnalyticsEventItem(
            itemName: 'Socks',
            itemId: 'xjw73ndnw',
            price: 10.0,
          ),
        ],
        coupon: '10PERCENTOFF');
    // [END analytics_start_logging_events]
  }

  void analytics_predefinedEvents() async {
    const itemId = "1234";
    // [START analytics_predefined_events]
    await FirebaseAnalytics.instance.logSelectContent(
      contentType: "image",
      itemId: itemId,
    );
    // [END analytics_predefined_events]

    // [START analytics_predefined_events2]
    await FirebaseAnalytics.instance.logEvent(
      name: "select_content",
      parameters: {
        "content_type": "image",
        "item_id": itemId,
      },
    );
    // [END analytics_predefined_events2]

    const name = "rivers.jpg";
    const text = "this be the full text";

    // [START analytics_custom_events]
    await FirebaseAnalytics.instance.logEvent(
      name: "share_image",
      parameters: {
        "image_name": name,
        "full_text": text,
      },
    );
    // [END analytics_custom_events]

    // [START analytics_set_default_parameters]
    // Not supported on web
    await FirebaseAnalytics.instance.setDefaultEventParameters(
      {'version': '1.2.3'},
    );
    // [END analytics_set_default_parameters]
  }

  void analytics_setUserProperties() async {
    const favoriteFood = "banana";
    // [START analytics_set_user_properties]
    await FirebaseAnalytics.instance.setUserProperty(
      name: 'favorite_food',
      value: favoriteFood,
    );
    // [END analytics_set_user_properties]
  }

  void analytics_trackScreens() async {
    // [START analytics_track_screens]
    await FirebaseAnalytics.instance.setCurrentScreen(
      screenName: 'Products',
    );
    // [END analytics_track_screens]
  }

  void setUserId_setUserId() async {
    // [START set_user_id_set_user_id]
    FirebaseAnalytics.instance.setUserId(id: "123456");
    // [END set_user_id_set_user_id]
  }

  void measureECommerce_implementation() async {
    // [START measure_e_commerce_implementation]
    // A pair of jeggings
    final jeggings = AnalyticsEventItem(
      itemId: "SKU_123",
      itemName: "jeggings",
      itemCategory: "pants",
      itemVariant: "black",
      itemBrand: "Google",
      price: 9.99,
    );
    // A pair of boots
    final boots = AnalyticsEventItem(
      itemId: "SKU_456",
      itemName: "boots",
      itemCategory: "shoes",
      itemVariant: "brown",
      itemBrand: "Google",
      price: 24.99,
    );
    // A pair of socks
    final socks = AnalyticsEventItem(
      itemId: "SKU_789",
      itemName: "ankle_socks",
      itemCategory: "socks",
      itemVariant: "red",
      itemBrand: "Google",
      price: 5.99,
    );
    // [END measure_e_commerce_implementation]

    // [START measure_e_commerce_select_product_from_list]
    await FirebaseAnalytics.instance.logViewItemList(
      itemListId: "L001",
      itemListName: "Related products",
      items: [jeggings, boots, socks],
    );
    // [END measure_e_commerce_select_product_from_list]

    // [START measure_e_commerce_log_select_item]
    await FirebaseAnalytics.instance.logSelectItem(
      itemListId: "L001",
      itemListName: "Related products",
      items: [jeggings],
    );
    // [END measure_e_commerce_log_select_item]

    // [START measure_e_commerce_log_view_item]
    await FirebaseAnalytics.instance.logViewItem(
      currency: 'USD',
      value: 9.99,
      items: [jeggings],
    );
    // [END measure_e_commerce_log_view_item]

    // [START measure_e_commerce_log_add_to_cart]
    final jeggingsWithQuantity = AnalyticsEventItem(
      itemId: jeggings.itemId,
      itemName: jeggings.itemName,
      itemCategory: jeggings.itemCategory,
      itemVariant: jeggings.itemVariant,
      itemBrand: jeggings.itemBrand,
      price: jeggings.price,
      quantity: 2,
    );
    await FirebaseAnalytics.instance.logAddToWishlist(
      currency: 'USD',
      value: 19.98,
      items: [jeggingsWithQuantity],
    );
    await FirebaseAnalytics.instance.logAddToCart(
      currency: 'USD',
      value: 19.98,
      items: [jeggingsWithQuantity],
    );
    // [END measure_e_commerce_log_add_to_cart]

    // [START measure_e_commerce_log_view_cart]
    await FirebaseAnalytics.instance.logViewCart(
      currency: 'USD',
      value: 19.98,
      items: [jeggingsWithQuantity],
    );
    // [END measure_e_commerce_log_view_cart]

    // [START measure_e_commerce_log_remove_from_cart]
    await FirebaseAnalytics.instance.logRemoveFromCart(
      currency: 'USD',
      value: 9.99,
      items: [jeggingsWithQuantity],
    );
    // [END measure_e_commerce_log_remove_from_cart]

    // [START measure_e_commerce_log_checkout_begin]
    await FirebaseAnalytics.instance.logBeginCheckout(
      currency: 'USD',
      value: 15.98, // Discount applied.
      coupon: "SUMMER_FUN",
      items: [jeggingsWithQuantity],
    );
    // [END measure_e_commerce_log_checkout_begin]

    // [START measure_e_commerce_log_shipping_info]
    await FirebaseAnalytics.instance.logAddShippingInfo(
      currency: 'USD',
      value: 15.98,
      coupon: "SUMMER_FUN",
      shippingTier: "Ground",
      items: [jeggingsWithQuantity],
    );
    // [END measure_e_commerce_log_shipping_info]

    // [START measure_e_commerce_log_payment_info]
    await FirebaseAnalytics.instance.logAddPaymentInfo(
      currency: 'USD',
      value: 15.98,
      coupon: "SUMMER_FUN",
      paymentType: "Visa",
      items: [jeggingsWithQuantity],
    );
    // [END measure_e_commerce_log_payment_info]

    // [START measure_e_commerce_log_purchase]
    await FirebaseAnalytics.instance.logPurchase(
      transactionId: "12345",
      affiliation: "Google Store",
      currency: 'USD',
      value: 15.98,
      shipping: 2.00,
      tax: 1.66,
      coupon: "SUMMER_FUN",
      items: [jeggingsWithQuantity],
    );
    // [END measure_e_commerce_log_purchase]

    // [START measure_e_commerce_log_refund]
    await FirebaseAnalytics.instance.logRefund(
      transactionId: "12345",
      affiliation: "Google Store",
      currency: 'USD',
      value: 15.98,
      items: [jeggingsWithQuantity],
    );
    // [END measure_e_commerce_log_refund]

    // [START measure_e_commerce_log_promo]
    await FirebaseAnalytics.instance.logViewPromotion(
      promotionId: "SUMMER_FUN",
      promotionName: "Summer Sale",
      creativeName: "summer2020_promo.jpg",
      creativeSlot: "featured_app_1",
      locationId: "HERO_BANNER",
    );
    await FirebaseAnalytics.instance.logSelectPromotion(
      promotionId: "SUMMER_FUN",
      promotionName: "Summer Sale",
      creativeName: "summer2020_promo.jpg",
      creativeSlot: "featured_app_1",
      locationId: "HERO_BANNER",
    );
    // [END measure_e_commerce_log_promo]
  }

  void measureAdRevenue_moPub() async {
    // [START measure_ad_revenue_mo_pub]
    FirebaseAnalytics.instance.logAdImpression(
      adPlatform: "MoPub",
      adSource: "",
      adFormat: "",
      adUnitName: "",
      value: 10.0,
      currency: "",
    );
    // [END measure_ad_revenue_mo_pub]
  }
}
