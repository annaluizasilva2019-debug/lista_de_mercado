import 'package:flutter/material.dart';

void main() {
  runApp(const ListaComprasApp());
}

class MercadoColors {
  static const verde = Color(0xFF2E7D32);
  static const verdeClaro = Color(0xFF66BB6A);
  static const amarelo = Color(0xFFFFC107);
  static const laranja = Color(0xFFF57C00);
  static const vermelho = Color(0xFFE53935);
  static const creme = Color(0xFFFFF8E1);
  static const branco = Colors.white;
  static const cinzaEscuro = Color(0xFF37474F);
  static const cinza = Color(0xFF78909C);
  static const cinzaClaro = Color(0xFFECEFF1);
}

class ListaComprasApp extends StatelessWidget {
  const ListaComprasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mercadinho',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: MercadoColors.creme,
        colorScheme: ColorScheme.fromSeed(
          seedColor: MercadoColors.verde,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: MercadoColors.verde,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
        ),
      ),
      home: const ListaScreen(),
    );
  }
}

class ItemCompra {
  final String id;
  String nome;
  int quantidade;
  bool comprado;
  final String categoria;
  final IconData icone;

  ItemCompra({
    required this.id,
    required this.nome,
    required this.quantidade,
    this.comprado = false,
    this.categoria = 'Geral',
    this.icone = Icons.shopping_basket,
  });
}

class ListaScreen extends StatefulWidget {
  const ListaScreen({super.key});

  @override
  State<ListaScreen> createState() => _ListaScreenState();
}

class _ListaScreenState extends State<ListaScreen> {
  final List<ItemCompra> _itens = [
    ItemCompra(
      id: '1',
      nome: 'Arroz',
      quantidade: 2,
      categoria: 'Grãos',
      icone: Icons.rice_bowl,
    ),
    ItemCompra(
      id: '2',
      nome: 'Feijão',
      quantidade: 1,
      comprado: true,
      categoria: 'Grãos',
      icone: Icons.rice_bowl,
    ),
    ItemCompra(
      id: '3',
      nome: 'Leite',
      quantidade: 6,
      categoria: 'Frios',
      icone: Icons.local_drink,
    ),
    ItemCompra(
      id: '4',
      nome: 'Banana',
      quantidade: 12,
      categoria: 'Frutas',
      icone: Icons.eco,
    ),
  ];

  int get _totalComprados => _itens.where((item) => item.comprado).length;

  double get _progresso =>
      _itens.isEmpty ? 0 : _totalComprados / _itens.length;

  Future<void> _abrirCadastro() async {
    final ItemCompra? novoItem = await Navigator.push<ItemCompra>(
      context,
      MaterialPageRoute(builder: (_) => const CadastroScreen()),
    );

    if (novoItem != null) {
      setState(() => _itens.add(novoItem));
      _mostrarSnackBar('🛒 "${novoItem.nome}" adicionado à lista!');
    }
  }

  void _alternarComprado(ItemCompra item) {
    setState(() => item.comprado = !item.comprado);
  }

  void _removerItem(ItemCompra item) {
    setState(() => _itens.removeWhere((i) => i.id == item.id));
    _mostrarSnackBar(
      '🗑️ "${item.nome}" removido da lista.',
      cor: MercadoColors.vermelho,
    );
  }

