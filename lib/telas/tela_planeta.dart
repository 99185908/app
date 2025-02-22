import 'package:flutter/material.dart';
import 'package:myapp/modelos/planeta.dart';
import 'package:myapp/controle/ctrl_planeta.dart';

class TelaPlaneta extends StatefulWidget {
  final CtrlPlaneta _ctrlPlaneta;
  final Planeta? planetaParaEditar;

  TelaPlaneta(this._ctrlPlaneta, {this.planetaParaEditar});

  @override
  _TelaPlanetaState createState() => _TelaPlanetaState(_ctrlPlaneta, planetaParaEditar: planetaParaEditar);
}

class _TelaPlanetaState extends State<TelaPlaneta> {  
    final CtrlPlaneta _ctrlPlaneta;
  Planeta _planeta = Planeta.vazio();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _tamanhoController = TextEditingController();
  final TextEditingController _distanciaController = TextEditingController();
  final TextEditingController _apelidoController = TextEditingController();

  _TelaPlanetaState(this._ctrlPlaneta, {Planeta? planetaParaEditar}) {
    if (planetaParaEditar != null) {
      _planeta = planetaParaEditar;
      _nameController.text = _planeta.nome;
      _tamanhoController.text = _planeta.tamanho.toString();
      _distanciaController.text = _planeta.distancia.toString();
      _apelidoController.text = _planeta.apelido;
    }
  }


  @override
  void initState() {
    // _nameController.text = 'Terra';
    // _tamanhoController.text = '1000';
   // _distanciaController.text = '1000000000';
  //  _apelidoController.text = 'terra';
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _tamanhoController.dispose();
    _distanciaController.dispose();
    _apelidoController.dispose();
    super.dispose();
  }

  Future<void> _salvarPlaneta() async {
    if (_planeta.id == -1) {
      await _ctrlPlaneta.criarPlaneta(_planeta);
       
    } else {
      await _ctrlPlaneta.editarPlaneta(_planeta);
      
    }
    
  }
  void _mostrarMensagem(String mensagem) {
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
      ),
    );
  }

  Future<void> _submitform() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
          await _salvarPlaneta();
          _mostrarMensagem("Planeta salvo com sucesso");
        Navigator.of(context).pop(true);
      } catch(e){
          _mostrarMensagem("Erro ao salvar planeta");
      }
      


    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tela Planeta'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um Planeta valido';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _planeta.nome = value!;
                  },
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: _tamanhoController,
                  decoration: InputDecoration(
                    labelText: 'Tamanho (em km)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um tamanho valido';
                    }
                    if (double.tryParse(value) == null) {
                      return 'São aceitos apenas numeros';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _planeta.tamanho = double.parse(value!);
                  },
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: _distanciaController,
                  decoration: InputDecoration(
                    labelText: 'Distancia (em km)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira uma distancia valida';
                    }
                    if (double.tryParse(value) == null) {
                      return 'São aceitos apenas numeros';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _planeta.distancia = double.parse(value!);
                  },
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: _apelidoController,
                  decoration: InputDecoration(
                    labelText: 'Apelido',
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (value) {
                    _planeta.apelido = value!;
                  },
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () => _submitform(),
                  child: Text('salvar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
