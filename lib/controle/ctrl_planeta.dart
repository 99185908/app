import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';

import '../modelos/modelo_planeta.dart';
import '../modelos/planeta.dart';

class CtrlPlaneta {
  static Database? _bd;

  Future<Database> get bd async {
    if (_bd != null) return _bd!;
    _bd = await _initBD('planeta.bd');
    return _bd!;
  }

  Future<Database> _initBD(String localArquivo) async {
    final caminhoBD = await getDatabasesPath();
    final caminho = join(caminhoBD, localArquivo);
    print(caminho);
    return await openDatabase(caminho, version: 1, onCreate: _criarBD);
  }
  Future<void> _criarBD(Database bd, int versao) async {
    const slq = '''
  CREATE TABLE planetas (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT,
    tamanho REAL,
    distancia REAL,
    apelido TEXT
  )
  ''';
  await bd.execute(slq);
  }

  Future<int> criarPlaneta(Planeta planeta) async {
    final bd = await this.bd;
    return await bd.insert('planetas', planeta.toMap());
  }

    // Função para criar um novo planeta e atualizar a lista.
  Future<void> criarPlanetaEAtualizar(Planeta planeta) async {
    await criarPlaneta(planeta);
    _notificarListeners(); // Notificar os ouvintes após a criação.
  }

  Future<int> excluirPlaneta(int id) async {
    final bd = await this.bd;
    return await bd.delete('planetas', where: 'id = ?', whereArgs: [id]);
  }

    // Função para excluir um planeta e atualizar a lista.
  Future<void> excluirPlanetaEAtualizar(int id) async {
    await excluirPlaneta(id);
    _notificarListeners(); // Notificar os ouvintes após a exclusão.
  }

  Future<int> editarPlaneta(Planeta planeta) async {
    if (planeta.id == null) {
      throw Exception('ID do planeta não pode ser nulo para edição.');
    }
    final bd = await this.bd;
    return await bd.update(
      'planetas',
      planeta.toMap(),
      where: 'id = ?',
      whereArgs: [planeta.id],
    );
  }

    // Função para editar um planeta e atualizar a lista.
  Future<void> editarPlanetaEAtualizar(Planeta planeta) async {
    await editarPlaneta(planeta);
    _notificarListeners(); // Notificar os ouvintes após a edição.
  }

    // Função para listar planetas e atualizar a lista.
  Future<List<Planeta>> listarPlanetas() async {
    final bd = await this.bd;
    final List<Map<String, dynamic>> mapPlanetas = await bd.query('planetas');

    return List.generate(mapPlanetas.length, (index) {
      return Planeta(
        id: mapPlanetas[index]['id'] as int,
        nome: mapPlanetas[index]['nome'] as String,
        tamanho: mapPlanetas[index]['tamanho'] as double,
        distancia: mapPlanetas[index]['distancia'] as double,
        apelido: mapPlanetas[index]['apelido'] as String,
      );
    });
  }

  // Gerenciamento de ouvintes para notificações de mudanças.
  final List<VoidCallback> _listeners = [];

  // Adiciona um ouvinte à lista.
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  // Remove um ouvinte da lista.
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  // Notifica todos os ouvintes de que houve uma mudança nos dados.
  void _notificarListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }
}

