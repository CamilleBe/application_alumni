import 'package:flutter/material.dart';

import '../../../widgets/carte-job.dart';

class ListJob extends StatelessWidget {
  final bool showAppBar;

  const ListJob({super.key, this.showAppBar = true});

  @override
  Widget build(BuildContext context) {
    final listView = ListView.builder(
      itemCount: 10, // À remplacer par la vraie liste de jobs
      itemBuilder: (context, index) {
        return CarteJob(
          titre: 'Développeur Flutter ${index + 1}',
          description:
              'Nous recherchons un développeur Flutter passionné pour rejoindre notre équipe dynamique.',
          onTap: () {
            // Navigation vers les détails du job
            print('Job $index sélectionné');
          },
        );
      },
    );

    if (showAppBar) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Jobs'),
          centerTitle: true,
          automaticallyImplyLeading:
              false, // Désactive le bouton back automatique
        ),
        body: listView,
      );
    } else {
      return listView;
    }
  }
}
