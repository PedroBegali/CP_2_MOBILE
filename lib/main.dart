import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class SalaCinema {
  final int _capacidadeMaxima;
  int _pessoasNoLocal;

  SalaCinema.iniciar({required int capacidade})
    : _capacidadeMaxima = capacidade,
      _pessoasNoLocal = 0;

  int get pessoasNoLocal => _pessoasNoLocal;
  bool get isEmpty => _pessoasNoLocal == 0;
  bool get isFull => _pessoasNoLocal == _capacidadeMaxima;
  bool get isAlmostFull =>
      _pessoasNoLocal >= 40 && _pessoasNoLocal < _capacidadeMaxima;

  set definirPessoas(int valor) {
    if (valor >= 0 && valor <= _capacidadeMaxima) {
      _pessoasNoLocal = valor;
    }
  }

  void adicionarPessoa() {
    if (!isFull) {
      _pessoasNoLocal++;
    }
  }

  void removerPessoa() {
    if (!isEmpty) {
      _pessoasNoLocal--;
    }
  }

  String obterMensagemSituacao() {
    if (isFull) {
      return "Ingressos esgotados";
    } else if (isAlmostFull) {
      return "Ingressos esgotando";
    } else {
      return "Ingressos disponíveis";
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SalaCinema meuCinema = SalaCinema.iniciar(capacidade: 50);

  void decrement() {
    setState(() {
      meuCinema.removerPessoa();
    });
  }

  void increment() {
    setState(() {
      meuCinema.adicionarPessoa();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/filme_cartaz_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Column(
                children: [
                  Text(
                    meuCinema.obterMensagemSituacao(),
                    style: const TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      shadows: [
                        Shadow(offset: Offset(-2, -2), color: Colors.black),
                        Shadow(offset: Offset(2, -2), color: Colors.black),
                        Shadow(offset: Offset(2, 2), color: Colors.black),
                        Shadow(offset: Offset(-2, 2), color: Colors.black),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Pessoas na sala",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      shadows: [
                        Shadow(offset: Offset(-1.5, -1.5), color: Colors.black),
                        Shadow(offset: Offset(1.5, -1.5), color: Colors.black),
                        Shadow(offset: Offset(1.5, 1.5), color: Colors.black),
                        Shadow(offset: Offset(-1.5, 1.5), color: Colors.black),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 170.0),
              child: Text(
                meuCinema.pessoasNoLocal.toString(),
                style: const TextStyle(
                  fontSize: 95,
                  color: Color.fromARGB(255, 85, 1, 1),
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(offset: Offset(-2, -2), color: Colors.white),
                    Shadow(offset: Offset(2, -2), color: Colors.white),
                    Shadow(offset: Offset(2, 2), color: Colors.white),
                    Shadow(offset: Offset(-2, 2), color: Colors.white),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 42.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: meuCinema.isEmpty ? null : decrement,
                    style: TextButton.styleFrom(
                      backgroundColor: meuCinema.isEmpty
                          ? Colors.white.withAlpha(90)
                          : Colors.white,
                      fixedSize: const Size(180, 35),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Remover",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(width: 40),

                  TextButton(
                    onPressed: meuCinema.isFull ? null : increment,
                    style: TextButton.styleFrom(
                      backgroundColor: meuCinema.isFull
                          ? Colors.white.withAlpha(90)
                          : Colors.white,
                      fixedSize: const Size(180, 35),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Adicionar",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
