import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class QuestionnairePage extends StatefulWidget {
  const QuestionnairePage({super.key});

  @override
  State<QuestionnairePage> createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> with SingleTickerProviderStateMixin {
  final List<String> knownItems = [
    'Gluten',
    'Lactose',
    'Œufs',
    'Arachides',
    'Fruits à coque',
    'Soja',
    'Fruits de mer',
    'Sésame',
    'Poisson',
  ];

  List<String> selectedItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        title: const Text("Vos intolérances"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Sélectionnez ce qui vous concerne 👇",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                itemCount: knownItems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 2.5,
                ),
                itemBuilder: (context, index) {
                  final item = knownItems[index];
                  final selected = selectedItems.contains(item);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selected
                            ? selectedItems.remove(item)
                            : selectedItems.add(item);
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: selected ? Colors.teal : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.teal),
                        boxShadow: [
                          if (selected)
                            const BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          item,
                          style: TextStyle(
                            fontSize: 16,
                            color: selected ? Colors.white : Colors.teal,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                logger.i("Intolérances sélectionnées : $selectedItems");
                Navigator.pushReplacementNamed(context, '/home'); // ou prochaine étape
              },
              child: const Center(
                child: Text(
                  "Continuer",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
