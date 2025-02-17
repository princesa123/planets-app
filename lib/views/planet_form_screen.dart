import 'package:flutter/material.dart';
import 'package:myapp/view_models/planet_view_model.dart';
import 'package:provider/provider.dart';
import '../models/planet.dart';

// É a mesma tela para editar ou adicionar, muda a condição caso os dados estejam sendo passados
class PlanetFormScreen extends StatefulWidget {
  final Planet? planet;

  // Cria a tela
  const PlanetFormScreen({Key? key, this.planet}) : super(key: key);

  @override
  _PlanetFormScreenState createState() => _PlanetFormScreenState();
}

class _PlanetFormScreenState extends State<PlanetFormScreen> {
  final _formKey = GlobalKey<FormState>();
  // Cria as variáveis para manipular os dados que podem ser preenchidas depois da tela carregar
  late TextEditingController _nameController;
  late TextEditingController _distanceController;
  late TextEditingController _sizeController;
  late TextEditingController _nicknameController;

  @override
  void initState() {
    super.initState();
    // Preenche os dados caso estejam sendo passados pelo componente que chamou a rota
    _nameController = TextEditingController(text: widget.planet?.name ?? '');
    _distanceController = TextEditingController(
      text: widget.planet?.distance.toString() ?? '',
    );
    _sizeController = TextEditingController(
      text: widget.planet?.size.toString() ?? '',
    );
    _nicknameController = TextEditingController(
      text: widget.planet?.nickname ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _distanceController.dispose();
    _sizeController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  void _savePlanet() async {
    if (_formKey.currentState!.validate()) {
      // Cria um objeto para salvar no banco
      final planet = Planet(
        id: widget.planet?.id,
        name: _nameController.text,
        distance: double.parse(_distanceController.text),
        size: double.parse(_sizeController.text),
        nickname:
            _nicknameController.text.isEmpty ? null : _nicknameController.text,
      );

      final planetProvider = Provider.of<PlanetProvider>(
        context,
        listen: false,
      );

      if (widget.planet == null) {
        // Insere de um novo planeta
        await planetProvider.addPlanet(context, planet);
      } else {
        // Atualiza um planeta existente
        await planetProvider.updatePlanet(context, planet);
      }

      // Atualiza a lista de planetas na tela inicial
      await planetProvider.fetchPlanets();

      // Retorna para a HomeScreen
      Navigator.pop(context);
    }
  }

  String? _validateTextField(String? value, String fieldName) {
    // Validação de campos
    if (value == null || value.trim().isEmpty) {
      return '$fieldName é obrigatório';
    }
    return null;
  }

  String? _validateNumberField(String? value, String fieldName) {
    // Validação de campos numéricos
    if (value == null || value.trim().isEmpty) {
      return '$fieldName é obrigatório';
    }
    final number = double.tryParse(value);
    if (number == null || number <= 0) {
      return '$fieldName deve ser um número válido maior que 0';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          // É a mesma tela para editar ou adicionar, muda a condição caso os dados estejam sendo passados
          widget.planet == null ? 'Adicionar Planeta' : 'Editar Planeta',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Adicionas os campos na tela vinculados à variáveis declaradas anteriormente
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome do Planeta'),
                validator:
                    (value) => _validateTextField(value, 'Nome do Planeta'),
              ),
              TextFormField(
                controller: _distanceController,
                decoration: const InputDecoration(
                  labelText: 'Distância do Sol (UA)',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator:
                    (value) => _validateNumberField(value, 'Distância do Sol'),
              ),
              TextFormField(
                controller: _sizeController,
                decoration: const InputDecoration(labelText: 'Tamanho (km)'),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) => _validateNumberField(value, 'Tamanho'),
              ),
              TextFormField(
                controller: _nicknameController,
                decoration: const InputDecoration(
                  labelText: 'Apelido (Opcional)',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _savePlanet,
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
