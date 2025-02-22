import 'package:flutter/material.dart';
import 'package:myapp/telas/tela_planeta.dart';
import 'package:myapp/controle/ctrl_planeta.dart';
import 'package:myapp/modelos/planeta.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  MyHomePage(title: 'Planetas'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late CtrlPlaneta _ctrlPlaneta;

  @override
  void initState() {
    super.initState();
    _ctrlPlaneta = CtrlPlaneta();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListenableBuilder(
        listenable: _ctrlPlaneta,
        builder: (context, child) {
          return FutureBuilder<List<Planeta>>(
            future: _ctrlPlaneta.listarPlanetas(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Erro: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                final planetas = snapshot.data!;
                return ListView.builder(
                  itemCount: planetas.length,
                  itemBuilder: (context, index) {
                    final planeta = planetas[index];
                    return ListTile(
                      title: Text(planeta.nome),
                      subtitle:
                          Text('Distância: ${planeta.distancia.toString()}'),
                    );
                  },
                );
              } else {
                return const Center(child: Text('Nenhum planeta encontrado.'));
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      TelaPlaneta(ctrlPlaneta: _ctrlPlaneta))).then((value) {
                        if(value == true){
                           setState(() {
                           });
                        }

                      });
        },
        tooltip: 'Editar/Criar Planeta',
        child: const Icon(Icons.add),
      ),
    );
  }
}
