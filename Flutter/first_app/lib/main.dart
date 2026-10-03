import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

void main() {
  runApp(const MeuAppCompleto());
}

class MeuAppCompleto extends StatelessWidget {
  const MeuAppCompleto({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Atividade Flutter - UNIDAVI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TelaPrincipal(),
    );
  }
}

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  int _abaSelecionada = 0;

  // Lista com as três telas da atividade
  final List<Widget> _telas = [
    const LayoutTutorialPage(), // Parte A: Layout da Documentação
    const CookbookNetworkingPage(), // Parte B (1): Cookbook Consumo de API
    const CookbookAnimationPage(), // Parte B (2): Cookbook Animação
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _abaSelecionada == 0
              ? 'Parte A: Layout Tutorial'
              : _abaSelecionada == 1
                  ? 'Parte B: Cookbook (API)'
                  : 'Parte B: Cookbook (Animação)',
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: _telas[_abaSelecionada],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _abaSelecionada,
        onTap: (index) {
          setState(() {
            _abaSelecionada = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_album),
            label: 'Layout (Lago)',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud_download),
            label: 'Cookbook (API)',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome),
            label: 'Cookbook (Animação)',
          ),
        ],
      ),
    );
  }
}

// ====================================================================
// PARTE A: LAYOUT TUTORIAL (LAGO OESCHINEN)
// ====================================================================

class LayoutTutorialPage extends StatelessWidget {
  const LayoutTutorialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Image.network(
            'https://raw.githubusercontent.com/flutter/website/main/examples/layout/lakes/step5/images/lake.jpg',
            width: double.infinity,
            height: 240,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const SizedBox(
                height: 240,
                child: Center(child: CircularProgressIndicator()),
              );
            },
          ),
          const TitleSection(
            name: 'Oeschinen Lake Campground',
            location: 'Kandersteg, Switzerland',
          ),
          const ButtonSection(),
          const TextSection(
            description:
                'Lake Oeschinen lies at the foot of the Blüemlisalp in the Bernese '
                'Alps. Situated 1,578 meters above sea level, it is one of the '
                'larger Alpine Lakes. A gondola ride from Kandersteg, followed by a '
                'half-hour walk through pine forests and over flowering alpine '
                'meadows, leads you to the lake, which warms to 20 degrees Celsius in '
                'summer. Activities enjoyed here include rowing, and riding the '
                'summer toboggan run.',
          ),
        ],
      ),
    );
  }
}

class TitleSection extends StatelessWidget {
  const TitleSection({
    super.key,
    required this.name,
    required this.location,
  });

  final String name;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  location,
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ],
            ),
          ),
          Icon(Icons.star, color: Colors.red[500]),
          const Text('41'),
        ],
      ),
    );
  }
}

class ButtonSection extends StatelessWidget {
  const ButtonSection({super.key});

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).primaryColor;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildButtonColumn(color, Icons.call, 'CALL'),
        _buildButtonColumn(color, Icons.near_me, 'ROUTE'),
        _buildButtonColumn(color, Icons.share, 'SHARE'),
      ],
    );
  }

  Column _buildButtonColumn(Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

class TextSection extends StatelessWidget {
  const TextSection({super.key, required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Text(
        description,
        softWrap: true,
      ),
    );
  }
}

// ====================================================================
// PARTE B (1): COOKBOOK NETWORKING (API DE CONSELHOS)
// ====================================================================

class CookbookNetworkingPage extends StatefulWidget {
  const CookbookNetworkingPage({super.key});

  @override
  State<CookbookNetworkingPage> createState() => _CookbookNetworkingPageState();
}

class _CookbookNetworkingPageState extends State<CookbookNetworkingPage> {
  String _conselho = "Clique no botão abaixo para buscar um conselho da internet!";
  bool _carregando = false;

  Future<void> _buscarConselho() async {
    setState(() {
      _carregando = true;
    });

    try {
      final response = await http.get(Uri.parse('https://api.adviceslip.com/advice'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _conselho = data['slip']['advice'];
        });
      } else {
        setState(() {
          _conselho = 'Erro ao carregar conselho da API.';
        });
      }
    } catch (e) {
      setState(() {
        _conselho = 'Falha na conexão com a internet.';
      });
    } finally {
      setState(() {
        _carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Cookbook Escolhido:\nFetch Data from the Internet',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.format_quote, size: 40, color: Colors.deepPurple),
                      const SizedBox(height: 12),
                      _carregando
                          ? const CircularProgressIndicator()
                          : Text(
                              _conselho,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _carregando ? null : _buscarConselho,
              icon: const Icon(Icons.refresh),
              label: const Text('Buscar Novo Conselho (API)'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ====================================================================
// PARTE B (2): COOKBOOK ANIMAÇÃO (ANIMATED CONTAINER)
// Exemplo Base: "Animate the properties of a container"
// Modificações Realizadas:
// 1. Gerador aleatório de propriedades visuais (largura, altura, cor e border radius)
// 2. Transições suaves utilizando interpolação de duração e curva (Curves.fastOutSlowIn)
// 3. Botão para resetar os valores ao formato padrão
// ====================================================================

class CookbookAnimationPage extends StatefulWidget {
  const CookbookAnimationPage({super.key});

  @override
  State<CookbookAnimationPage> createState() => _CookbookAnimationPageState();
}

class _CookbookAnimationPageState extends State<CookbookAnimationPage> {
  // Estado inicial das propriedades do container
  double _width = 120;
  double _height = 120;
  Color _color = Colors.deepPurple;
  BorderRadiusGeometry _borderRadius = BorderRadius.circular(12);

  // Função para gerar valores aleatórios
  void _animarContainer() {
    final random = Random();

    setState(() {
      _width = random.nextInt(120).toDouble() + 80;
      _height = random.nextInt(120).toDouble() + 80;
      _color = Color.fromRGBO(
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
        1,
      );
      _borderRadius = BorderRadius.circular(random.nextInt(60).toDouble());
    });
  }

  // Restaurar forma inicial
  void _resetarForma() {
    setState(() {
      _width = 120;
      _height = 120;
      _color = Colors.deepPurple;
      _borderRadius = BorderRadius.circular(12);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Cookbook Escolhido:\nAnimate the properties of a container',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            // Área de exibição do container animado
            SizedBox(
              height: 220,
              child: Center(
                child: AnimatedContainer(
                  width: _width,
                  height: _height,
                  decoration: BoxDecoration(
                    color: _color,
                    borderRadius: _borderRadius,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.fastOutSlowIn,
                  child: const Center(
                    child: Icon(
                      Icons.touch_app,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _animarContainer,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Transformar'),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: _resetarForma,
                  icon: const Icon(Icons.restore),
                  label: const Text('Resetar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}