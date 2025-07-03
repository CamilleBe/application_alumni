import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ekod_alumni/src/features/jobs/domain/job_offer.dart';
import 'package:ekod_alumni/src/features/jobs/application/job_offer_service.dart';

/// {@template create_job_offer_page}
/// Page pour créer une nouvelle offre d'emploi
/// {@endtemplate}
class CreateJobOfferPage extends ConsumerStatefulWidget {
  /// {@macro create_job_offer_page}
  const CreateJobOfferPage({super.key});

  static const String routeName = '/create-job-offer';

  @override
  ConsumerState<CreateJobOfferPage> createState() => _CreateJobOfferPageState();
}

class _CreateJobOfferPageState extends ConsumerState<CreateJobOfferPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _canPublish = false;

  // Contrôleurs pour les champs de texte
  final _titreController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _entrepriseController = TextEditingController();
  final _villeController = TextEditingController();
  final _niveauEtudeController = TextEditingController();
  final _typeContratController = TextEditingController();
  final _salaireController = TextEditingController();
  final _urlEntrepriseController = TextEditingController();
  final _contactEmailController = TextEditingController();
  final _contactTelephoneController = TextEditingController();
  final _competencesController = TextEditingController();

  // Sélections
  JobOfferType _selectedType = JobOfferType.emploi;
  DateTime? _selectedDateLimite;

  @override
  void initState() {
    super.initState();
    _checkCanPublish();
  }

  @override
  void dispose() {
    _titreController.dispose();
    _descriptionController.dispose();
    _entrepriseController.dispose();
    _villeController.dispose();
    _niveauEtudeController.dispose();
    _typeContratController.dispose();
    _salaireController.dispose();
    _urlEntrepriseController.dispose();
    _contactEmailController.dispose();
    _contactTelephoneController.dispose();
    _competencesController.dispose();
    super.dispose();
  }

  Future<void> _checkCanPublish() async {
    try {
      final service = ref.read(jobOfferServiceProvider);
      final canPublish = await service.canCurrentUserPublishOffers();
      setState(() {
        _canPublish = canPublish;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_canPublish) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => context.pop(),
          ),
          title: const Text(
            'Publier une offre',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 64,
                  color: Color(0xFFE53E3E),
                ),
                SizedBox(height: 24),
                Text(
                  'Accès restreint',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Seuls les alumni peuvent publier des offres d'emploi.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Assurez-vous que votre statut est correctement configuré dans votre profil.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Publier une offre',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('Informations générales'),
              const SizedBox(height: 16),
              _buildTitreField(),
              const SizedBox(height: 16),
              _buildTypeSelection(),
              const SizedBox(height: 16),
              _buildDescriptionField(),
              const SizedBox(height: 24),
              _buildSectionHeader('Entreprise'),
              const SizedBox(height: 16),
              _buildEntrepriseField(),
              const SizedBox(height: 16),
              _buildVilleField(),
              const SizedBox(height: 16),
              _buildUrlEntrepriseField(),
              const SizedBox(height: 24),
              _buildSectionHeader('Détails du poste'),
              const SizedBox(height: 16),
              _buildNiveauEtudeField(),
              const SizedBox(height: 16),
              _buildTypeContratField(),
              const SizedBox(height: 16),
              _buildSalaireField(),
              const SizedBox(height: 16),
              _buildCompetencesField(),
              const SizedBox(height: 24),
              _buildSectionHeader('Contact et échéances'),
              const SizedBox(height: 16),
              _buildContactEmailField(),
              const SizedBox(height: 16),
              _buildContactTelephoneField(),
              const SizedBox(height: 16),
              _buildDateLimiteField(),
              const SizedBox(height: 32),
              _buildSubmitButton(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xFFE53E3E),
      ),
    );
  }

  Widget _buildTitreField() {
    return TextFormField(
      controller: _titreController,
      decoration: const InputDecoration(
        labelText: 'Titre du poste *',
        hintText: 'ex: Développeur Flutter Senior',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.work_outline),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Le titre est obligatoire';
        }
        if (value.trim().length < 5) {
          return 'Le titre doit contenir au moins 5 caractères';
        }
        return null;
      },
    );
  }

  Widget _buildTypeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Type d'offre *",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: RadioListTile<JobOfferType>(
                title: const Text('💼 Emploi'),
                value: JobOfferType.emploi,
                groupValue: _selectedType,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedType = value;
                    });
                  }
                },
                activeColor: const Color(0xFFE53E3E),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            Expanded(
              child: RadioListTile<JobOfferType>(
                title: const Text('🎓 Stage'),
                value: JobOfferType.stage,
                groupValue: _selectedType,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedType = value;
                    });
                  }
                },
                activeColor: const Color(0xFFE53E3E),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      maxLines: 6,
      decoration: const InputDecoration(
        labelText: 'Description *',
        hintText: 'Décrivez le poste, les missions, les responsabilités...',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.description_outlined),
        alignLabelWithHint: true,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'La description est obligatoire';
        }
        if (value.trim().length < 50) {
          return 'La description doit contenir au moins 50 caractères';
        }
        return null;
      },
    );
  }

  Widget _buildEntrepriseField() {
    return TextFormField(
      controller: _entrepriseController,
      decoration: const InputDecoration(
        labelText: 'Entreprise *',
        hintText: 'ex: TechCorp France',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.business_outlined),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Le nom de l'entreprise est obligatoire";
        }
        return null;
      },
    );
  }

  Widget _buildVilleField() {
    return TextFormField(
      controller: _villeController,
      decoration: const InputDecoration(
        labelText: 'Ville *',
        hintText: 'ex: Paris, Lyon, Remote...',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.location_city_outlined),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'La ville est obligatoire';
        }
        return null;
      },
    );
  }

  Widget _buildUrlEntrepriseField() {
    return TextFormField(
      controller: _urlEntrepriseController,
      decoration: const InputDecoration(
        labelText: "Site web de l'entreprise",
        hintText: 'https://www.exemple.com',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.language_outlined),
      ),
      validator: (value) {
        if (value != null && value.trim().isNotEmpty) {
          final urlPattern = RegExp(
            '^https?://.*',
            caseSensitive: false,
          );
          if (!urlPattern.hasMatch(value.trim())) {
            return 'URL invalide (doit commencer par http:// ou https://)';
          }
        }
        return null;
      },
    );
  }

  Widget _buildNiveauEtudeField() {
    return TextFormField(
      controller: _niveauEtudeController,
      decoration: const InputDecoration(
        labelText: "Niveau d'étude requis",
        hintText: 'ex: Bac+3, Master, Doctorat...',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.school_outlined),
      ),
    );
  }

  Widget _buildTypeContratField() {
    return TextFormField(
      controller: _typeContratController,
      decoration: const InputDecoration(
        labelText: 'Type de contrat',
        hintText: 'ex: CDI, CDD, Freelance...',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.assignment_outlined),
      ),
    );
  }

  Widget _buildSalaireField() {
    return TextFormField(
      controller: _salaireController,
      decoration: const InputDecoration(
        labelText: 'Salaire',
        hintText: 'ex: 45-55k€, À négocier...',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.euro_outlined),
      ),
    );
  }

  Widget _buildCompetencesField() {
    return TextFormField(
      controller: _competencesController,
      maxLines: 3,
      decoration: const InputDecoration(
        labelText: 'Compétences requises',
        hintText: 'Séparez par des virgules: Flutter, Dart, Firebase, Git...',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.psychology_outlined),
        alignLabelWithHint: true,
      ),
    );
  }

  Widget _buildContactEmailField() {
    return TextFormField(
      controller: _contactEmailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: 'Email de contact *',
        hintText: 'recrutement@entreprise.com',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.email_outlined),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "L'email de contact est obligatoire";
        }
        final emailPattern = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
        if (!emailPattern.hasMatch(value.trim())) {
          return 'Email invalide';
        }
        return null;
      },
    );
  }

  Widget _buildContactTelephoneField() {
    return TextFormField(
      controller: _contactTelephoneController,
      keyboardType: TextInputType.phone,
      decoration: const InputDecoration(
        labelText: 'Téléphone de contact',
        hintText: '+33 1 23 45 67 89',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.phone_outlined),
      ),
    );
  }

  Widget _buildDateLimiteField() {
    return InkWell(
      onTap: _selectDateLimite,
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Date limite de candidature *',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.calendar_today_outlined),
        ),
        child: Text(
          _selectedDateLimite != null
              ? '${_selectedDateLimite!.day}/${_selectedDateLimite!.month}/${_selectedDateLimite!.year}'
              : 'Sélectionner une date',
          style: TextStyle(
            color:
                _selectedDateLimite != null ? Colors.black : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDateLimite() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            primaryColor: const Color(0xFFE53E3E),
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: const Color(0xFFE53E3E),
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDateLimite) {
      setState(() {
        _selectedDateLimite = picked;
      });
    }
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE53E3E),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                "Publier l'offre",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDateLimite == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner une date limite'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Traiter les compétences
      final competences = _competencesController.text
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();

      // Créer l'offre
      final offer = JobOffer(
        id: '', // Sera généré par Firestore
        titre: _titreController.text.trim(),
        description: _descriptionController.text.trim(),
        entreprise: _entrepriseController.text.trim(),
        ville: _villeController.text.trim(),
        type: _selectedType,
        datePublication: DateTime.now(),
        dateLimite: _selectedDateLimite!,
        publisherId: '', // Sera assigné par le service
        competencesRequises: competences,
        niveauEtude: _niveauEtudeController.text.trim().isNotEmpty
            ? _niveauEtudeController.text.trim()
            : null,
        typeContrat: _typeContratController.text.trim().isNotEmpty
            ? _typeContratController.text.trim()
            : null,
        salaire: _salaireController.text.trim().isNotEmpty
            ? _salaireController.text.trim()
            : null,
        urlEntreprise: _urlEntrepriseController.text.trim().isNotEmpty
            ? _urlEntrepriseController.text.trim()
            : null,
        contactEmail: _contactEmailController.text.trim(),
        contactTelephone: _contactTelephoneController.text.trim().isNotEmpty
            ? _contactTelephoneController.text.trim()
            : null,
      );

      // Publier l'offre
      final service = ref.read(jobOfferServiceProvider);
      final offerId = await service.createOffer(offer);

      if (offerId != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Offre publiée avec succès !'),
            backgroundColor: Colors.green,
          ),
        );

        // Rediriger vers la page de détail de l'offre créée
        context.go('/jobs/$offerId');
      } else if (mounted) {
        throw Exception("Erreur lors de la création de l'offre");
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
