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
    measureAdRevenue_moPub();
    measureEcommerce_implementation();
    measureECommerce_selectProductFromList();
    measureAdRevenue_moPub();
    measureECommerce_logSelectItem();
    measureECommerce_logViewItem();
    measureECommerce_logAddToCart();
    measureECommerce_logViewCart();
    measureECommerce_logRemoveFromCart();
    measureECommerce_logCheckoutBegin();
    measureECommerce_logShippingInfo();
    measureECommerce_logPaymentInfo();
    measureECommerce_logPurchase();
    measureECommerce_logRefund();
    measureECommerce_logPromo();
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
    // [START analytics_predefined_events]
    await FirebaseAnalytics.instance.logSelectContent(
      contentType: "image",
      itemId: '1234',
    );
    // [END analytics_predefined_events]

    // [START analytics_predefined_events2]
    await FirebaseAnalytics.instance.logEvent(
      name: "select_content",
      parameters: {
        "content_type": "image",
        "item_id": '1234',
      },
    );
    // [END analytics_predefined_events2]

    // [START analytics_custom_events]
    await FirebaseAnalytics.instance.logEvent(
      name: "share_image",
      parameters: {
        "image_name": 'rivers.jpg',
        "full_text": 'This is the full text.',
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
    // [START analytics_set_user_properties]
    await FirebaseAnalytics.instance.setUserProperty(
      name: 'favorite_food',
      value: 'banana',
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

  void measureEcommerce_implementation() async {
    // [START measure_ecommerce_implementation]
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
    // [END measure_ecommerce_implementation]
  }

  void measureECommerce_selectProductFromList() async {
    // [START measure_e_commerce_select_product_from_list]
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

    await FirebaseAnalytics.instance.logViewItemList(
      itemListId: "L001",
      itemListName: "Related products",
      items: [jeggings, boots, socks],
    );
    // [END measure_e_commerce_select_product_from_list]
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

  void measureECommerce_logSelectItem() async {
    // [START measure_e_commerce_log_select_item]
    // A pair of jeggings
    final jeggings = AnalyticsEventItem(
      itemId: "SKU_123",
      itemName: "jeggings",
      itemCategory: "pants",
      itemVariant: "black",
      itemBrand: "Google",
      price: 9.99,
    );

    await FirebaseAnalytics.instance.logSelectItem(
      itemListId: "L001",
      itemListName: "Related products",
      items: [jeggings],
    );
    // [END measure_e_commerce_log_select_item]
  }

  void measureECommerce_logViewItem() async {
    // [START measure_e_commerce_log_view_item]
    final jeggings = AnalyticsEventItem(
      itemId: "SKU_123",
      itemName: "jeggings",
      itemCategory: "pants",
      itemVariant: "black",
      itemBrand: "Google",
      price: 9.99,
    );

    await FirebaseAnalytics.instance.logViewItem(
      currency: 'USD',
      value: 9.99,
      items: [jeggings],
    );
    // [END measure_e_commerce_log_view_item]
  }

  void measureECommerce_logAddToCart() async {
    // [START measure_e_commerce_log_add_to_cart]
    final jeggings = AnalyticsEventItem(
      itemId: "SKU_123",
      itemName: "jeggings",
      itemCategory: "pants",
      itemVariant: "black",
      itemBrand: "Google",
      price: 9.99,
    );

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
  }

  void measureECommerce_logViewCart() async {
    // [START measure_e_commerce_log_view_cart]
    final jeggings = AnalyticsEventItem(
      itemId: "SKU_123",
      itemName: "jeggings",
      itemCategory: "pants",
      itemVariant: "black",
      itemBrand: "Google",
      price: 9.99,
    );

    final jeggingsWithQuantity = AnalyticsEventItem(
      itemId: jeggings.itemId,
      itemName: jeggings.itemName,
      itemCategory: jeggings.itemCategory,
      itemVariant: jeggings.itemVariant,
      itemBrand: jeggings.itemBrand,
      price: jeggings.price,
      quantity: 2,
    );
    await FirebaseAnalytics.instance.logViewCart(
      currency: 'USD',
      value: 19.98,
      items: [jeggingsWithQuantity],
    );
    // [END measure_e_commerce_log_view_cart]
  }

  void measureECommerce_logRemoveFromCart() async {
    // [START measure_e_commerce_log_remove_from_cart]
    final jeggings = AnalyticsEventItem(
      itemId: "SKU_123",
      itemName: "jeggings",
      itemCategory: "pants",
      itemVariant: "black",
      itemBrand: "Google",
      price: 9.99,
    );

    final jeggingsWithQuantity = AnalyticsEventItem(
      itemId: jeggings.itemId,
      itemName: jeggings.itemName,
      itemCategory: jeggings.itemCategory,
      itemVariant: jeggings.itemVariant,
      itemBrand: jeggings.itemBrand,
      price: jeggings.price,
      quantity: 2,
    );
    await FirebaseAnalytics.instance.logRemoveFromCart(
      currency: 'USD',
      value: 9.99,
      items: [jeggingsWithQuantity],
    );
    // [END measure_e_commerce_log_remove_from_cart]
  }

  void measureECommerce_logCheckoutBegin() async {
    // [START measure_e_commerce_log_checkout_begin]
    final jeggings = AnalyticsEventItem(
      itemId: "SKU_123",
      itemName: "jeggings",
      itemCategory: "pants",
      itemVariant: "black",
      itemBrand: "Google",
      price: 9.99,
    );

    final jeggingsWithQuantity = AnalyticsEventItem(
      itemId: jeggings.itemId,
      itemName: jeggings.itemName,
      itemCategory: jeggings.itemCategory,
      itemVariant: jeggings.itemVariant,
      itemBrand: jeggings.itemBrand,
      price: jeggings.price,
      quantity: 2,
    );
    await FirebaseAnalytics.instance.logBeginCheckout(
      currency: 'USD',
      value: 15.98, // Discount applied.
      coupon: "SUMMER_FUN",
      items: [jeggingsWithQuantity],
    );
    // [END measure_e_commerce_log_checkout_begin]
  }

  void measureECommerce_logShippingInfo() async {
    // [START measure_e_commerce_log_shipping_info]
    final jeggings = AnalyticsEventItem(
      itemId: "SKU_123",
      itemName: "jeggings",
      itemCategory: "pants",
      itemVariant: "black",
      itemBrand: "Google",
      price: 9.99,
    );

    final jeggingsWithQuantity = AnalyticsEventItem(
      itemId: jeggings.itemId,
      itemName: jeggings.itemName,
      itemCategory: jeggings.itemCategory,
      itemVariant: jeggings.itemVariant,
      itemBrand: jeggings.itemBrand,
      price: jeggings.price,
      quantity: 2,
    );
    await FirebaseAnalytics.instance.logAddShippingInfo(
      currency: 'USD',
      value: 15.98,
      coupon: "SUMMER_FUN",
      shippingTier: "Ground",
      items: [jeggingsWithQuantity],
    );
    // [END measure_e_commerce_log_shipping_info]
  }

  void measureECommerce_logPaymentInfo() async {
    // [START measure_e_commerce_log_payment_info]
    final jeggings = AnalyticsEventItem(
      itemId: "SKU_123",
      itemName: "jeggings",
      itemCategory: "pants",
      itemVariant: "black",
      itemBrand: "Google",
      price: 9.99,
    );

    final jeggingsWithQuantity = AnalyticsEventItem(
      itemId: jeggings.itemId,
      itemName: jeggings.itemName,
      itemCategory: jeggings.itemCategory,
      itemVariant: jeggings.itemVariant,
      itemBrand: jeggings.itemBrand,
      price: jeggings.price,
      quantity: 2,
    );
    await FirebaseAnalytics.instance.logAddPaymentInfo(
      currency: 'USD',
      value: 15.98,
      coupon: "SUMMER_FUN",
      paymentType: "Visa",
      items: [jeggingsWithQuantity],
    );
    // [END measure_e_commerce_log_payment_info]
  }

  void measureECommerce_logPurchase() async {
    // [START measure_e_commerce_log_purchase]
    final jeggings = AnalyticsEventItem(
      itemId: "SKU_123",
      itemName: "jeggings",
      itemCategory: "pants",
      itemVariant: "black",
      itemBrand: "Google",
      price: 9.99,
    );

    final jeggingsWithQuantity = AnalyticsEventItem(
      itemId: jeggings.itemId,
      itemName: jeggings.itemName,
      itemCategory: jeggings.itemCategory,
      itemVariant: jeggings.itemVariant,
      itemBrand: jeggings.itemBrand,
      price: jeggings.price,
      quantity: 2,
    );
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
  }

  void measureECommerce_logRefund() async {
    // [START measure_e_commerce_log_refund]
    final jeggings = AnalyticsEventItem(
      itemId: "SKU_123",
      itemName: "jeggings",
      itemCategory: "pants",
      itemVariant: "black",
      itemBrand: "Google",
      price: 9.99,
    );

    final jeggingsWithQuantity = AnalyticsEventItem(
      itemId: jeggings.itemId,
      itemName: jeggings.itemName,
      itemCategory: jeggings.itemCategory,
      itemVariant: jeggings.itemVariant,
      itemBrand: jeggings.itemBrand,
      price: jeggings.price,
      quantity: 2,
    );
    await FirebaseAnalytics.instance.logRefund(
      transactionId: "12345",
      affiliation: "Google Store",
      currency: 'USD',
      value: 15.98,
      items: [jeggingsWithQuantity],
    );
    // [END measure_e_commerce_log_refund]
  }

  void measureECommerce_logPromo() async {
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
}
