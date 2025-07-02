import 'package:ekod_alumni/src/features/alumni/alumni.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// {@template alumni_filters_widget}
/// Widget de filtres avancés pour l'annuaire alumni
/// {@endtemplate}
class AlumniFiltersWidget extends ConsumerStatefulWidget {
  /// {@macro alumni_filters_widget}
  const AlumniFiltersWidget({
    required this.onFiltersChanged,
    super.key,
  });

  final void Function(AlumniFilters filters) onFiltersChanged;

  @override
  ConsumerState<AlumniFiltersWidget> createState() =>
      _AlumniFiltersWidgetState();
}

class _AlumniFiltersWidgetState extends ConsumerState<AlumniFiltersWidget> {
  String? _selectedCity;
  String? _selectedCompany;
  String? _selectedYear;
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final citiesAsync = ref.watch(availableCitiesProvider);
    final companiesAsync = ref.watch(availableCompaniesProvider);
    final yearsAsync = ref.watch(availableYearsProvider);

    // Debug : afficher les données dans la console
    citiesAsync.whenData((cities) {
      if (kDebugMode) {
        print('🏙️ Villes disponibles: $cities');
      }
    });

    companiesAsync.whenData((companies) {
      if (kDebugMode) {
        print('🏢 Entreprises disponibles: $companies');
      }
    });

    yearsAsync.whenData((years) {
      if (kDebugMode) {
        print('📅 Années disponibles: $years');
      }
    });

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          // En-tête du filtre
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.filter_list,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Filtres avancés',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  const Spacer(),
                  // Indicateur de filtres actifs
                  if (_hasActiveFilters()) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE53E3E),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getActiveFiltersCount().toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ),
          ),

          // Contenu des filtres
          if (_isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Filtres en trois colonnes
                  Row(
                    children: [
                      // Filtre ville
                      Expanded(
                        child: citiesAsync.when(
                          data: _buildCityFilter,
                          loading: () => _buildLoadingDropdown('Ville'),
                          error: (_, __) => _buildErrorDropdown('Ville'),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Filtre entreprise
                      Expanded(
                        child: companiesAsync.when(
                          data: _buildCompanyFilter,
                          loading: () => _buildLoadingDropdown('Entreprise'),
                          error: (_, __) => _buildErrorDropdown('Entreprise'),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Filtre année
                      Expanded(
                        child: yearsAsync.when(
                          data: _buildYearFilter,
                          loading: () => _buildLoadingDropdown('Promotion'),
                          error: (_, __) => _buildErrorDropdown('Promotion'),
                        ),
                      ),
                    ],
                  ),

                  // Bouton reset si des filtres sont actifs
                  if (_hasActiveFilters()) ...[
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: _resetFilters,
                        icon: const Icon(
                          Icons.clear,
                          size: 16,
                          color: Color(0xFFE53E3E),
                        ),
                        label: const Text(
                          'Réinitialiser',
                          style: TextStyle(
                            color: Color(0xFFE53E3E),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCityFilter(List<String> cities) {
    return DropdownButtonFormField<String>(
      value: _selectedCity,
      decoration: const InputDecoration(
        labelText: 'Ville',
        prefixIcon: Icon(Icons.location_on, size: 20),
        border: OutlineInputBorder(),
        isDense: true,
      ),
      items: [
        const DropdownMenuItem<String>(
          child: Text('Toutes'),
        ),
        ...cities.map(
          (city) => DropdownMenuItem<String>(
            value: city,
            child: Text(city),
          ),
        ),
      ],
      onChanged: (value) {
        setState(() {
          _selectedCity = value;
        });
        _notifyFiltersChanged();
      },
    );
  }

  Widget _buildCompanyFilter(List<String> companies) {
    return DropdownButtonFormField<String>(
      value: _selectedCompany,
      decoration: const InputDecoration(
        labelText: 'Entreprise',
        prefixIcon: Icon(Icons.business, size: 20),
        border: OutlineInputBorder(),
        isDense: true,
      ),
      items: [
        const DropdownMenuItem<String>(
          child: Text('Toutes'),
        ),
        ...companies.map(
          (company) => DropdownMenuItem<String>(
            value: company,
            child: Text(company),
          ),
        ),
      ],
      onChanged: (value) {
        setState(() {
          _selectedCompany = value;
        });
        _notifyFiltersChanged();
      },
    );
  }

  Widget _buildYearFilter(List<String> years) {
    return DropdownButtonFormField<String>(
      value: _selectedYear,
      decoration: const InputDecoration(
        labelText: 'Promotion',
        prefixIcon: Icon(Icons.school, size: 20),
        border: OutlineInputBorder(),
        isDense: true,
      ),
      items: [
        const DropdownMenuItem<String>(
          child: Text('Toutes'),
        ),
        ...years.map(
          (year) => DropdownMenuItem<String>(
            value: year,
            child: Text(year),
          ),
        ),
      ],
      onChanged: (value) {
        setState(() {
          _selectedYear = value;
        });
        _notifyFiltersChanged();
      },
    );
  }

  Widget _buildLoadingDropdown(String label) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const SizedBox(
          width: 20,
          height: 20,
          child: Center(
            child: SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE53E3E)),
              ),
            ),
          ),
        ),
        border: const OutlineInputBorder(),
        isDense: true,
      ),
      items: const [
        DropdownMenuItem<String>(
          child: Text('Chargement...'),
        ),
      ],
      onChanged: null,
    );
  }

  Widget _buildErrorDropdown(String label) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          Icons.error_outline,
          size: 20,
          color: Colors.red[300],
        ),
        border: const OutlineInputBorder(),
        isDense: true,
      ),
      items: const [
        DropdownMenuItem<String>(
          child: Text('Erreur de chargement'),
        ),
      ],
      onChanged: null,
    );
  }

  bool _hasActiveFilters() {
    return _selectedCity != null ||
        _selectedCompany != null ||
        _selectedYear != null;
  }

  int _getActiveFiltersCount() {
    var count = 0;
    if (_selectedCity != null) count++;
    if (_selectedCompany != null) count++;
    if (_selectedYear != null) count++;
    return count;
  }

  void _resetFilters() {
    setState(() {
      _selectedCity = null;
      _selectedCompany = null;
      _selectedYear = null;
    });
    _notifyFiltersChanged();
  }

  void _notifyFiltersChanged() {
    widget.onFiltersChanged(
      AlumniFilters(
        city: _selectedCity,
        company: _selectedCompany,
        year: _selectedYear,
      ),
    );
  }
}

/// {@template alumni_filters}
/// Classe pour encapsuler les filtres actifs
/// {@endtemplate}
@immutable
class AlumniFilters {
  /// {@macro alumni_filters}
  const AlumniFilters({
    this.city,
    this.company,
    this.year,
  });

  final String? city;
  final String? company;
  final String? year;

  bool get hasActiveFilters => city != null || company != null || year != null;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AlumniFilters &&
        other.city == city &&
        other.company == company &&
        other.year == year;
  }

  @override
  int get hashCode => Object.hash(city, company, year);
}
