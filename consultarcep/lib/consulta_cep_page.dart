import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConsultaCEP extends StatefulWidget {
  @override
  _ConsultaCEP createState() => _ConsultaCEP();
}

class _ConsultaCEP extends State<ConsultaCEP> {
  final TextEditingController _cepController = TextEditingController();
  String _resultado = "";

  void _buscarCEP() async {
    String cep = _cepController.text;
    final url = Uri.parse("https://viacep.com.br/ws/$cep/json/");
    final resposta = await http.get(url);

    if (resposta.statusCode == 200) {
      final Map<String, dynamic> dados = json.decode(resposta.body);

      if (dados.containsKey("erro")) {
        setState(() {
          _resultado = "CEP não encontrado!";
        });
      } else {
        setState(() {
          _resultado =
              "${dados['logradouro']}, ${dados['bairro']}, ${dados['localidade']} - ${dados['uf']}";
        });
      }
    } else {
      setState(() {
        _resultado = "Erro ao buscar o CEP!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Consulta de CEP")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("CEP", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _cepController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: "Digite o CEP"),
            ),
            SizedBox(height: 20),
            Text(_resultado),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _buscarCEP,
        child: Icon(Icons.search),
      ),
    );
  }
}
