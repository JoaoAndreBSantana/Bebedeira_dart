import 'dart:convert';

/// Modelo Carta que representa uma entrada do JSON.
/// Alguns campos são opcionais, por isso são nulos quando ausentes.
class Carta {
  final String id;
  final String categoria;
  final String nivel;
  final String tipo;
  final String texto;
  final int? goles;
  final int? golesSePular;
  final int? golesPenalidade;
  final String? golesAfetados;
  final int? golesDistribuir;
  final String? duracao;
  final String? efeito;
  final String? restricao;

  Carta({
    required this.id,
    required this.categoria,
    required this.nivel,
    required this.tipo,
    required this.texto,
    this.goles,
    this.golesSePular,
    this.golesPenalidade,
    this.golesAfetados,
    this.golesDistribuir,
    this.duracao,
    this.efeito,
    this.restricao,
  });

  /// Construtor a partir de Map (JSON)
  factory Carta.fromJson(Map<String, dynamic> json) {
    return Carta(
      id: json['id'] as String,
      categoria: json['categoria'] as String,
      nivel: json['nivel'] as String,
      tipo: json['tipo'] as String,
      texto: json['texto'] as String,
      goles: json['goles'] is int ? json['goles'] as int : (json['goles'] is String ? int.tryParse(json['goles']) : null),
      golesSePular: json['goles_se_pular'] is int ? json['goles_se_pular'] as int : null,
      golesPenalidade: json['goles_penalidade'] is int ? json['goles_penalidade'] as int : null,
      golesAfetados: json['goles_afetados'] as String?,
      golesDistribuir: json['goles_distribuir'] is int ? json['goles_distribuir'] as int : null,
      duracao: json['duracao'] as String?,
      efeito: json['efeito'] as String?,
      restricao: json['restricao'] as String?,
    );
  }

  /// Converte para Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoria': categoria,
      'nivel': nivel,
      'tipo': tipo,
      'texto': texto,
      if (goles != null) 'goles': goles,
      if (golesSePular != null) 'goles_se_pular': golesSePular,
      if (golesPenalidade != null) 'goles_penalidade': golesPenalidade,
      if (golesAfetados != null) 'goles_afetados': golesAfetados,
      if (golesDistribuir != null) 'goles_distribuir': golesDistribuir,
      if (duracao != null) 'duracao': duracao,
      if (efeito != null) 'efeito': efeito,
      if (restricao != null) 'restricao': restricao,
    };
  }

  @override
  String toString() => jsonEncode(toJson());
}