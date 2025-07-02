import 'package:ekod_alumni/src/features/jobs/application/job_offer_controller.dart';
import 'package:ekod_alumni/src/features/jobs/application/job_offer_service.dart';
import 'package:ekod_alumni/src/features/jobs/domain/job_offer.dart';
import 'package:ekod_alumni/src/features/jobs/view/job_offer_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ListJob extends ConsumerStatefulWidget {
  const ListJob({super.key, this.showAppBar = true});

  final bool showAppBar;

  @override
  ConsumerState<ListJob> createState() => _ListJobState();
}

class _ListJobState extends ConsumerState<ListJob> {
  final TextEditingController _searchController = TextEditingController();
  bool _showFilters = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(jobOfferControllerProvider);
    final citiesAsync = ref.watch(availableCitiesProvider);

    final Widget bodyContent = Column(
      children: [
        // Barre de recherche et filtres
        _buildSearchAndFilters(state, citiesAsync),

        // Liste des offres
        Expanded(
          child: _buildJobsList(state),
        ),
      ],
    );

    if (widget.showAppBar) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Offres d'emploi"),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: Icon(
                _showFilters ? Icons.filter_list_off : Icons.filter_list,
                color: const Color(0xFFE53E3E),
              ),
              onPressed: () {
                setState(() {
                  _showFilters = !_showFilters;
                });
              },
            ),
          ],
        ),
        body: bodyContent,
      );
    } else {
      return bodyContent;
    }
  }

  Widget _buildSearchAndFilters(
    JobOffersState state,
    AsyncValue<List<String>> citiesAsync,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Barre de recherche
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Rechercher une offre...',
              prefixIcon: const Icon(Icons.search, color: Color(0xFFE53E3E)),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        ref
                            .read(jobOfferControllerProvider.notifier)
                            .searchOffers('');
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xFFE53E3E), width: 2),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
            onChanged: (value) {
              setState(() {}); // Pour mettre à jour l'icône clear
              Future.delayed(const Duration(milliseconds: 300), () {
                if (_searchController.text == value) {
                  ref
                      .read(jobOfferControllerProvider.notifier)
                      .searchOffers(value);
                }
              });
            },
          ),

          // Filtres (si affichés)
          if (_showFilters) ...[
            const SizedBox(height: 16),
            _buildFilters(state, citiesAsync),
          ],

          // Résumé des filtres actifs
          if (_hasActiveFilters(state)) ...[
            const SizedBox(height: 12),
            _buildActiveFiltersChips(state),
          ],
        ],
      ),
    );
  }

  Widget _buildFilters(
    JobOffersState state,
    AsyncValue<List<String>> citiesAsync,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Filtres par type
        const Text(
          "Type d'offre",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildTypeChip('Tous', state.selectedType == null, () {
                ref
                    .read(jobOfferControllerProvider.notifier)
                    .filterByType(null);
              }),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildTypeChip(
                  'Emplois', state.selectedType == JobOfferType.emploi, () {
                ref
                    .read(jobOfferControllerProvider.notifier)
                    .filterByType(JobOfferType.emploi);
              }),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildTypeChip(
                  'Stages', state.selectedType == JobOfferType.stage, () {
                ref
                    .read(jobOfferControllerProvider.notifier)
                    .filterByType(JobOfferType.stage);
              }),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Filtre par ville
        const Text(
          'Ville',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        citiesAsync.when(
          data: (cities) => DropdownButtonFormField<String>(
            value: state.selectedCity,
            decoration: InputDecoration(
              hintText: 'Toutes les villes',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: [
              const DropdownMenuItem<String>(
                child: Text('Toutes les villes'),
              ),
              ...cities.map(
                (city) => DropdownMenuItem<String>(
                  value: city,
                  child: Text(city),
                ),
              ),
            ],
            onChanged: (city) {
              ref.read(jobOfferControllerProvider.notifier).filterByCity(city);
            },
          ),
          loading: () => const SizedBox(
            height: 48,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, __) => const Text('Erreur lors du chargement des villes'),
        ),

        const SizedBox(height: 16),

        // Boutons d'action
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  _searchController.clear();
                  ref.read(jobOfferControllerProvider.notifier).clearFilters();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey[600],
                  side: BorderSide(color: Colors.grey[300]!),
                ),
                icon: const Icon(Icons.clear_all, size: 18),
                label: const Text('Effacer'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  ref.read(jobOfferControllerProvider.notifier).refresh();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE53E3E),
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Actualiser'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE53E3E) : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? null : Border.all(color: Colors.grey[300]!),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  bool _hasActiveFilters(JobOffersState state) {
    return state.searchTerm.isNotEmpty ||
        state.selectedType != null ||
        (state.selectedCity != null && state.selectedCity!.isNotEmpty);
  }

  Widget _buildActiveFiltersChips(JobOffersState state) {
    final chips = <Widget>[];

    if (state.searchTerm.isNotEmpty) {
      chips.add(
        _buildFilterChip(
          'Recherche: "${state.searchTerm}"',
          () => ref.read(jobOfferControllerProvider.notifier).searchOffers(''),
        ),
      );
    }

    if (state.selectedType != null) {
      chips.add(
        _buildFilterChip(
          'Type: ${state.selectedType!.displayName}',
          () =>
              ref.read(jobOfferControllerProvider.notifier).filterByType(null),
        ),
      );
    }

    if (state.selectedCity != null && state.selectedCity!.isNotEmpty) {
      chips.add(
        _buildFilterChip(
          'Ville: ${state.selectedCity}',
          () =>
              ref.read(jobOfferControllerProvider.notifier).filterByCity(null),
        ),
      );
    }

    return Wrap(
      spacing: 8,
      children: chips,
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onRemove) {
    return Chip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      onDeleted: onRemove,
      deleteIcon: const Icon(Icons.close, size: 16),
      backgroundColor: const Color(0xFFE53E3E).withOpacity(0.1),
      deleteIconColor: const Color(0xFFE53E3E),
      side: BorderSide.none,
    );
  }

  Widget _buildJobsList(JobOffersState state) {
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE53E3E)),
        ),
      );
    }

    if (state.error != null) {
      return Center(
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
              state.error!,
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () =>
                  ref.read(jobOfferControllerProvider.notifier).refresh(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE53E3E),
                foregroundColor: Colors.white,
              ),
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    if (state.offers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.work_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              _hasActiveFilters(state)
                  ? 'Aucun résultat trouvé'
                  : 'Aucune offre disponible',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _hasActiveFilters(state)
                  ? 'Essayez de modifier vos critères de recherche'
                  : 'Revenez bientôt pour de nouvelles opportunités !',
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            if (_hasActiveFilters(state)) ...[
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  _searchController.clear();
                  ref.read(jobOfferControllerProvider.notifier).clearFilters();
                },
                child: const Text('Effacer tous les filtres'),
              ),
            ],
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.read(jobOfferControllerProvider.notifier).refresh();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: state.offers.length + 1, // +1 pour les stats
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildResultsHeader(state.offers.length);
          }

          final jobOffer = state.offers[index - 1];
          return _JobOfferCard(
            jobOffer: jobOffer,
            onTap: () => _navigateToDetail(context, jobOffer.id),
          );
        },
      ),
    );
  }

  Widget _buildResultsHeader(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        '$count offre${count > 1 ? 's' : ''} trouvée${count > 1 ? 's' : ''}',
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
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
