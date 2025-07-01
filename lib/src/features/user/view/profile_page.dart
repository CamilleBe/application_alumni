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

  Future<void> _handleSignOut() async {
    final authRepository = ref.watch(authRepositoryProvider);
    try {
      await authRepository.signOut();
      if (mounted) {
        context.go('/sign-in');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de la déconnexion')),
        );
      }
    }
  }

  Future<void> _handleSaveBio() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await ref
          .read(userRepositoryProvider)
          .updateUserBio(user.uid, _bioController.text.trim());
      setState(() => _isEditingBio = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bio mise à jour avec succès'),
            backgroundColor: Colors.green,
          ),
        );
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
    }
  }

  Future<void> _handleSaveProfessionalInfo() async {
    final user = FirebaseAuth.instance.currentUser;
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Informations mises à jour avec succès'),
            backgroundColor: Colors.green,
          ),
        );
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
    }
  }

  Future<void> _handleImageSelection(ImageSource source) async {
    final user = FirebaseAuth.instance.currentUser;
    final userRepository = ref.watch(userRepositoryProvider);
    if (user == null) return;

    setState(() => _isUploadingImage = true);

    try {
      final imageFile = await userRepository.pickImage(source: source);
      if (imageFile == null) {
        setState(() => _isUploadingImage = false);
        return;
      }

      final imageUrl =
          await userRepository.uploadProfileImage(user.uid, imageFile);
      if (imageUrl == null) {
        throw Exception("Erreur lors de l'upload de l'image");
      }

      await userRepository.updateProfileImageUrl(user.uid, imageUrl);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Photo mise à jour avec succès'),
            backgroundColor: Colors.green,
          ),
        );
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
      setState(() => _isUploadingImage = false);
    }
  }

  void _showImagePickerDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choisir une photo'),
          content: ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Galerie'),
            onTap: () {
              Navigator.of(context).pop();
              _handleImageSelection(ImageSource.gallery);
            },
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

  Widget _buildStatusBadge(String status) {
    Color badgeColor;
    Color textColor;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'alumni':
        badgeColor = Colors.red;
        textColor = Colors.white;
        icon = Icons.school;
      case 'étudiant':
        badgeColor = Colors.blue;
        textColor = Colors.white;
        icon = Icons.menu_book;
      default:
        badgeColor = Colors.grey;
        textColor = Colors.white;
        icon = Icons.person;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
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

  Widget _buildProfileImage() {
    final user = FirebaseAuth.instance.currentUser;
    final profileImageAsync = user != null
        ? ref.watch(userProfileImageStreamProvider(user.uid))
        : null;

    return Stack(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[200],
            border: Border.all(color: Colors.grey[300]!, width: 2),
          ),
          child: profileImageAsync?.when(
                data: (imageUrl) => imageUrl != null
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
                loading: () => const CircularProgressIndicator(),
                error: (error, stack) => const Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.grey,
                ),
              ) ??
              const Icon(
                Icons.person,
                size: 60,
                color: Colors.grey,
              ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: _isUploadingImage ? null : _showImagePickerDialog,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red,
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
                      Icons.edit,
                      size: 16,
                      color: Colors.white,
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required bool isEditing,
    required VoidCallback onEdit,
    required VoidCallback onSave,
    required VoidCallback onCancel,
    required Widget editWidget,
    required Widget displayWidget,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            if (!isEditing)
              IconButton(
                onPressed: onEdit,
                icon: const Icon(Icons.edit, color: Colors.red),
              ),
          ],
        ),
        const SizedBox(height: 8),
        if (isEditing) ...[
          editWidget,
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onCancel,
                  child: const Text('Annuler'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: RedButton(
                  text: 'Sauvegarder',
                  onPressed: onSave,
                ),
              ),
            ],
          ),
        ] else
          displayWidget,
      ],
    );
  }

  Widget _buildProfessionalInfoSection(
    AsyncValue<Map<String, String?>>? professionalInfoAsync,
  ) {
    return _buildSection(
      title: 'Informations Professionnelles',
      isEditing: _isEditingProfessionalInfo,
      onEdit: () {
        final currentInfo = professionalInfoAsync?.value ?? {};
        _entrepriseController.text = currentInfo['entreprise'] ?? '';
        _posteController.text = currentInfo['poste'] ?? '';
        _villeController.text = currentInfo['ville'] ?? '';
        _anneePromotionController.text = currentInfo['anneePromotion'] ?? '';
        setState(() => _isEditingProfessionalInfo = true);
      },
      onSave: _handleSaveProfessionalInfo,
      onCancel: () => setState(() => _isEditingProfessionalInfo = false),
      editWidget: Column(
        children: [
          TextField(
            controller: _entrepriseController,
            decoration: InputDecoration(
              labelText: 'Entreprise',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.grey.withValues(alpha: 0.1),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _posteController,
            decoration: InputDecoration(
              labelText: 'Poste',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.grey.withValues(alpha: 0.1),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _villeController,
            decoration: InputDecoration(
              labelText: 'Ville',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.grey.withValues(alpha: 0.1),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _anneePromotionController,
            decoration: InputDecoration(
              labelText: 'Année de promotion',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.grey.withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
      displayWidget: professionalInfoAsync?.when(
            data: (info) {
              final hasInfo =
                  info.values.any((value) => value?.isNotEmpty == true);
              if (!hasInfo) {
                return const Text(
                  'Aucune information professionnelle renseignée',
                  style: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (info['entreprise']?.isNotEmpty == true)
                    Text('Entreprise: ${info['entreprise']}'),
                  if (info['poste']?.isNotEmpty == true)
                    Text('Poste: ${info['poste']}'),
                  if (info['ville']?.isNotEmpty == true)
                    Text('Ville: ${info['ville']}'),
                  if (info['anneePromotion']?.isNotEmpty == true)
                    Text('Année de promotion: ${info['anneePromotion']}'),
                ],
              );
            },
            loading: () => const CircularProgressIndicator(),
            error: (error, stack) => const Text(
              'Erreur lors du chargement',
              style: TextStyle(color: Colors.red),
            ),
          ) ??
          const Text('Chargement...'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final bioAsync =
        user != null ? ref.watch(userBioStreamProvider(user.uid)) : null;
    final professionalInfoAsync = user != null
        ? ref.watch(userProfessionalInfoStreamProvider(user.uid))
        : null;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    const CustomTitle(text: 'Profil'),
                    const SizedBox(height: 32),

                    // Photo de profil
                    _buildProfileImage(),
                    const SizedBox(height: 16),

                    // Nom et prénom de l'utilisateur
                    if (user != null)
                      ref.watch(userDataStreamProvider(user.uid)).when(
                            data: (userData) {
                              if (userData != null) {
                                return Column(
                                  children: [
                                    Text(
                                      '${userData.firstName} ${userData.lastName}',
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      userData.email,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                );
                              } else {
                                return Text(
                                  user.email ?? 'Email non disponible',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                );
                              }
                            },
                            loading: () => const CircularProgressIndicator(),
                            error: (error, stack) => Text(
                              user.email ?? 'Email non disponible',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                    const SizedBox(height: 12),

                    // Badge de statut
                    if (user != null)
                      ref.watch(userStatusStreamProvider(user.uid)).when(
                            data: (status) => status != null
                                ? _buildStatusBadge(status)
                                : const SizedBox.shrink(),
                            loading: () => const CircularProgressIndicator(),
                            error: (error, stack) => const SizedBox.shrink(),
                          ),

                    const SizedBox(height: 32),

                    // Bio Section
                    _buildSection(
                      title: 'Bio',
                      isEditing: _isEditingBio,
                      onEdit: () {
                        _bioController.text = bioAsync?.value ?? '';
                        setState(() => _isEditingBio = true);
                      },
                      onSave: _handleSaveBio,
                      onCancel: () => setState(() => _isEditingBio = false),
                      editWidget: TextField(
                        controller: _bioController,
                        maxLines: 3,
                        maxLength: 75,
                        decoration: InputDecoration(
                          hintText: 'Parlez-nous de vous...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.grey.withValues(alpha: 0.1),
                        ),
                      ),
                      displayWidget: bioAsync?.when(
                            data: (bio) => Text(
                              bio?.isNotEmpty == true
                                  ? bio!
                                  : 'Aucune bio renseignée',
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
                            loading: () => const CircularProgressIndicator(),
                            error: (error, stack) => const Text(
                              'Erreur lors du chargement',
                              style: TextStyle(color: Colors.red),
                            ),
                          ) ??
                          const Text('Chargement...'),
                    ),

                    const SizedBox(height: 24),

                    // Informations Professionnelles Section
                    _buildProfessionalInfoSection(professionalInfoAsync),

                    const SizedBox(height: 32),

                    // Actions
                    RedButton(
                      text: 'Changer le mot de passe',
                      onPressed: () => context.go('/profile/change-password'),
                    ),

                    const SizedBox(height: 16),

                    RedButton(
                      text: 'Se déconnecter',
                      backgroundColor: Colors.grey,
                      onPressed: _handleSignOut,
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
