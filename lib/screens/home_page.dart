import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/pessoa.dart';
import '../widgets/pessoa_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _idController = TextEditingController();

  String? _filmeSelecionado;
  final List<String> _filmesDodo = [
    "O Retorno do Dodô",
    "Dodô Park: O Mundo Perdido",
    "Procurando Dodô",
    "A Era do Dodô",
    "Senhor dos Dodôs: A Sociedade do Pássaro"
  ];

  final List<Pessoa> _pessoas = [];
  final int _capacidadeMaxima = 50;

  int get _pessoasNoAmbiente =>
      _pessoas.where((p) => p.situacao == "No ambiente").length;

  String _obterMensagemSituacao() {
    if (_pessoasNoAmbiente >= _capacidadeMaxima) {
      return "Ambiente lotado! Ingressos esgotados";
    } else if (_pessoasNoAmbiente >= 40) {
      return "Atenção: Ingressos esgotando!";
    } else {
      return "Ingressos disponíveis";
    }
  }

  void _mostrarMensagem(String mensagem, Color cor) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem), backgroundColor: cor),
    );
  }

  void _cadastrar() {
    final nome = _nomeController.text.trim();
    final id = _idController.text.trim();

    if (nome.isEmpty || id.isEmpty || _filmeSelecionado == null) {
      _mostrarMensagem(
        "Preencha todos os campos obrigatórios e escolha um filme!",
        const Color(0xFFE74C3C),
      );
      return;
    }

    final numeroIngresso = int.tryParse(id);
    if (numeroIngresso == null || numeroIngresso < 1 || numeroIngresso > 10) {
      _mostrarMensagem(
        "O assento deve ser um número entre 1 e 10!",
        const Color(0xFFE74C3C),
      );
      return;
    }

    if (_pessoasNoAmbiente >= _capacidadeMaxima) {
      _mostrarMensagem(
        "Não é possível realizar a entrada. Cinema lotado!",
        const Color(0xFFE74C3C),
      );
      return;
    }

    final pessoasNesteFilme = _pessoas.where((p) => 
      p.filmeSelecionado == _filmeSelecionado && p.situacao == "No ambiente"
    ).length;

    if (pessoasNesteFilme >= 10) {
      _mostrarMensagem(
        "A sessão para '$_filmeSelecionado' está lotada (10/10)!",
        const Color(0xFFE74C3C),
      );
      return;
    }

    final idEmUsoSimultaneo = _pessoas.any(
      (p) => p.identificacao == id && p.filmeSelecionado == _filmeSelecionado && p.situacao == "No ambiente",
    );

    if (idEmUsoSimultaneo) {
      _mostrarMensagem(
        "O assento $id já está ocupado para o filme $_filmeSelecionado!",
        const Color(0xFFF39C12),
      );
      return;
    }

    setState(() {
      _pessoas.add(
        Pessoa(
          nome: nome,
          identificacao: id,
          filmeSelecionado: _filmeSelecionado!,
          dataEntrada: DateTime.now(),
        ),
      );
      _nomeController.clear();
      _idController.clear();
      _filmeSelecionado = null;
    });

    FocusScope.of(context).unfocus();
    _mostrarMensagem("Entrada registrada com sucesso no assento $id!", const Color(0xFF27AE60));
  }

  void _confirmarSaida(Pessoa pessoa) {
    if (pessoa.situacao == "Saiu") {
      _mostrarMensagem(
        "Operação inválida: ${pessoa.nome} já saiu do ambiente!",
        const Color(0xFFE74C3C),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Registrar saída?"),
        content: Text("Deseja realmente registrar a saída de ${pessoa.nome}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("CANCELAR"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2C3E50),
            ),
            onPressed: () {
              setState(() {
                pessoa.situacao = "Saiu";
                pessoa.dataSaida = DateTime.now();
              });
              Navigator.of(ctx).pop();
              _mostrarMensagem(
                "Saída registrada com sucesso!",
                const Color(0xFF2980B9),
              );
            },
            child: const Text(
              "CONFIRMAR",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmarExclusao(Pessoa pessoa) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Excluir registro?"),
        content: Text("Deseja realmente excluir o registro de ${pessoa.nome}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("CANCELAR"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE74C3C),
            ),
            onPressed: () {
              setState(() {
                _pessoas.remove(pessoa);
              });
              Navigator.of(ctx).pop();
              _mostrarMensagem(
                "Registro removido com sucesso!",
                const Color(0xFFE74C3C),
              );
            },
            child: const Text(
              "CONFIRMAR",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECF0F1),
      appBar: AppBar(
        title: Text(
          "CineDodô Manager",
          style: GoogleFonts.oswald(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF8B0000),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2C3E50),
                image: DecorationImage(
                  image: const AssetImage("assets/images/filme_cartaz_bg.jpeg"),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withAlpha(170),
                    BlendMode.darken,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Pessoas no cinema:",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "$_pessoasNoAmbiente/$_capacidadeMaxima",
                        style: TextStyle(
                          color: _pessoasNoAmbiente >= _capacidadeMaxima
                              ? const Color(0xFFE74C3C)
                              : const Color(0xFF2ECC71),
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Status: ${_obterMensagemSituacao()}",
                      style: const TextStyle(
                        color: Color(0xFFF1C40F),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  TextField(
                    controller: _nomeController,
                    decoration: const InputDecoration(
                      labelText: "Nome da pessoa",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _idController,
                    decoration: const InputDecoration(
                      labelText: "Número do Assento (1 a 10)",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.confirmation_number),
                      isDense: true,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    key: ValueKey(_filmeSelecionado),
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: "Filme Escolhido",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.movie),
                      isDense: true,
                    ),
                    initialValue: _filmeSelecionado,
                    items: _filmesDodo.map((filme) {
                      return DropdownMenuItem(
                        value: filme,
                        child: Text(filme, overflow: TextOverflow.ellipsis,),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _filmeSelecionado = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B0000),
                      ),
                      onPressed: _cadastrar,
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text(
                        "Registrar Entrada",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(thickness: 2, height: 1),

            Expanded(
              child: _pessoas.isEmpty
                  ? const Center(
                      child: Text("Nenhuma pessoa registrada no CineDodô."),
                    )
                  : ListView.builder(
                      itemCount: _pessoas.length,
                      itemBuilder: (context, index) {
                        final pessoa = _pessoas[index];
                        return PessoaItem(
                          pessoa: pessoa,
                          onSaida: () => _confirmarSaida(pessoa),
                          onExcluir: () => _confirmarExclusao(pessoa),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}