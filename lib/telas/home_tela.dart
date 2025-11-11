import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'jogo_tela.dart';

class HomeTela extends StatelessWidget {
  const HomeTela({super.key});

  // Lê a seção  do json
  Future<Map<String, dynamic>> _loadMeta() async {
    final raw = await rootBundle.loadString('lib/assets/dados_perguntas.json');
    final map = jsonDecode(raw) as Map<String, dynamic>;
    return map['meta'] as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    
    final primary = Colors.pinkAccent;
    final accent = Colors.deepPurpleAccent; 
    final avisoColor = Colors.orangeAccent;

    return Scaffold(
      appBar: AppBar(title: const Text('Bebedeira com Amigos')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _loadMeta(),
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final meta = snap.data ?? {};
          final nome = meta['nome'] ?? 'Bebedeira com Amigos';
          final descricao = meta['descricao'] ?? '';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 24),

                // card principal 
                Card(
                  elevation: 16,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  color: Colors.grey[900],
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      children: [
                      
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                          decoration: BoxDecoration(
                            color: primary.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: primary.withOpacity(0.6)),
                          ),
                          child: Text(
                            nome,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: primary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        const SizedBox(height: 12),

                        
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                          decoration: BoxDecoration(
                            color: accent.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: accent.withOpacity(0.5)),
                          ),
                          child: Text(
                            descricao,
                            style: TextStyle(fontSize: 14, color: Colors.white70),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        const SizedBox(height: 12),

                       
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                          decoration: BoxDecoration(
                            color: avisoColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: avisoColor.withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              )
                            ],
                          ),
                          child: Text(
                            'Beba com responsabilidade (18+)',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: primary.withOpacity(0.6)),
                  ),
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      foregroundColor: primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      backgroundColor: Colors.transparent,
                    ),
                    icon: Icon(Icons.play_arrow, color: primary),
                    label: Text('Começar o Jogo',
                        style: TextStyle(color: primary, fontSize: 18, fontWeight: FontWeight.bold)),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const JogoTela()));
                    },
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}