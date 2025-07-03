import 'package:ekod_alumni/src/app/app.dart';
import 'package:ekod_alumni/src/app/routes/go_router_refresh_stream.dart';
import 'package:ekod_alumni/src/features/alumni/view/alumni_detail_page.dart';
import 'package:ekod_alumni/src/features/alumni/view/alumni_directory_page.dart';
import 'package:ekod_alumni/src/features/authentication/authentication.dart';
import 'package:ekod_alumni/src/features/jobs/view/create_offer_page.dart';
import 'package:ekod_alumni/src/features/jobs/view/edit_offer_page.dart';
import 'package:ekod_alumni/src/features/jobs/view/job_offer_detail_page.dart';
import 'package:ekod_alumni/src/features/jobs/view/list_job.dart';
import 'package:ekod_alumni/src/features/jobs/view/my_offers_page.dart';
import 'package:ekod_alumni/src/features/user/view/change_password_page.dart';
import 'package:ekod_alumni/src/features/user/view/profile_page.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

/// All the supported routes in the app.
/// By using an enum, we route by name using this syntax:
///
/// ```dart
/// context.goNamed(AppRoute.home.name)
/// ```
enum AppRoute {
  welcome,
  signIn,
  signUp,
  home,
  alumni,
  alumniDetail,
  profile,
  changePassword,
  jobs,
  jobDetail,
  createOffer,
  editOffer,
  myOffers,
}

@riverpod
GoRouter goRouter(Ref ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    // * Redirect logic based on the user authentication state
    redirect: (context, state) {
      final path = state.uri.path;

      final user = authRepository.currentUser;
      final isLoggedIn = user != null;

      // Si l'utilisateur est connecté
      if (isLoggedIn) {
        // Si l'utilisateur est sur la page welcome seulement, rediriger vers home
        if (path == '/') {
          return '/home';
        }
      } else {
        // Si l'utilisateur n'est pas connecté et essaie d'accéder à une page protégée
        if (path == '/home' ||
            path == '/alumni' ||
            path.startsWith('/alumni/') ||
            path == '/profile' ||
            path == '/change-password' ||
            path == '/jobs' ||
            path.startsWith('/jobs/') ||
            path == '/create-offer' ||
            path.startsWith('/edit-offer/') ||
            path == '/my-offers') {
          return '/sign-in';
        }
      }

      return null;
    },
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
    routes: [
      GoRoute(
        path: '/',
        name: AppRoute.welcome.name,
        pageBuilder: (_, __) => const NoTransitionPage(child: WelcomeView()),
      ),
      GoRoute(
        path: '/sign-in',
        name: AppRoute.signIn.name,
        pageBuilder: (_, __) => const NoTransitionPage(child: SignInView()),
      ),
      GoRoute(
        path: '/sign-up',
        name: AppRoute.signUp.name,
        pageBuilder: (_, __) => const NoTransitionPage(child: SignUpView()),
      ),
      StatefulShellRoute.indexedStack(
        pageBuilder: (_, __, navigationShell) {
          return NoTransitionPage(
            child: ScaffoldWithNestedNavigation(
              navigationShell: navigationShell,
            ),
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                name: AppRoute.home.name,
                pageBuilder: (_, __) =>
                    const NoTransitionPage(child: HomeView()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/alumni',
                name: AppRoute.alumni.name,
                pageBuilder: (_, __) =>
                    const NoTransitionPage(child: AlumniDirectoryPage()),
                routes: [
                  GoRoute(
                    path: ':id',
                    name: AppRoute.alumniDetail.name,
                    pageBuilder: (context, state) {
                      final alumniId = state.pathParameters['id']!;
                      return NoTransitionPage(
                        child: AlumniDetailPage(alumniId: alumniId),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                name: AppRoute.profile.name,
                pageBuilder: (_, __) => const NoTransitionPage(
                  child: ProfilePage(),
                ),
                routes: [
                  GoRoute(
                    path: 'change-password',
                    name: AppRoute.changePassword.name,
                    pageBuilder: (_, __) => const NoTransitionPage(
                      child: ChangePasswordPage(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      // Routes indépendantes pour les offres d'emploi
      GoRoute(
        path: '/jobs',
        name: AppRoute.jobs.name,
        pageBuilder: (_, __) => const NoTransitionPage(child: ListJob()),
        routes: [
          GoRoute(
            path: ':id',
            name: AppRoute.jobDetail.name,
            pageBuilder: (context, state) {
              final jobId = state.pathParameters['id']!;
              return NoTransitionPage(
                child: JobOfferDetailPage(jobOfferId: jobId),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: '/create-offer',
        name: AppRoute.createOffer.name,
        pageBuilder: (_, __) =>
            const NoTransitionPage(child: CreateOfferPage()),
      ),
      GoRoute(
        path: '/edit-offer/:id',
        name: AppRoute.editOffer.name,
        pageBuilder: (context, state) {
          final offerId = state.pathParameters['id']!;
          return NoTransitionPage(
            child: EditOfferPage(offerId: offerId),
          );
        },
      ),
      GoRoute(
        path: '/my-offers',
        name: AppRoute.myOffers.name,
        pageBuilder: (_, __) => const NoTransitionPage(child: MyOffersPage()),
      ),
    ],
  );
}
