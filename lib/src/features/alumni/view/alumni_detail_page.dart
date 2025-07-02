import 'package:ekod_alumni/src/features/alumni/alumni.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// {@template alumni_detail_page}
/// Page de détail pour un alumni spécifique
/// {@endtemplate}
class AlumniDetailPage extends ConsumerWidget {
  /// {@macro alumni_detail_page}
  const AlumniDetailPage({
    required this.alumniId,
    super.key,
  });

  final String alumniId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alumniAsync = ref.watch(alumniByIdProvider(alumniId));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: alumniAsync.when(
          data: (alumni) => Text(
            alumni?.fullName ?? 'Profil Alumni',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          loading: () => const Text(
            'Chargement...',
            style: TextStyle(color: Colors.black),
          ),
          error: (_, __) => const Text(
            'Erreur',
            style: TextStyle(color: Colors.black),
          ),
        ),
        centerTitle: true,
      ),
      body: alumniAsync.when(
        data: (alumni) {
          if (alumni == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_off,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Alumni non trouvé',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // En-tête avec photo et informations principales
                  _buildHeader(alumni),

                  const SizedBox(height: 24),

                  // Section Bio
                  if (alumni.bio?.isNotEmpty == true) ...[
                    _buildSection(
                      title: 'À propos',
                      icon: Icons.info_outline,
                      content: _buildBioContent(alumni.bio!),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Section Informations professionnelles
                  _buildSection(
                    title: 'Informations professionnelles',
                    icon: Icons.work_outline,
                    content: _buildProfessionalContent(alumni),
                  ),

                  const SizedBox(height: 24),

                  // Section Contact (placeholder pour plus tard)
                  _buildSection(
                    title: 'Contact',
                    icon: Icons.contact_mail_outlined,
                    content: _buildContactContent(alumni, context),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
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
              const Icon(
                Icons.error_outline,
                color: Color(0xFFE53E3E),
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                'Erreur lors du chargement',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
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
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE53E3E),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Retour'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Alumni alumni) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE53E3E).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE53E3E).withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          // Photo de profil (placeholder pour l'instant)
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFE53E3E),
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: alumni.profileImageUrl?.isNotEmpty == true
                ? ClipOval(
                    child: Image.network(
                      alumni.profileImageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildInitials(alumni),
                    ),
                  )
                : _buildInitials(alumni),
          ),

          const SizedBox(height: 16),

          // Nom complet
          Text(
            alumni.fullName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          // Badge de statut
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE53E3E),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.school, size: 16, color: Colors.white),
                const SizedBox(width: 6),
                Text(
                  alumni.statut ?? 'Alumni',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitials(Alumni alumni) {
    final initials =
        '${alumni.firstName[0]}${alumni.lastName[0]}'.toUpperCase();
    return Center(
      child: Text(
        initials,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget content,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: const Color(0xFFE53E3E),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          content,
        ],
      ),
    );
  }

  Widget _buildBioContent(String bio) {
    return Text(
      bio,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black87,
        height: 1.5,
      ),
    );
  }

  Widget _buildProfessionalContent(Alumni alumni) {
    final hasEntreprise = alumni.entreprise?.isNotEmpty == true;
    final hasPoste = alumni.poste?.isNotEmpty == true;
    final hasVille = alumni.ville?.isNotEmpty == true;
    final hasAnnee = alumni.anneePromotion?.isNotEmpty == true;

    if (!hasEntreprise && !hasPoste && !hasVille && !hasAnnee) {
      return Text(
        'Aucune information professionnelle renseignée',
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
          fontStyle: FontStyle.italic,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasEntreprise && hasPoste) ...[
          _buildInfoRow(
            Icons.business,
            'Poste actuel',
            '${alumni.poste} chez ${alumni.entreprise}',
          ),
          const SizedBox(height: 12),
        ] else if (hasEntreprise) ...[
          _buildInfoRow(Icons.business, 'Entreprise', alumni.entreprise!),
          const SizedBox(height: 12),
        ] else if (hasPoste) ...[
          _buildInfoRow(Icons.work, 'Poste', alumni.poste!),
          const SizedBox(height: 12),
        ],
        if (hasVille) ...[
          _buildInfoRow(Icons.location_on, 'Localisation', alumni.ville!),
          const SizedBox(height: 12),
        ],
        if (hasAnnee) ...[
          _buildInfoRow(
            Icons.school,
            'Promotion',
            'Diplômé(e) en ${alumni.anneePromotion}',
          ),
        ],
      ],
    );
  }

  Widget _buildContactContent(Alumni alumni, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(Icons.email, 'Email', alumni.email),
        const SizedBox(height: 16),

        // Boutons d'action (placeholders pour plus tard)
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implémenter l'envoi d'email
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Fonctionnalité à venir'),
                      backgroundColor: Color(0xFFE53E3E),
                    ),
                  );
                },
                icon: const Icon(Icons.email, size: 18),
                label: const Text('Contacter'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE53E3E),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  // TODO: Implémenter l'ajout aux favoris
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Fonctionnalité à venir'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                },
                icon: const Icon(Icons.favorite_border, size: 18),
                label: const Text('Favoris'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFE53E3E),
                  side: const BorderSide(color: Color(0xFFE53E3E)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
