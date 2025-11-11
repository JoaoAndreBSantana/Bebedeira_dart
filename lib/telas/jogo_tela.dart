import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/carta.dart';


class JogoTela extends StatefulWidget {
  const JogoTela({super.key});

  @override
  State<JogoTela> createState() => _JogoTelaState();
}

class _JogoTelaState extends State<JogoTela> {
  List<Carta> _cartas = [];
  List<Map<String, String>> _categorias = [];
  Carta? _cartaAtual;
  String _filtroCategoria = 'todas';
  final Random _rnd = Random();
  late Future<void> _loader; //future para carregar dados apenas uma vez

  @override
  void initState() {
    super.initState();
    // Inicia o carregamento dos dados no inicio 
    _loader = _loadFullData();
  }

  ///lê o json e retorna lista de cartas
  Future<List<Carta>> loadCartas() async {
    final raw = await rootBundle.loadString('lib/assets/dados_perguntas.json');
    final map = jsonDecode(raw) as Map<String, dynamic>;
    final cartasJson = map['cartas'] as List<dynamic>;
    return cartasJson.map((e) => Carta.fromJson(e as Map<String, dynamic>)).toList();
  }

  
  Future<void> _loadFullData() async {
    final raw = await rootBundle.loadString('lib/assets/dados_perguntas.json');
    final map = jsonDecode(raw) as Map<String, dynamic>;
    final cartasJson = map['cartas'] as List<dynamic>;
    final catJson = map['categorias'] as List<dynamic>;

    _cartas = cartasJson.map((e) => Carta.fromJson(e as Map<String, dynamic>)).toList();
   
    _categorias = catJson.map((e) {
      final m = e as Map<String, dynamic>;
      return {'id': m['id'] as String, 'nome': m['nome'] as String};
    }).toList();

    if (mounted && _cartas.isNotEmpty) {
      _sortearCarta(); 
    }
  }

  ///sorteia uma carta aleatoriamente dentro do filtro atual
  void _sortearCarta() {
    final disponiveis = _filtroCategoria == 'todas'
        ? _cartas
        : _cartas.where((c) => c.categoria == _filtroCategoria).toList();
    if (disponiveis.isEmpty) {
      setState(() => _cartaAtual = null);
      return;
    }
    final index = _rnd.nextInt(disponiveis.length);
    setState(() {
      _cartaAtual = disponiveis[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hora da Bebedeira'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Center(
              child: Text(
                'Beba com responsabilidade (18+)',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.orangeAccent),
              ),
            ),
          )
        ],
      ),
      body: FutureBuilder<void>(
        future: _loader, 
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          
          final dropdownItems = <DropdownMenuItem<String>>[
            const DropdownMenuItem(value: 'todas', child: Text('Todas as Categorias'))
          ];
          dropdownItems.addAll(_categorias.map((c) => DropdownMenuItem(value: c['id'], child: Text(c['nome']!))));

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                //filtro por categoria
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _filtroCategoria,
                      items: dropdownItems,
                      onChanged: (v) {
                        if (v == null) return;
                        setState(() {
                          _filtroCategoria = v;
                          _sortearCarta();
                        });
                      },
                      isExpanded: true,
                      dropdownColor: Colors.grey[800],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                //card central com a carta atual
                Expanded(
                  child: Center(
                    child: _cartaAtual == null
                        ? const Text('Nenhuma carta encontrada para este filtro.', textAlign: TextAlign.center)
                        : Card(
                            elevation: 12,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            color: Colors.grey[900],
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // categoria (nome)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                      
                                        _categorias.firstWhere(
                                          (c) => c['id'] == _cartaAtual!.categoria,
                                          orElse: () => {'nome': _cartaAtual!.categoria.toUpperCase()},
                                        )['nome']!,
                                        style: const TextStyle(color: Colors.pinkAccent, fontWeight: FontWeight.bold),
                                      ),
                                      if (_cartaAtual!.restricao != null)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.orangeAccent,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: const Text('18+', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  
                                  Text(
                                    '${_cartaAtual!.tipo.toUpperCase()} • Nível: ${_cartaAtual!.nivel}',
                                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                                  ),
                                  const SizedBox(height: 12),
                                  // texto grande
                                  Expanded(
                                    child: Center(
                                      child: SingleChildScrollView(
                                        child: Text(
                                          _cartaAtual!.texto,
                                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  
                                  Text(
                                    _getGolesText(_cartaAtual!),
                                    style: const TextStyle(fontSize: 16, color: Colors.white70, fontStyle: FontStyle.italic),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 12),
                //botao de prox carte
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.shuffle),
                    label: const Text('Próxima carta'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.pinkAccent,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _sortearCarta,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Heurística para mostrar texto de goles/efeitos relacionado à carta
  String _getGolesText(Carta c) {
    if (c.goles != null) return 'Goles: ${c.goles}';
    if (c.golesSePular != null) return 'Se pular: ${c.golesSePular} goles';
    if (c.golesPenalidade != null) return 'Penalidade: ${c.golesPenalidade}';
    if (c.golesDistribuir != null) return 'Distribuir: ${c.golesDistribuir}';
    if (c.golesAfetados != null) return 'Afetados: ${c.golesAfetados?.replaceAll(":", " ")}';
    if (c.efeito != null) return 'Efeito: ${c.efeito?.replaceAll("_", " ")}';
    if (c.duracao != null) return 'Duração: ${c.duracao?.replaceAll("_", " ")}';
    return '';
  }
}