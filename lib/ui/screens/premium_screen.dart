import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PremiumScreen extends StatefulWidget {
  @override
  _PremiumScreenState createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<ProductDetails> _products = [];
  bool _isAvailable = false;

  @override
  void initState() {
    super.initState();
    final Stream<List<PurchaseDetails>> purchaseUpdated = _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // Gérer l'erreur
    });

    _initStoreInfo();
  }

  Future<void> _initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = [];
      });
      return;
    }

    // Identifiants des produits (à configurer sur App Store Connect / Google Play Console)
    const Set<String> _kIds = <String>{'premium_reports_monthly'};
    final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails(_kIds);

    if (response.notFoundIDs.isNotEmpty) {
      // Gérer les produits non trouvés
    }

    setState(() {
      _isAvailable = isAvailable;
      _products = response.productDetails;
    });
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // Afficher un indicateur de chargement
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          // Gérer l'erreur
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
                   purchaseDetails.status == PurchaseStatus.restored) {
          // Débloquer le contenu premium
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Achat réussi !')));
        }
        if (purchaseDetails.pendingCompletePurchase) {
          _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }

  void _buyProduct(ProductDetails productDetails) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);
    _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Devenir Premium"),
      ),
      body: _isAvailable
          ? ListView(
              children: [
                if (_products.isEmpty)
                  const Center(child: Text("Aucun produit à vendre pour le moment."))
                else
                  for (var product in _products)
                    ListTile(
                      title: Text(product.title),
                      subtitle: Text(product.description),
                      trailing: Text(product.price),
                      onTap: () => _buyProduct(product),
                    ),
              ],
            )
          : const Center(
              child: Text("La boutique n'est pas disponible pour le moment."),
            ),
    );
  }
}
