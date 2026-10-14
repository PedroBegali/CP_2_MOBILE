import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import '../models/pessoa.dart';

class PessoaItem extends StatelessWidget {
  final Pessoa pessoa;
  final VoidCallback onSaida;
  final VoidCallback onExcluir;

  const PessoaItem({
    super.key,
    required this.pessoa,
    required this.onSaida,
    required this.onExcluir,
  });

  @override
  Widget build(BuildContext context) {
    final formatoData = DateFormat("dd/MM/yyyy 'às' HH:mm");
    final dataEntradaFormatada = formatoData.format(pessoa.dataEntrada);
    final dataSaidaFormatada = pessoa.dataSaida != null
        ? formatoData.format(pessoa.dataSaida!)
        : null;

    final bool estaNoAmbiente = pessoa.situacao == "No ambiente";

    return Slidable(
      key: ObjectKey(pessoa),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onSaida(),
            backgroundColor: estaNoAmbiente
                ? const Color(0xFFF39C12)
                : const Color(0xFF95A5A6),
            foregroundColor: Colors.white,
            icon: Icons.exit_to_app,
            label: 'SAÍDA',
          ),
          SlidableAction(
            onPressed: (_) => onExcluir(),
            backgroundColor: const Color(0xFFE74C3C),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'EXCLUIR',
          ),
        ],
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pessoa.nome,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text("ID (Assento): ${pessoa.identificacao}"),
              Text(
                "Filme: ${pessoa.filmeSelecionado}",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF8B0000),
                ),
              ),
              Text("Entrada: $dataEntradaFormatada"),
              if (dataSaidaFormatada != null)
                Text("Saída: $dataSaidaFormatada"),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    estaNoAmbiente ? Icons.event_seat : Icons.directions_run,
                    color: estaNoAmbiente
                        ? const Color(0xFF27AE60)
                        : const Color(0xFF7F8C8D),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Situação: ${pessoa.situacao}",
                    style: TextStyle(
                      color: estaNoAmbiente
                          ? const Color(0xFF27AE60)
                          : const Color(0xFF7F8C8D),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}