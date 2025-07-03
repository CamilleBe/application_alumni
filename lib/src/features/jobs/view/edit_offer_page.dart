import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Page pour éditer une offre d'emploi existante
class EditOfferPage extends ConsumerStatefulWidget {
  const EditOfferPage({
    required this.offerId,
    super.key,
  });

  final String offerId;

  static const String routeName = '/edit-offer';

  @override
  ConsumerState<EditOfferPage> createState() => _EditOfferPageState();
}

class _EditOfferPageState extends ConsumerState<EditOfferPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modifier l'offre"),
      ),
      body: const Center(
        child: Text("Page d'édition d'offre"),
      ),
    );
  }
}
