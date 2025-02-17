import 'package:flutter/material.dart';

import 'controles/controle_planeta.dart';
import 'modelos/planeta.dart';
import 'telas/tela_planeta.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Este widget é a raiz do aplicativo.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Planetas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(
        title: 'Aplicativo - Planeta',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ControlePlaneta _controlePlaneta = ControlePlaneta();
  List<Planeta> _planetas = [];

  @override
  void initState() {
    super.initState();
    _atualizarPlanetas(); // Atualiza a lista de planetas ao iniciar a tela
  }

  // Obtém a lista de planetas do controlador e atualiza o estado
  Future<void> _atualizarPlanetas() async {
    final resultado = await _controlePlaneta.lerPlanetas();
    setState(() {
      _planetas = resultado;
    });
  }

  // Abre a tela para inclusão de um novo planeta
  void _incluirPlaneta(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaPlaneta(
          isIncluir: true,
          planeta: Planeta.vazio(),
          onFinalizado: () {
            _atualizarPlanetas();
          },
        ),
      ),
    );
  }

  // Abre a tela para alteração de um planeta existente
  void _alterarPlaneta(BuildContext context, Planeta planeta) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaPlaneta(
          isIncluir: false,
          planeta: planeta,
          onFinalizado: () {
            _atualizarPlanetas();
          },
        ),
      ),
    );
  }

  // Exclui um planeta pelo ID e atualiza a lista
  void _excluirPlaneta(int id) async {
    await _controlePlaneta.excluirPlaneta(id);
    _atualizarPlanetas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: _planetas.length,
        itemBuilder: (context, index) {
          final planeta = _planetas[index];
          return ListTile(
              title: Text(planeta.nome),
              subtitle: Text(planeta.apelido!),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _alterarPlaneta(context, planeta),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _excluirPlaneta(planeta.id!),
                  ),
                ],
              ));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _incluirPlaneta(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
