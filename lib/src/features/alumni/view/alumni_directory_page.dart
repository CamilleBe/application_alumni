import 'package:ekod_alumni/src/features/alumni/alumni.dart';
import 'package:ekod_alumni/src/features/authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// {@template alumni_directory_page}
/// Page d'annuaire des alumni avec liste et recherche
/// {@endtemplate}
class AlumniDirectoryPage extends ConsumerWidget {
  /// {@macro alumni_directory_page}
  const AlumniDirectoryPage({super.key});

  static const String routeName = '/alumni-directory';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alumniAsync = ref.watch(alumniStreamProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Annuaire Alumni',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authRepositoryProvider).signOut(),
          ),
        ],
      ),
      body: alumniAsync.when(
        data: (List<Alumni> alumni) => AlumniDirectoryView(alumni: alumni),
        loading: () => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE53E3E)),
          ),
        ),
        error: (Object error, StackTrace stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Color(0xFFE53E3E),
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                "Erreur lors du chargement de l'annuaire",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget principal pour l'affichage de l'annuaire
class AlumniDirectoryView extends ConsumerStatefulWidget {
  const AlumniDirectoryView({
    required this.alumni,
    super.key,
  });

  final List<Alumni> alumni;

  @override
  ConsumerState<AlumniDirectoryView> createState() =>
      _AlumniDirectoryViewState();
}

class _AlumniDirectoryViewState extends ConsumerState<AlumniDirectoryView> {
  final TextEditingController _searchController = TextEditingController();
  List<Alumni> _filteredAlumni = [];
  String _searchTerm = '';
  AlumniFilters _currentFilters = const AlumniFilters();

  @override
  void initState() {
    super.initState();
    _filteredAlumni = widget.alumni;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void didUpdateWidget(AlumniDirectoryView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.alumni != oldWidget.alumni) {
      _filterAlumni();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchTerm = _searchController.text;
      _filterAlumni();
    });
  }

  void _onFiltersChanged(AlumniFilters filters) {
    setState(() {
      _currentFilters = filters;
      _filterAlumni();
    });
  }

  void _filterAlumni() {
    var filteredList = widget.alumni;

    // Filtrage par recherche textuelle
    if (_searchTerm.isNotEmpty) {
      final searchLower = _searchTerm.toLowerCase();
      filteredList = filteredList.where((alumni) {
        final fullNameLower = alumni.fullName.toLowerCase();
        final entrepriseLower = (alumni.entreprise ?? '').toLowerCase();
        final villeLower = (alumni.ville ?? '').toLowerCase();

        return fullNameLower.contains(searchLower) ||
            entrepriseLower.contains(searchLower) ||
            villeLower.contains(searchLower);
      }).toList();
    }

    // Filtrage par ville
    if (_currentFilters.city != null) {
      filteredList = filteredList.where((alumni) {
        return alumni.ville == _currentFilters.city;
      }).toList();
    }

    // Filtrage par entreprise
    if (_currentFilters.company != null) {
      filteredList = filteredList.where((alumni) {
        return alumni.entreprise == _currentFilters.company;
      }).toList();
    }

    // Filtrage par année de promotion
    if (_currentFilters.year != null) {
      filteredList = filteredList.where((alumni) {
        return alumni.anneePromotion == _currentFilters.year;
      }).toList();
    }

    _filteredAlumni = filteredList;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Barre de recherche
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Rechercher par nom, entreprise ou ville...',
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Widget de filtres avancés
          AlumniFiltersWidget(
            onFiltersChanged: _onFiltersChanged,
          ),

          // Compteur de résultats
          Row(
            children: [
              Text(
                '${_filteredAlumni.length} Alumni'
                '${_filteredAlumni.length > 1 ? 's' : ''}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              if (_searchTerm.isNotEmpty ||
                  _currentFilters.hasActiveFilters) ...[
                const SizedBox(width: 8),
                Text(
                  'trouvé${_filteredAlumni.length > 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                if (_currentFilters.hasActiveFilters) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE53E3E).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Filtré',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFE53E3E),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ],
          ),

          const SizedBox(height: 16),

          // Liste des alumni
          Expanded(
            child: _filteredAlumni.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    itemCount: _filteredAlumni.length,
                    itemBuilder: (context, index) {
                      final alumni = _filteredAlumni[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: AlumniCard(alumni: alumni),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    if (_searchTerm.isEmpty && !_currentFilters.hasActiveFilters) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Aucun alumni inscrit',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Les alumni apparaîtront ici une fois inscrits',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Aucun résultat',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _searchTerm.isNotEmpty
                  ? 'Aucun alumni ne correspond à "$_searchTerm"'
                  : 'Aucun alumni ne correspond aux filtres sélectionnés',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            if (_searchTerm.isNotEmpty || _currentFilters.hasActiveFilters)
              TextButton(
                onPressed: () {
                  if (_searchTerm.isNotEmpty) {
                    _searchController.clear();
                  }
                  if (_currentFilters.hasActiveFilters) {
                    setState(() {
                      _currentFilters = const AlumniFilters();
                      _filterAlumni();
                    });
                  }
                },
                child: Text(
                  _searchTerm.isNotEmpty && _currentFilters.hasActiveFilters
                      ? 'Effacer recherche et filtres'
                      : _searchTerm.isNotEmpty
                          ? 'Effacer la recherche'
                          : 'Effacer les filtres',
                  style: const TextStyle(color: Color(0xFFE53E3E)),
                ),
              ),
          ],
        ),
      );
    }
  }
}

/// Widget de carte pour un alumni
class AlumniCard extends StatelessWidget {
  const AlumniCard({
    required this.alumni,
    super.key,
  });

  final Alumni alumni;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: InkWell(
        onTap: () {
          // Navigation vers la page de détail
          context.go('/alumni/${alumni.id}');
        },
        child: Row(
          children: [
            // Photo de profil
            CircleAvatar(
              radius: 30,
              backgroundColor: const Color(0xFFE53E3E),
              backgroundImage: alumni.profileImageUrl != null
                  ? NetworkImage(alumni.profileImageUrl!)
                  : null,
              child: alumni.profileImageUrl == null
                  ? Text(
                      alumni.firstName.isNotEmpty && alumni.lastName.isNotEmpty
                          ? '${alumni.firstName[0]}${alumni.lastName[0]}'
                          : alumni.firstName.isNotEmpty
                              ? alumni.firstName[0]
                              : '?',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),

            const SizedBox(width: 16),

            // Informations
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nom complet
                  Text(
                    alumni.fullName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Entreprise et poste
                  if (alumni.entreprise != null || alumni.poste != null) ...[
                    Text(
                      [
                        if (alumni.poste != null) alumni.poste!,
                        if (alumni.entreprise != null) alumni.entreprise!,
                      ].join(' chez '),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],

                  // Ville et année de promotion
                  Row(
                    children: [
                      if (alumni.ville != null) ...[
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          alumni.ville!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                      if (alumni.ville != null && alumni.anneePromotion != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Container(
                            width: 2,
                            height: 2,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      if (alumni.anneePromotion != null) ...[
                        Icon(
                          Icons.school,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Promotion ${alumni.anneePromotion}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Icône de navigation
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}
