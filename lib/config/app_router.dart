import 'barrel.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/contracts',
  routes: [
    ShellRoute(
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state, child) {
        return MainPage(
          currentIndex: switch (state.uri.path) {
            final p when p.startsWith("/contracts") => 0,
            final p when p.startsWith("/history") => 1,
            final p when p.startsWith("/new") => 2,
            final p when p.startsWith("/saved") => 3,
            final p when p.startsWith("/profile") => 4,
            _ => 0,
          },
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/contracts',
          pageBuilder: (context, state) => NoTransitionPage(
            child: const ContractsPage(key: ValueKey("contracts_page")),
          ),
          routes: <RouteBase>[
            GoRoute(
              path: 'search',
              name: 'search',
              pageBuilder: (context, state) => NoTransitionPage(
                child: const SearchPage(key: ValueKey("search_page")),
              ),
              parentNavigatorKey: _rootNavigatorKey,
            ),
            GoRoute(
              path: 'filter',
              name: 'filter',
              pageBuilder: (context, state) => NoTransitionPage(
                child: const FilterPage(key: ValueKey("filter_page")),
              ),
            ),
            GoRoute(
              path: 'contract_details',
              name: 'contract_details',
              pageBuilder: (context, state) {
                final extra = state.extra as Map?;
                final contract = extra?['contract'] as ContractModel;
                final displayIndex = extra?['displayIndex'] as int;
                NoTransitionPage(
                  child: Scaffold(
                    body: Center(child: Text('No contract data provided!')),
                  ),
                );
                return NoTransitionPage(
                  child: ContractDetailsPage(
                    key: const ValueKey('details_page'),
                    contract: contract,
                    displayIndex: displayIndex,
                  ),
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: '/history',
          pageBuilder: (context, state) => NoTransitionPage(
            child: const HistoryPage(key: ValueKey("history_page"),
            ),
          ),
          routes: [
            GoRoute(
              path: 'history_contract_details',
              name: 'history_contract_details',
              pageBuilder: (context, state) {
                final extra = state.extra as Map?;
                final contract = extra?['contract'] as ContractModel;
                final displayIndex = extra?['displayIndex'] as int;
                NoTransitionPage(
                  child: Scaffold(
                    body: Center(child: Text('No contract data provided!')),
                  ),
                );
                return NoTransitionPage(
                  child: ContractDetailsPage(
                    key: const ValueKey('history_details_page'),
                    contract: contract,
                    displayIndex: displayIndex,
                  ),
                );
              },
            ),
          ]
        ),
        GoRoute(
          path: '/saved',
          pageBuilder: (context, state) => NoTransitionPage(
            child: const SavedPage(key: ValueKey("saved_page")),
          ),
          routes: <RouteBase>[
            GoRoute(
              path: 'saved_contract_details',
              name: 'saved_contract_details',
              pageBuilder: (context, state) {
                final extra = state.extra as Map?;
                final contract = extra?['contract'] as ContractModel;
                final displayIndex = extra?['displayIndex'] as int;
                NoTransitionPage(
                  child: Scaffold(
                    body: Center(child: Text('No contract data provided!')),
                  ),
                );
                return NoTransitionPage(
                  child: ContractDetailsPage(
                    key: const ValueKey('saved_details_page'),
                    contract: contract,
                    displayIndex: displayIndex,
                  ),
                );
              },
            ),
          ]
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) => NoTransitionPage(
            child: const ProfilePage(key: ValueKey("profile_page")),
          ),
        ),
        GoRoute(
          path: '/new_contract',
          pageBuilder: (context, state) => NoTransitionPage(
            child: const NewContractPage(key: ValueKey("new_contract")),
          ),
        ),
        GoRoute(
          path: '/new_invoice',
          pageBuilder: (context, state) => NoTransitionPage(
            child: const NewInvoicePage(key: ValueKey('new_invoice')),
          ),
        ),
      ],
    ),
  ],
);
