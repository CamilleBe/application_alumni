import 'package:cached_network_image/cached_network_image.dart';
import 'package:ekod_alumni/src/features/authentication/data/auth_repository.dart';
import 'package:ekod_alumni/src/features/user/data/user_repository.dart';
import 'package:ekod_alumni/src/widgets/btn-rouge.dart';
import 'package:ekod_alumni/src/widgets/title.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  bool _isEditingBio = false;
  bool _isEditingProfessionalInfo = false;
  bool _isUploadingImage = false;
  final _bioController = TextEditingController();
  final _entrepriseController = TextEditingController();
  final _posteController = TextEditingController();
  final _villeController = TextEditingController();
  final _anneePromotionController = TextEditingController();

  @override
  void dispose() {
    _bioController.dispose();
    _entrepriseController.dispose();
    _posteController.dispose();
    _villeController.dispose();
    _anneePromotionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final authRepository = ref.watch(authRepositoryProvider);
    final userRepository = ref.watch(userRepositoryProvider);

    final bioAsync =
        user != null ? ref.watch(userBioStreamProvider(user.uid)) : null;
    final profileImageAsync = user != null
        ? ref.watch(userProfileImageStreamProvider(user.uid))
        : null;
    final professionalInfoAsync = user != null
        ? ref.watch(userProfessionalInfoStreamProvider(user.uid))
        : null;

    Future<void> handleSignOut() async {
      try {
        await authRepository.signOut();
        if (context.mounted) {
          context.go('/sign-in');
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erreur lors de la déconnexion')),
          );
        }
      }
    }

    Future<void> handleSaveBio() async {
      if (user == null) return;
      try {
        await ref
            .read(userRepositoryProvider)
            .updateUserBio(user.uid, _bioController.text.trim());
        setState(() => _isEditingBio = false);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Bio mise à jour avec succès'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur: $e'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }

    Future<void> handleSaveProfessionalInfo() async {
      if (user == null) return;
      try {
        await ref.read(userRepositoryProvider).updateProfessionalInfo(
              user.uid,
              entreprise: _entrepriseController.text.trim().isEmpty
                  ? null
                  : _entrepriseController.text.trim(),
              poste: _posteController.text.trim().isEmpty
                  ? null
                  : _posteController.text.trim(),
              ville: _villeController.text.trim().isEmpty
                  ? null
                  : _villeController.text.trim(),
              anneePromotion: _anneePromotionController.text.trim().isEmpty
                  ? null
                  : _anneePromotionController.text.trim(),
            );
        setState(() => _isEditingProfessionalInfo = false);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Informations professionnelles mises à jour avec succès',
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur: $e'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }

    Future<void> handleImageSelection(ImageSource source) async {
      if (user == null) return;
      setState(() => _isUploadingImage = true);

      try {
        final imageFile = await userRepository.pickImage(source: source);
        if (imageFile == null) {
          setState(() => _isUploadingImage = false);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Aucune image sélectionnée'),
                backgroundColor: Colors.orange,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          return;
        }

        final imageUrl =
            await userRepository.uploadProfileImage(user.uid, imageFile);
        if (imageUrl == null) {
          throw Exception("Erreur lors de l'upload de l'image");
        }

        await userRepository.updateProfileImageUrl(user.uid, imageUrl);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Photo de profil mise à jour avec succès'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur: $e'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } finally {
        setState(() => _isUploadingImage = false);
      }
    }

    void showImagePickerDialog() {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Choisir une photo'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Sélectionner depuis la galerie'),
                  onTap: () {
                    Navigator.of(context).pop();
                    handleImageSelection(ImageSource.gallery);
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Annuler'),
              ),
            ],
          );
        },
      );
    }

    void startEditingBio(String? currentBio) {
      _bioController.text = currentBio ?? '';
      setState(() => _isEditingBio = true);
    }

    void cancelEditingBio() {
      setState(() => _isEditingBio = false);
      _bioController.clear();
    }

    void startEditingProfessionalInfo(Map<String, String?> currentInfo) {
      _entrepriseController.text = currentInfo['entreprise'] ?? '';
      _posteController.text = currentInfo['poste'] ?? '';
      _villeController.text = currentInfo['ville'] ?? '';
      _anneePromotionController.text = currentInfo['anneePromotion'] ?? '';
      setState(() => _isEditingProfessionalInfo = true);
    }

    void cancelEditingProfessionalInfo() {
      setState(() => _isEditingProfessionalInfo = false);
      _entrepriseController.clear();
      _posteController.clear();
      _villeController.clear();
      _anneePromotionController.clear();
    }

    Widget buildStatusBadge(String status) {
      Color badgeColor;
      Color textColor;
      IconData icon;

      switch (status.toLowerCase()) {
        case 'alumni':
          badgeColor = Colors.blue[600]!;
          textColor = Colors.white;
          icon = Icons.school;
        case 'étudiant':
          badgeColor = Colors.green[600]!;
          textColor = Colors.white;
          icon = Icons.menu_book;
        default:
          badgeColor = Colors.grey[600]!;
          textColor = Colors.white;
          icon = Icons.person;
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: badgeColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: badgeColor.withValues(alpha: 0.3),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: textColor,
            ),
            const SizedBox(width: 6),
            Text(
              status,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    Widget buildProfileImage() {
      return profileImageAsync?.when(
            data: (imageUrl) {
              return Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[200],
                    ),
                    child: imageUrl != null
                        ? ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.cover,
                              width: 120,
                              height: 120,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) => const Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : const Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.grey,
                          ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _isUploadingImage ? null : showImagePickerDialog,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: _isUploadingImage
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(
                                Icons.camera_alt,
                                size: 16,
                                color: Colors.white,
                              ),
                      ),
                    ),
                  ),
                ],
              );
            },
            loading: () => Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[200],
              ),
              child: const CircularProgressIndicator(),
            ),
            error: (error, stack) => Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[200],
              ),
              child: const Icon(Icons.person, size: 60, color: Colors.grey),
            ),
          ) ??
          Container(
            width: 120,
            height: 120,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.grey[200]),
            child: const Icon(Icons.person, size: 60, color: Colors.grey),
          );
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CustomTitle(text: 'Profil'),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Photo de profil
                  buildProfileImage(),
                  const SizedBox(height: 16),

                  // Nom et prénom de l'utilisateur
                  if (user != null)
                    ref.watch(userDataStreamProvider(user.uid)).when(
                          data: (userData) {
                            print(
                              'Données utilisateur récupérées: $userData',
                            ); // Debug
                            if (userData != null) {
                              return Column(
                                children: [
                                  Text(
                                    '${userData.firstName} ${userData.lastName}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    userData.email,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Colors.grey[600],
                                          fontSize: 15,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              );
                            } else {
                              return Column(
                                children: [
                                  Text(
                                    'Nom non disponible',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[700],
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    user.email ?? 'Email non disponible',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Colors.grey[600],
                                          fontSize: 15,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              );
                            }
                          },
                          loading: () => Column(
                            children: [
                              const SizedBox(
                                height: 16,
                                width: 16,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Chargement...',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Colors.grey[600],
                                      fontSize: 15,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          error: (error, stack) {
                            print(
                              'Erreur lors du chargement des données utilisateur: $error',
                            ); // Debug
                            return Column(
                              children: [
                                Text(
                                  'Erreur de chargement',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[700],
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  user.email ?? 'Email non disponible',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Colors.grey[600],
                                        fontSize: 15,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            );
                          },
                        ),

                  const SizedBox(height: 12),

                  // Badge de statut
                  if (user != null)
                    ref.watch(userStatusStreamProvider(user.uid)).when(
                          data: (status) => status != null
                              ? buildStatusBadge(status)
                              : const SizedBox.shrink(),
                          loading: () => const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          error: (error, stack) => const SizedBox.shrink(),
                        ),

                  const SizedBox(height: 20),

                  // Section Bio
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 18,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Bio',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                            const Spacer(),
                            if (!_isEditingBio)
                              IconButton(
                                onPressed: () =>
                                    startEditingBio(bioAsync?.value),
                                icon: Icon(
                                  Icons.edit,
                                  size: 18,
                                  color: Colors.blue[600],
                                ),
                                tooltip: 'Modifier la bio',
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (_isEditingBio) ...[
                          TextFormField(
                            controller: _bioController,
                            maxLines: 3,
                            maxLength: 75,
                            decoration: InputDecoration(
                              hintText: 'Parlez-nous de vous...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.all(12),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: cancelEditingBio,
                                  child: const Text('Annuler'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: handleSaveBio,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Sauvegarder'),
                                ),
                              ),
                            ],
                          ),
                        ] else ...[
                          bioAsync?.when(
                                data: (bio) => Text(
                                  bio?.isNotEmpty == true
                                      ? bio!
                                      : "Aucune bio renseignée. Cliquez sur l'icône pour en ajouter une.",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: bio?.isNotEmpty == true
                                        ? Colors.black87
                                        : Colors.grey[600],
                                    fontStyle: bio?.isNotEmpty == true
                                        ? FontStyle.normal
                                        : FontStyle.italic,
                                  ),
                                ),
                                loading: () => const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                ),
                                error: (error, stack) => Text(
                                  'Erreur lors du chargement de la bio',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.red[600],
                                  ),
                                ),
                              ) ??
                              Text(
                                'Chargement...',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Section Informations Professionnelles
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.work_outline,
                              size: 18,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Informations Professionnelles',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                            const Spacer(),
                            if (!_isEditingProfessionalInfo)
                              IconButton(
                                onPressed: () => startEditingProfessionalInfo(
                                  professionalInfoAsync?.value ??
                                      {
                                        'entreprise': null,
                                        'poste': null,
                                        'ville': null,
                                        'anneePromotion': null,
                                      },
                                ),
                                icon: Icon(
                                  Icons.edit,
                                  size: 18,
                                  color: Colors.blue[600],
                                ),
                                tooltip:
                                    'Modifier les informations professionnelles',
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (_isEditingProfessionalInfo) ...[
                          TextFormField(
                            controller: _entrepriseController,
                            decoration: InputDecoration(
                              labelText: 'Entreprise',
                              hintText: 'Nom de votre entreprise',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.all(12),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _posteController,
                            decoration: InputDecoration(
                              labelText: 'Poste actuel',
                              hintText: 'Votre poste actuel',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.all(12),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _villeController,
                            decoration: InputDecoration(
                              labelText: 'Ville',
                              hintText: 'Votre ville',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.all(12),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _anneePromotionController,
                            decoration: InputDecoration(
                              labelText: 'Année de promotion',
                              hintText: 'Ex: 2020',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.all(12),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: cancelEditingProfessionalInfo,
                                  child: const Text('Annuler'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: handleSaveProfessionalInfo,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Sauvegarder'),
                                ),
                              ),
                            ],
                          ),
                        ] else ...[
                          professionalInfoAsync?.when(
                                data: (info) => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildInfoRow(
                                      'Entreprise',
                                      info['entreprise'],
                                    ),
                                    const SizedBox(height: 8),
                                    _buildInfoRow('Poste', info['poste']),
                                    const SizedBox(height: 8),
                                    _buildInfoRow('Ville', info['ville']),
                                    const SizedBox(height: 8),
                                    _buildInfoRow(
                                      'Année de promotion',
                                      info['anneePromotion'],
                                    ),
                                  ],
                                ),
                                loading: () => const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                ),
                                error: (error, stack) => Text(
                                  'Erreur lors du chargement des informations',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.red[600],
                                  ),
                                ),
                              ) ??
                              Text(
                                'Chargement...',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Bouton pour changer le mot de passe
            OutlinedButton.icon(
              onPressed: () => context.go('/profile/change-password'),
              icon: const Icon(Icons.lock_outline),
              label: const Text('Changer le mot de passe'),
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Bouton de déconnexion
            RedButton(text: 'Se déconnecter', onPressed: handleSignOut),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            '$label:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ),
        Expanded(
          child: Text(
            value?.isNotEmpty == true ? value! : 'Non renseigné',
            style: TextStyle(
              fontSize: 14,
              color:
                  value?.isNotEmpty == true ? Colors.black87 : Colors.grey[600],
              fontStyle: value?.isNotEmpty == true
                  ? FontStyle.normal
                  : FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }
}
