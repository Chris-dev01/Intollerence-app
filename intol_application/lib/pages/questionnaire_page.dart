// Flutter equivalent of your TSX code
import 'package:flutter/material.dart';

class Intolerance {
  final int id;
  final String name;
  final String image;
  bool selected;

  Intolerance({
    required this.id,
    required this.name,
    required this.image,
    this.selected = false,
  });
}

class QuestionnairePage extends StatefulWidget {
  const QuestionnairePage({super.key});

  @override
  State<QuestionnairePage> createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> {
  List<Intolerance> selectedIntolerances = [
    Intolerance(
        id: 1,
        name: 'Arachides',
        image:
            'assets/images/arachides.png'),
    Intolerance(
        id: 2,
        name: 'Lactose',
        image:
            'assets/images/lactose.jpg'),
      Intolerance(
        id: 3,
        name: 'Gluten',
        image:
            'assets/images/gluten.png'),
      Intolerance(
        id: 4,
        name: 'Oeufs',
        image:
            'assets/images/oeufs.png'),
  ];

  String customIntolerance = '';
  bool showCustomInput = false;

  void toggleIntolerance(int id) {
    setState(() {
      final index = selectedIntolerances.indexWhere((i) => i.id == id);
      if (index != -1) {
        selectedIntolerances[index].selected =
            !selectedIntolerances[index].selected;
      }
    });
  }

  void addCustomIntolerance() {
    if (customIntolerance.trim().isNotEmpty) {
      final newItem = Intolerance(
        id: DateTime.now().millisecondsSinceEpoch,
        name: customIntolerance.trim(),
        image:
            'assets/images/poisson.png',
        selected: true,
      );
      setState(() {
        selectedIntolerances.add(newItem);
        customIntolerance = '';
        showCustomInput = false;
      });
    }
  }

  void handleSubmit() {
    final selected = selectedIntolerances.where((i) => i.selected).toList();
    debugPrint('Intolérances sélectionnées: ${selected.map((e) => e.name)}');
    // Naviguer vers la page profile avec Navigator.pushNamed(context, '/profile');
  }

  @override
  Widget build(BuildContext context) {
    final selectedCount =
        selectedIntolerances.where((element) => element.selected).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Questionnaire'),
        backgroundColor: Colors.purple[100],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Progress info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Étape 1 sur 1',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('$selectedCount sélectionnée${selectedCount != 1 ? 's' : ''}',
                            style: const TextStyle(color: Colors.blue)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(value: 1.0),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Intolerances Grid
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: selectedIntolerances.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.9,
              ),
              itemBuilder: (context, index) {
                final item = selectedIntolerances[index];
                return GestureDetector(
                  onTap: () => toggleIntolerance(item.id),
                  child: Container(
                    decoration: BoxDecoration(
                      color: item.selected ? Colors.blue[50] : Colors.white,
                      border: Border.all(
                          color:
                              item.selected ? Colors.blue : Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(item.image,
                                  width: 64, height: 64, fit: BoxFit.cover),
                            ),
                            if (item.selected)
                              const Positioned(
                                right: 0,
                                top: 0,
                                child: CircleAvatar(
                                  radius: 10,
                                  backgroundColor: Colors.blue,
                                  child: Icon(Icons.check,
                                      color: Colors.white, size: 14),
                                ),
                              )
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: item.selected
                                ? Colors.blue.shade700
                                : Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            // Add custom intolerance UI
            if (!showCustomInput)
              TextButton(
                onPressed: () => setState(() => showCustomInput = true),
                child: const Text('Ajouter une intolérance personnalisée'),
              )
            else
              Column(
                children: [
                  TextField(
                    onChanged: (value) => setState(() => customIntolerance = value),
                    decoration: const InputDecoration(
                      labelText: "Nom de l'intolérance",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: customIntolerance.trim().isEmpty
                              ? null
                              : addCustomIntolerance,
                          child: const Text('Ajouter'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () => setState(() {
                          showCustomInput = false;
                          customIntolerance = '';
                        }),
                        icon: const Icon(Icons.close),
                      )
                    ],
                  )
                ],
              ),
            const SizedBox(height: 16),
            if (selectedCount > 0)
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: selectedIntolerances
                    .where((i) => i.selected)
                    .map((item) => Chip(
                          label: Text(item.name),
                          onDeleted: () => toggleIntolerance(item.id),
                          backgroundColor: Colors.green[100],
                        ))
                    .toList(),
              ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: selectedCount == 0 ? null : handleSubmit,
              child: Text('Valider mes intolérances ($selectedCount)'),
            ),
            TextButton(
              onPressed: () {
                // Naviguer vers le profil : Navigator.pushNamed(context, '/profile');
              },
              child: const Text('Passer cette étape'),
            )
          ],
        ),
      ),
    );
  }
}
