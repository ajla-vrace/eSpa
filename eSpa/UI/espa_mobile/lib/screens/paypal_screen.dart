import 'dart:convert';
import 'package:espa_mobile/screens/rezervacije.dart';
import 'package:espa_mobile/screens/success_page.dart';
import '../models/rezervacija.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';
import 'cancel_page.dart';

class PayPalScreen extends StatefulWidget {
  final Rezervacija? lastRezervacija;
  final double totalAmount;

  PayPalScreen({super.key, this.lastRezervacija, required this.totalAmount});

  @override
  _PayPalScreenState createState() => _PayPalScreenState();
}

class _PayPalScreenState extends State<PayPalScreen> {
  bool isLoading = true;
  late final Rezervacija? _lastRezervacija;
  late final double _totalAmount;
  //late WebViewController _controller;

  final String clientId =
      'AVAs14k98jjGL2WGraUOAV-K7wX-NFi6drg23O6QN3_850-eksaGutYE4984ZYFPsfnmKuF0TAQI3kwy';
  final String clientSecret =
      'EL100ISAG9wWwWGRmB3iAxQiMoRSP4nDOKp8ZsVHYVbwne_QhxxmVhrFtwVxZVpceEbPuRpH2Bq3j0q1';

  final String _paypalBaseUrl = 'https://api.sandbox.paypal.com'; // Sandbox URL

  @override
  void initState() {
    super.initState();

    _lastRezervacija = widget.lastRezervacija;
    _totalAmount = widget.totalAmount;

    _startPaymentProcess();
  }

  Future<void> _startPaymentProcess() async {
    try {
      final accessToken = await _getAccessToken();
      final orderUrl = await _createOrder(accessToken, _totalAmount);
      _redirectToPayPal(orderUrl);
    } catch (e) {
      print("Error during PayPal payment process: $e");
      _showErrorDialog("Greška prilikom procesa plačanja");
    }
  }

  Future<String> _getAccessToken() async {
    final response = await http.post(
      Uri.parse('$_paypalBaseUrl/v1/oauth2/token'),
      headers: {
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: 'grant_type=client_credentials',
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['access_token'];
    } else {
      _showErrorDialog("Neuspelo dobijanje PayPal tokena");
      throw Exception('Failed to obtain PayPal access token');
    }
  }

  Future<String> _createOrder(String accessToken, double total) async {
    final response = await http.post(
      Uri.parse('$_paypalBaseUrl/v2/checkout/orders'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'intent': 'CAPTURE',
        'purchase_units': [
          {
            'amount': {
              'currency_code': 'EUR',
              'value': total,
            },
          },
        ],
        'application_context': {
          'return_url': 'https://your-success-url.com',
          'cancel_url': 'https://your-cancel-url.com',
        }
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final approvalUrl =
          data['links'].firstWhere((link) => link['rel'] == 'approve')['href'];
      return approvalUrl;
    } else {
      _showErrorDialog("Neuspelo kreiranje PayPal porudžbine");
      throw Exception('Failed to create PayPal order');
    }
  }

  void _redirectToPayPal(String approvalUrl) {
    final webviewController = _createWebViewController(approvalUrl);

    Navigator.of(context).push(MaterialPageRoute(builder: (builder) {
      return Scaffold(
        body: WebViewWidget(
          controller: webviewController,
        ),
      );
    }));
  }

  WebViewController _createWebViewController(String approvalUrl) {
    return WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (url) {
            setState(() {
              isLoading = false;
            });
          },
          onNavigationRequest: (request) {
            final url = request.url;

            if (url.startsWith('https://your-success-url.com')) {
              print("Payment successful");

              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => SuccessPage(
                    lastRezervacija: _lastRezervacija,
                  ),
                ),
              );
            }

            if (url.startsWith('https://your-cancel-url.com')) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) =>  CancelPage(lastRezervacija:_lastRezervacija),
                ),
              );
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(approvalUrl));
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Greška'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Zatvori'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: (!isLoading)
                ? ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => RezervacijeScreen(), //parametri
                        ),
                      );
                    },
                    child: const Text("Nazad"),
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }
}
