import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:ekod_alumni/src/features/jobs/application/job_offer_service.dart';
import 'package:ekod_alumni/src/features/jobs/domain/job_offer.dart';
import 'package:ekod_alumni/src/features/jobs/view/job_offer_detail_page.dart';

class ListJob extends ConsumerWidget {
  const ListJob({super.key, this.showAppBar = true});

  final bool showAppBar;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobOffersAsync = ref.watch(allActiveJobOffersProvider);

    final listView = jobOffersAsync.when(
      data: (jobOffers) {
        if (jobOffers.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.work_off, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Aucune offre disponible',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Revenez bientôt pour découvrir de nouvelles opportunités !',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: jobOffers.length,
          itemBuilder: (context, index) {
            final jobOffer = jobOffers[index];
            return _JobOfferCard(
              jobOffer: jobOffer,
              onTap: () => _navigateToDetail(context, jobOffer.id),
            );
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE53E3E)),
        ),
      ),
      error: (error, stackTrace) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Color(0xFFE53E3E), size: 64),
            const SizedBox(height: 16),
            Text(
              'Erreur lors du chargement',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              "Impossible de charger les offres d'emploi",
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.refresh(allActiveJobOffersProvider),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE53E3E),
                foregroundColor: Colors.white,
              ),
              child: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );

    if (showAppBar) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Offres d'emploi"),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: listView,
      );
    } else {
      return listView;
    }
  }

  void _navigateToDetail(BuildContext context, String jobOfferId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => JobOfferDetailPage(jobOfferId: jobOfferId),
      ),
    );
  }
}

class _JobOfferCard extends StatelessWidget {
  const _JobOfferCard({
    required this.jobOffer,
    required this.onTap,
  });

  final JobOffer jobOffer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête avec badges
              Row(
                children: [
                  _buildBadge(
                    jobOffer.type.displayName,
                    _getJobTypeColor(jobOffer.type),
                  ),
                  const Spacer(),
                  Icon(
                    jobOffer.type == JobOfferType.stage
                        ? Icons.school
                        : Icons.work,
                    color: Colors.grey[400],
                    size: 20,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Titre
              Text(
                jobOffer.titre,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8),

              // Entreprise et ville
              Row(
                children: [
                  const Icon(Icons.business, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      jobOffer.entreprise,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    jobOffer.ville,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Description courte
              Text(
                jobOffer.shortDescription,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 16),

              // Footer avec date limite et statut
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 14,
                    color: jobOffer.isExpired ? Colors.red : Colors.orange,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    jobOffer.deadlineText,
                    style: TextStyle(
                      fontSize: 12,
                      color:
                          jobOffer.isExpired ? Colors.red : Colors.orange[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE53E3E).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Voir détails',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFE53E3E),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getJobTypeColor(JobOfferType type) {
    switch (type) {
      case JobOfferType.emploi:
        return Colors.green;
      case JobOfferType.stage:
        return Colors.blue;
    }
  }
}
