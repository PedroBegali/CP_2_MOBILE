class Pessoa {
  String nome;
  String identificacao;
  String filmeSelecionado;
  DateTime dataEntrada;
  DateTime? dataSaida;
  String situacao;

  Pessoa({
    required this.nome,
    required this.identificacao,
    required this.filmeSelecionado,
    required this.dataEntrada,
    this.situacao = "No ambiente",
  });
}