  void _mostrarSnackBar(String mensagem,
      {Color cor = MercadoColors.verde}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          mensagem,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: cor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.storefront,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Mercadinho',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  'Sua lista de compras',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildPlacaProgresso(),
          Expanded(
            child: _itens.isEmpty
                ? _buildListaVazia()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 100),
                    itemCount: _itens.length,
                    itemBuilder: (context, index) {
                      final item = _itens[index];
                      return _buildCardItem(item, index);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirCadastro,
        backgroundColor: MercadoColors.laranja,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        icon: const Icon(Icons.add_shopping_cart),
        label: const Text(
          'Adicionar',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _buildPlacaProgresso() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [MercadoColors.verde, MercadoColors.verdeClaro],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: MercadoColors.verde.withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: MercadoColors.amarelo,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.shopping_cart_checkout,
                  color: MercadoColors.cinzaEscuro,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'SEU CARRINHO',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _totalComprados == _itens.length && _itens.isNotEmpty
                          ? 'Tudo comprado! 🎉'
                          : '$_totalComprados de ${_itens.length} itens',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: MercadoColors.amarelo,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  '${(_progresso * 100).toInt()}%',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: MercadoColors.cinzaEscuro,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: [
                Container(
                  height: 10,
                  color: Colors.white.withOpacity(0.25),
                ),
                FractionallySizedBox(
                  widthFactor: _progresso,
                  child: Container(
                    height: 10,
                    decoration: const BoxDecoration(
                      color: MercadoColors.amarelo,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardItem(ItemCompra item, int index) {
    final corCategoria = _corCategoria(item.categoria);

    return Card(
      elevation: item.comprado ? 0 : 3,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: item.comprado
              ? MercadoColors.cinzaClaro
              : corCategoria.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      color: item.comprado ? MercadoColors.cinzaClaro : Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _alternarComprado(item),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: item.comprado
                      ? MercadoColors.cinza.withOpacity(0.2)
                      : corCategoria.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: item.comprado
                        ? MercadoColors.cinza.withOpacity(0.3)
                        : corCategoria.withOpacity(0.4),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  item.icone,
                  color: item.comprado ? MercadoColors.cinza : corCategoria,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.nome,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: item.comprado
                            ? MercadoColors.cinza
                            : MercadoColors.cinzaEscuro,
                        decoration: item.comprado
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        decorationThickness: 2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: MercadoColors.amarelo.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.numbers,
                            size: 11,
                            color: MercadoColors.laranja,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '${item.quantidade} un',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: MercadoColors.laranja,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Transform.scale(
                    scale: 1.1,
                    child: Checkbox(
                      value: item.comprado,
                      activeColor: MercadoColors.verde,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      onChanged: (_) => _alternarComprado(item),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    color: MercadoColors.vermelho,
                    tooltip: 'Remover',
                    visualDensity: VisualDensity.compact,
                    onPressed: () => _removerItem(item),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _corCategoria(String categoria) {
    switch (categoria.toLowerCase()) {
      case 'grãos':
        return const Color(0xFF8D6E63);
      case 'frios':
        return const Color(0xFF42A5F5);
      case 'frutas':
        return const Color(0xFFEF5350);
      case 'verduras':
        return MercadoColors.verde;
      case 'bebidas':
        return const Color(0xFF7E57C2);
      case 'limpeza':
        return const Color(0xFF26A69A);
      case 'carnes':
        return const Color(0xFFD32F2F);
      case 'padaria':
        return const Color(0xFFFFA726);
      default:
        return MercadoColors.cinza;
    }
  }

  Widget _buildListaVazia() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: MercadoColors.verdeClaro.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: MercadoColors.verde,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Carrinho vazio!',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: MercadoColors.cinzaEscuro,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Adicione itens para começar as compras',
            style: TextStyle(fontSize: 14, color: MercadoColors.cinza),
          ),
        ],
      ),
    );
  }
}

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _qtdController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    final novoItem = ItemCompra(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nome: _nomeController.text.trim(),
      quantidade: int.parse(_qtdController.text.trim()),
    );

    Navigator.pop(context, novoItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.add_business,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Novo Produto',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSecaoTitulo('📝 Informações do produto'),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nomeController,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: 'Nome do produto',
                  hintText: 'Ex: Arroz, Banana, Leite...',
                  prefixIcon: const Icon(
                    Icons.shopping_bag_outlined,
                    color: MercadoColors.verde,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: MercadoColors.verde,
                      width: 2,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o nome do produto';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _qtdController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Quantidade',
                  hintText: 'Ex: 2',
                  prefixIcon: const Icon(
                    Icons.numbers,
                    color: MercadoColors.verde,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: MercadoColors.verde,
                      width: 2,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe a quantidade';
                  }
                  final n = int.tryParse(value.trim());
                  if (n == null || n <= 0) {
                    return 'Digite um número maior que zero';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _salvar,
                  icon: const Icon(Icons.check_circle_outline, size: 24),
                  label: const Text(
                    'Adicionar ao carrinho',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.3,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MercadoColors.laranja,
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shadowColor: MercadoColors.laranja.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecaoTitulo(String texto) {
    return Row(
      children: [
        Text(
          texto,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: MercadoColors.cinzaEscuro,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            height: 1.5,
            color: MercadoColors.cinzaClaro,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _qtdController.dispose();
    super.dispose();
  }
