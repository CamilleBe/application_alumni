import 'package:ekod_alumni/src/features/jobs/application/job_offer_service.dart';
import 'package:ekod_alumni/src/features/jobs/domain/job_offer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

/// {@template job_offer_detail_page}
/// Page de détail pour une offre d'emploi spécifique
/// {@endtemplate}
class JobOfferDetailPage extends ConsumerWidget {
  /// {@macro job_offer_detail_page}
  const JobOfferDetailPage({
    required this.jobOfferId,
    super.key,
  });

  final String jobOfferId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobOfferAsync = ref.watch(jobOfferByIdProvider(jobOfferId));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: jobOfferAsync.when(
          data: (jobOffer) => Text(
            jobOffer?.titre ?? "Offre d'emploi",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black),
            onPressed: () => _shareJobOffer(jobOfferAsync.value),
          ),
        ],
      ),
      body: jobOfferAsync.when(
        data: (jobOffer) {
          if (jobOffer == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.work_off,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Offre non trouvée',
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(jobOffer),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSection(
                        title: 'Description du poste',
                        icon: Icons.description_outlined,
                        content: _buildDescriptionContent(jobOffer.description),
                      ),
                      const SizedBox(height: 24),
                      _buildSection(
                        title: 'Informations',
                        icon: Icons.info_outline,
                        content: _buildInfoContent(jobOffer),
                      ),
                      const SizedBox(height: 24),
                      _buildSection(
                        title: "À propos de l'entreprise",
                        icon: Icons.business_outlined,
                        content: _buildCompanyContent(jobOffer),
                      ),
                      const SizedBox(height: 32),
                      _buildActionButtons(context, jobOffer),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
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

  Widget _buildHeader(JobOffer jobOffer) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFE53E3E),
            const Color(0xFFE53E3E).withOpacity(0.8),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Badge de type et statut
            Row(
              children: [
                _buildBadge(
                  jobOffer.type.displayName,
                  _getJobTypeColor(jobOffer.type),
                ),
                const SizedBox(width: 8),
                _buildBadge(
                  jobOffer.statut.displayName,
                  _getStatusColor(jobOffer.statut),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    jobOffer.type == JobOfferType.stage
                        ? Icons.school
                        : Icons.work,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Titre
            Text(
              jobOffer.titre,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            // Entreprise et localisation
            Row(
              children: [
                const Icon(Icons.business, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    jobOffer.entreprise,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  jobOffer.ville,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Date limite
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.schedule, color: Colors.white, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    "Candidatures jusqu'au ${_formatDate(jobOffer.dateLimite)}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget content,
  }) {
    return Column(
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
    );
  }

  Widget _buildDescriptionContent(String description) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Text(
        description,
        style: const TextStyle(
          fontSize: 14,
          height: 1.5,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildInfoContent(JobOffer jobOffer) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE53E3E).withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE53E3E).withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          _buildInfoRow(
            'Type de poste',
            jobOffer.type.displayName,
            Icons.work_outline,
          ),
          const Divider(height: 24),
          _buildInfoRow(
            'Statut',
            jobOffer.statut.displayName,
            Icons.info_outline,
          ),
          const Divider(height: 24),
          _buildInfoRow(
            'Date de publication',
            _formatDate(jobOffer.datePublication),
            Icons.calendar_today,
          ),
          if (jobOffer.competencesRequises.isNotEmpty) ...[
            const Divider(height: 24),
            _buildInfoRow(
              'Compétences requises',
              jobOffer.competencesText,
              Icons.star_outline,
            ),
          ],
          if (jobOffer.typeContrat != null) ...[
            const Divider(height: 24),
            _buildInfoRow(
              'Type de contrat',
              jobOffer.typeContrat!,
              Icons.assignment,
            ),
          ],
          if (jobOffer.salaire != null) ...[
            const Divider(height: 24),
            _buildInfoRow(
              'Salaire',
              jobOffer.salaire!,
              Icons.euro_symbol,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCompanyContent(JobOffer jobOffer) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.business,
                  color: Colors.blue,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      jobOffer.entreprise,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.grey,
                        ),
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
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            "Cette offre provient du réseau des anciens élèves d'Ekod. L'entreprise ${jobOffer.entreprise} fait confiance à notre formation pour recruter ses futurs talents.",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
          if (jobOffer.urlEntreprise != null) ...[
            const SizedBox(height: 12),
            InkWell(
              onTap: () => _openCompanyWebsite(jobOffer.urlEntreprise!),
              child: Row(
                children: [
                  const Icon(Icons.language, size: 16, color: Colors.blue),
                  const SizedBox(width: 6),
                  Text(
                    'Visiter le site web',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue[700],
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: const Color(0xFFE53E3E)),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, JobOffer jobOffer) {
    final canApply = jobOffer.isActive;
    final currentUser = FirebaseAuth.instance.currentUser;
    final isOwner = currentUser?.uid == jobOffer.publisherId;

    return Column(
      children: [
        // Bouton d'édition pour le propriétaire
        if (isOwner) ...[
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () => context.go('/edit-offer/${jobOffer.id}'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE53E3E),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              icon: const Icon(Icons.edit),
              label: const Text(
                'Modifier cette offre',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],

        // Bouton principal de candidature (masqué pour le propriétaire)
        if (!isOwner) ...[
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed:
                  canApply ? () => _handleApply(context, jobOffer) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    canApply ? const Color(0xFFE53E3E) : Colors.grey[400],
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              icon: Icon(canApply ? Icons.send : Icons.block),
              label: Text(
                canApply
                    ? 'Postuler maintenant'
                    : _getDisabledButtonText(jobOffer),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],

        // Boutons secondaires
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _copyJobLink(context, jobOffer),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFE53E3E),
                  side: const BorderSide(color: Color(0xFFE53E3E)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                icon: const Icon(Icons.link, size: 18),
                label: const Text('Copier le lien'),
              ),
            ),
            const SizedBox(width: 12),
            if (isOwner)
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.go('/my-offers'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFE53E3E),
                    side: const BorderSide(color: Color(0xFFE53E3E)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  icon: const Icon(Icons.list_alt, size: 18),
                  label: const Text('Mes offres'),
                ),
              )
            else
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _contactRecruiter(context, jobOffer),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFE53E3E),
                    side: const BorderSide(color: Color(0xFFE53E3E)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  icon: const Icon(Icons.message, size: 18),
                  label: const Text('Contacter'),
                ),
              ),
          ],
        ),

        if (!canApply && !isOwner) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange[200]!),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.orange[700],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _getJobNotAvailableReason(jobOffer),
                    style: TextStyle(
                      color: Colors.orange[700],
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
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

  // Méthodes utilitaires
  Color _getJobTypeColor(JobOfferType type) {
    switch (type) {
      case JobOfferType.emploi:
        return Colors.green;
      case JobOfferType.stage:
        return Colors.blue;
    }
  }

  Color _getStatusColor(JobOfferStatus status) {
    switch (status) {
      case JobOfferStatus.active:
        return Colors.green;
      case JobOfferStatus.fermee:
        return Colors.orange;
      case JobOfferStatus.pourvue:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'jan',
      'fév',
      'mar',
      'avr',
      'mai',
      'jun',
      'jul',
      'aoû',
      'sep',
      'oct',
      'nov',
      'déc',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _getDisabledButtonText(JobOffer jobOffer) {
    if (jobOffer.statut != JobOfferStatus.active) {
      return jobOffer.statut == JobOfferStatus.pourvue
          ? 'Poste pourvu'
          : 'Offre fermée';
    }
    return 'Date limite dépassée';
  }

  String _getJobNotAvailableReason(JobOffer jobOffer) {
    if (jobOffer.statut == JobOfferStatus.pourvue) {
      return "Cette offre a été pourvue et n'accepte plus de candidatures.";
    } else if (jobOffer.statut == JobOfferStatus.fermee) {
      return 'Cette offre a été fermée par le recruteur.';
    } else if (jobOffer.isExpired) {
      return 'La date limite de candidature est dépassée.';
    }
    return "Cette offre n'est plus disponible.";
  }

  // Actions
  Future<void> _handleApply(BuildContext context, JobOffer jobOffer) async {
    if (jobOffer.contactEmail == null || jobOffer.contactEmail!.isEmpty) {
      // Fallback si pas d'email de contact
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aucun email de contact disponible pour cette offre'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    try {
      // Récupérer les informations du candidat
      final currentUser = FirebaseAuth.instance.currentUser;
      final candidateName = currentUser?.displayName ?? 'Candidat';

      // Construire l'email
      final subject = Uri.encodeComponent(
        'Candidature - ${jobOffer.titre} chez ${jobOffer.entreprise}',
      );

      final body = Uri.encodeComponent('''
Bonjour,

Je me permets de vous contacter suite à votre offre "${jobOffer.titre}" publiée sur la plateforme Ekod Alumni.

Je suis intéressé(e) par ce poste et souhaiterais vous proposer ma candidature.

Vous trouverez en pièce jointe mon CV et ma lettre de motivation.

Je reste à votre disposition pour tout complément d'information.

Cordialement,
$candidateName

---
Candidature envoyée via Ekod Alumni
Offre consultée le ${_formatDate(DateTime.now())}
''');

      final emailUrl =
          'mailto:${jobOffer.contactEmail}?subject=$subject&body=$body';
      final uri = Uri.parse(emailUrl);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);

        // Afficher un message de confirmation
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  "Application mail ouverte ! N'oubliez pas d'ajouter votre CV en pièce jointe."),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        throw "Impossible d'ouvrir l'application mail";
      }
    } catch (e) {
      if (context.mounted) {
        // Fallback : afficher les informations de contact
        _showEmailFallback(context, jobOffer);
      }
    }
  }

  void _showEmailFallback(BuildContext context, JobOffer jobOffer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Informations de contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Impossible d'ouvrir l'application mail automatiquement.\n\nVeuillez copier l'adresse email ci-dessous :",
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SelectableText(
                      jobOffer.contactEmail!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, size: 20),
                    onPressed: () {
                      Clipboard.setData(
                          ClipboardData(text: jobOffer.contactEmail!));
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Email copié dans le presse-papiers'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Objet suggéré :\nCandidature - ${jobOffer.titre} chez ${jobOffer.entreprise}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showApplicationSuccess(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Votre candidature sera bientôt prise en compte !'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _copyJobLink(BuildContext context, JobOffer jobOffer) {
    final link = 'https://ekod-alumni.com/jobs/${jobOffer.id}';
    Clipboard.setData(ClipboardData(text: link));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Lien copié dans le presse-papiers'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _contactRecruiter(BuildContext context, JobOffer jobOffer) {
    if (jobOffer.contactEmail != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Contact du recruteur'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (jobOffer.contactEmail != null) ...[
                const Text(
                  'Email :',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                SelectableText(jobOffer.contactEmail!),
                const SizedBox(height: 12),
              ],
              if (jobOffer.contactTelephone != null) ...[
                const Text(
                  'Téléphone :',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                SelectableText(jobOffer.contactTelephone!),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fermer'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Contacter le recruteur'),
          content: const Text(
            'Aucune information de contact n\'est disponible pour cette offre. Vous pouvez utiliser le bouton "Postuler" pour envoyer votre candidature.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fermer'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _openCompanyWebsite(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // Fallback : copier l'URL
        Clipboard.setData(ClipboardData(text: url));
      }
    } catch (e) {
      // Fallback : copier l'URL
      Clipboard.setData(ClipboardData(text: url));
    }
  }

  void _shareJobOffer(JobOffer? jobOffer) {
    if (jobOffer == null) return;

    final text = '''
Découvrez cette opportunité sur Ekod Alumni !

${jobOffer.titre}
${jobOffer.entreprise} - ${jobOffer.ville}

${jobOffer.shortDescription}

Candidatures jusqu'au ${_formatDate(jobOffer.dateLimite)}

https://ekod-alumni.com/jobs/${jobOffer.id}
''';

    Clipboard.setData(ClipboardData(text: text));
  }
}
