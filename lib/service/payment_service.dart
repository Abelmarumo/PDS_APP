import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:stripe_payment/stripe_payment.dart';

class StripeTransaction {
  String message;
  bool success;
  StripeTransaction({this.message, this.success});
}

class StripeService {
  static String apiBase = 'https://api.stripe.com//v1';
  static String paymentApiUrl = '${StripeService.apiBase}/payment_intents';
  static String secret =
      'sk_test_51IIDGEAiNopIXmAERuvs5nynjSHAfz4QGn1iWV1yMUHM2Zdht7BPZNwyqgI09Xl0yh7KWePx4WD5cBdPKSxb5uEX00hiw5cvi1';
  static Map<String, String> headers = {
    'Authorization': 'Bearer ${StripeService.secret}',
    'Content-Type': 'application/x-www-form-urlencoded'
  };
  static init() {
    StripePayment.setOptions(StripeOptions(
        publishableKey:
            "pk_test_51IIDGEAiNopIXmAEsoX36ZHJ3HqMfq5uCT4Z5ZKVJKdgyRNtcm0Y5TGNrPQ5mj2X4Xvw7oe35BZIwAiEUHz7pcSi00wKXt8yQR",
        merchantId: "Test",
        androidPayMode: 'test'));
  }

  static Future<StripeTransaction> payViaExistingCard(
      {String amount, String curr, CreditCard card}) async {
    try {
      var paymentMethod = await StripePayment.createPaymentMethod(
          PaymentMethodRequest(card: card));
      var paymentIntent = await StripeService.createPaymentIntent(amount, curr);
      var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
          clientSecret: paymentIntent['client_secret'],
          paymentMethodId: paymentMethod.id));
      if (response.status == 'succeeded') {
        return StripeTransaction(
            message: 'Transaction successful', success: true);
       } else {
        return StripeTransaction(
            message: 'Transaction Unsuccessful', success: false);
      }
    } catch (e) {
      return StripeTransaction(
          message: 'Transaction Unsuccessful', success: false);
    }
  }

  static Future<StripeTransaction> payWithNewCard(
      {String amount, String curr}) async {
    try {
      var paymentMethod = await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest());
      var paymentIntent = await StripeService.createPaymentIntent(amount, curr);
      var response = await StripePayment.confirmPaymentIntent(
          PaymentIntent(
          clientSecret: paymentIntent['client_secret'],
          paymentMethodId: paymentMethod.id));
      if (response.status == 'succeeded') {
        return StripeTransaction(
            message: 'Transaction successful', success: true);
      } else {
        return StripeTransaction(
            message: 'Transaction Unsuccessful', success: false);
      }
    } catch (e) {
      return StripeTransaction(
          message: 'Transaction Unsuccessful', success: false);
    }
  }

  static Future<Map<String, dynamic>> createPaymentIntent(
      String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
          StripeService.paymentApiUrl,
          body: body,
          headers: StripeService.headers);
      return jsonDecode(response.body);
    } catch (e) {
      print(e);
    }
    return null;
  }
}
