import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

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
    Intolerance(id: 1, name: 'Arachides', image: 'assets/images/arachides.png'),
    Intolerance(id: 2, name: 'Lactose', image: 'assets/images/lactose.jpg'),
    Intolerance(id: 3, name: 'Gluten', image: 'assets/images/gluten.png'),
    Intolerance(id: 4, name: 'Oeufs', image: 'assets/images/oeufs.png'),
    Intolerance(id: 5, name: 'Poisson', image: 'assets/images/poisson.png'),
    Intolerance(id: 6, name: 'Fruits de mer', image: 'assets/images/Fruit-de-mer.png'),
    Intolerance(id: 7, name: 'Soja', image: 'assets/images/soja.png'),
  ];

  String customIntolerance = '';
  bool showCustomInput = false;

  
  @override
  Widget build(BuildContext context) {
    final selectedCount =
        selectedIntolerances.where((element) => element.selected).length;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 246, 255),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.teal,
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: const Text(
              "Intolérances",
              style: TextStyle(fontSize: 28),
            ),
          ),
          
        ),
        
      ),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 242, 246, 255),
                    Color.fromARGB(255, 242, 246, 255)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 14),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 239, 250, 249), // fond doux
                border: Border.all(
                  color: Colors.teal, // couleur du cadre
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Sélectionnez toutes les intolérances qui vous concernent. Si vous ne trouvez pas la vôtre, ajoutez-la en bas de la liste',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Color.fromARGB(202, 0, 0, 0),
                ),
              ),
            ),

            const SizedBox(height: 24),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: selectedIntolerances.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.4,
              ),
              itemBuilder: (context, index) {
                final item = selectedIntolerances[index];
                return GestureDetector(
                  onTap: () => toggleIntolerance(item.id),
                  child: Container(
                    decoration: BoxDecoration(
                      color: item.selected ?  Colors.white : Colors.white,
                      border: Border.all(
                        color: item.selected
                            ? Colors.blue
                            : Colors.grey[300]!,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch, // important !
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Center( 
                                child: Image.network(
                                  item.image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            if (item.selected)
                              const Positioned(
                                right: 8,
                                top: 8,
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Color.fromARGB(255, 59, 131, 246),
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16, 
                          fontWeight: FontWeight.bold,
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
            if (!showCustomInput) ...[
            GestureDetector(
              onTap: () => setState(() => showCustomInput = true),
              child: Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(top: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.add_circle_outline,
                            color: Color.fromARGB(255, 59, 131, 246)),
                        SizedBox(width: 8),
                        Text(
                          'Ajouter une intolérance personnalisée',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                      const SizedBox(height: 12),
                      DottedBorder(
                        color: Colors.grey.shade400,
                        strokeWidth: 1,
                        dashPattern: [6, 4],
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(8),
                        child: Container(
                          height: 48,
                          alignment: Alignment.center,
                          child: const Text(
                            '+  Cliquez pour ajouter',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ] else ...[
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(top: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.add_circle_outline,
                            color: Color.fromARGB(255, 59, 131, 246)),
                        SizedBox(width: 8),
                        Text(
                          'Ajouter une intolérance personnalisée',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      onChanged: (value) =>
                          setState(() => customIntolerance = value),
                      decoration: const InputDecoration(
                        labelText: "Nom de l'intolérance",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: customIntolerance.trim().isEmpty
                                ? null
                                : addCustomIntolerance,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(140, 8, 181, 149),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Ajouter',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () => setState(() {
                            showCustomInput = false;
                            customIntolerance = '';
                          }),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),

                  ],
                ),
              )
            ],
          const SizedBox(height: 16),
          if (selectedCount > 0)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 14),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 239, 250, 249), // fond doux
                border: Border.all(
                  color: Colors.teal, // couleur du cadre
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Intolérances sélectionnées',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
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
                ],
              ),
            ),


            const SizedBox(height: 24),
            InkWell(
              onTap: selectedCount == 0 ? null : handleSubmit,
              borderRadius: BorderRadius.circular(15),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 59, 131, 246),
                      Color.fromARGB(255, 8, 181, 150)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  child: Text(
                    'Valider mes intolérances ($selectedCount)',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              },
              child: const Text('Passer cette étape'),
            ),

          ],
        ),
      ),
    );
  }

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
        image: 'assets/images/aliments.png',
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
    Navigator.pushNamed(context, '/home');
  }

}
