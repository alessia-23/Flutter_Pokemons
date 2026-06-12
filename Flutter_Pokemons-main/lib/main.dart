import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'models/pokemon.dart';
import 'services/pokemon_service.dart';

void main() {
  runApp(const PokemonApp());
}

class PokemonApp extends StatelessWidget {
  const PokemonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokédex Alessia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F3EF),
        colorSchemeSeed: const Color(0xFFD68C8C),
      ),
      home: const PokemonPage(),
    );
  }
}

class PokemonPage extends StatefulWidget {
  const PokemonPage({super.key});

  @override
  State<PokemonPage> createState() => _PokemonPageState();
}

class _PokemonPageState extends State<PokemonPage> {
  static const int pageSize = 5;

  final TextEditingController _searchController = TextEditingController();
  Pokemon? searchedPokemon;

  late final PagingController<int, Pokemon> _pagingController =
      PagingController(
    getNextPageKey: (state) {
      if (state.lastPageIsEmpty) return null;
      return state.pages?.expand((page) => page).length ?? 0;
    },
    fetchPage: (pageKey) {
      return PokemonService.fetchPokemons(pageKey, pageSize);
    },
  );

  Future<void> searchPokemon() async {
    final name = _searchController.text.trim().toLowerCase();
    if (name.isEmpty) return;

    try {
      final pokemon = await PokemonService.fetchPokemonByName(name);
      setState(() => searchedPokemon = pokemon);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pokémon no encontrado')),
      );
    }
  }

  void showAllPokemons() {
    setState(() {
      searchedPokemon = null;
      _searchController.clear();
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  String getTypes(Pokemon pokemon) {
    return pokemon.types.map((e) => e['type']['name']).join(' • ');
  }

  String getAbilities(Pokemon pokemon) {
    return pokemon.abilities.map((e) => e['ability']['name']).join(' • ');
  }

  Color getPokemonColor(Pokemon pokemon) {
    if (pokemon.types.isEmpty) return const Color(0xFFD68C8C);

    final type = pokemon.types.first['type']['name'];

    switch (type) {
      case 'fire':
        return const Color(0xFFEFA59B);
      case 'water':
        return const Color(0xFF8DB6D9);
      case 'grass':
        return const Color(0xFFA8CFA0);
      case 'electric':
        return const Color(0xFFE8CF75);
      case 'psychic':
        return const Color(0xFFD99ABC);
      case 'ice':
        return const Color(0xFFA8DADC);
      case 'dragon':
        return const Color(0xFFB6A4D9);
      case 'dark':
        return const Color(0xFF9B9B9B);
      case 'fairy':
        return const Color(0xFFE6A8C7);
      case 'poison':
        return const Color(0xFFC4A1D9);
      case 'ground':
        return const Color(0xFFD8B384);
      case 'rock':
        return const Color(0xFFC1A78E);
      case 'bug':
        return const Color(0xFFB8CF8F);
      case 'ghost':
        return const Color(0xFFA69ACD);
      case 'steel':
        return const Color(0xFFAEBBC1);
      case 'fighting':
        return const Color(0xFFD99A8C);
      case 'flying':
        return const Color(0xFF9FC5E8);
      default:
        return const Color(0xFFD68C8C);
    }
  }

  Widget statBox(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.65),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          FittedBox(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF3A3232),
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF7D6E6E),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPokemonCard(Pokemon pokemon) {
    final color = getPokemonColor(pokemon);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = MediaQuery.of(context).size.width;
        final isSmall = width < 380;
        final isTablet = width >= 700;

        final maxWidth = isTablet ? 620.0 : double.infinity;
        final imageHeight = isSmall ? 130.0 : isTablet ? 220.0 : 170.0;
        final titleSize = isSmall ? 22.0 : isTablet ? 32.0 : 27.0;

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: isSmall ? 12 : 18,
                vertical: 11,
              ),
              padding: EdgeInsets.all(isSmall ? 15 : 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.78),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: color.withOpacity(0.28)),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.18),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.22),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          '#${pokemon.id}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF3A3232),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.favorite_rounded,
                        color: color,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  FittedBox(
                    child: Text(
                      pokemon.name.toUpperCase(),
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: titleSize,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                        color: const Color(0xFF2F2929),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    getTypes(pokemon).toUpperCase(),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w700,
                      fontSize: isSmall ? 12 : 13,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    height: imageHeight,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: Image.network(
                      pokemon.image,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.image_not_supported,
                          color: color,
                          size: 70,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    crossAxisCount: isSmall ? 1 : 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: isSmall ? 4.5 : 1.35,
                    children: [
                      statBox('Altura', '${pokemon.height}', Icons.height, color),
                      statBox('Peso', '${pokemon.weight}', Icons.monitor_weight, color),
                      statBox('EXP', '${pokemon.baseExperience}', Icons.flash_on, color),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F1F1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Habilidades',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: color,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          getAbilities(pokemon),
                          style: const TextStyle(
                            color: Color(0xFF5F5454),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = MediaQuery.of(context).size.width;
        final isSmall = width < 380;
        final isTablet = width >= 700;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
            isSmall ? 16 : isTablet ? 40 : 20,
            isSmall ? 42 : 55,
            isSmall ? 16 : isTablet ? 40 : 20,
            24,
          ),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFF6D8D8),
                Color(0xFFEBDDD1),
                Color(0xFFF7F3EF),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(34),
              bottomRight: Radius.circular(34),
            ),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    child: Text(
                      'Pokédex Alessia',
                      style: TextStyle(
                        color: const Color(0xFF3A3232),
                        fontSize: isSmall ? 29 : isTablet ? 42 : 35,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Encuentra tus Pokémon favoritos',
                    style: TextStyle(
                      color: Color(0xFF7D6E6E),
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Buscar por nombre...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        onPressed: searchPokemon,
                        icon: const Icon(Icons.arrow_forward_rounded),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.85),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => searchPokemon(),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton.icon(
                      onPressed: showAllPokemons,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Mostrar todos'),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFD68C8C),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildEmptyState(String text) {
    return Center(
      child: Text(
        text,
        style: const TextStyle(color: Color(0xFF7D6E6E)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3EF),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            buildHeader(),
            Expanded(
              child: searchedPokemon != null
                  ? ListView(
                      padding: const EdgeInsets.only(top: 12, bottom: 25),
                      children: [
                        buildPokemonCard(searchedPokemon!),
                      ],
                    )
                  : PagingListener(
                      controller: _pagingController,
                      builder: (context, state, fetchNextPage) {
                        return PagedListView<int, Pokemon>(
                          padding: const EdgeInsets.only(top: 12, bottom: 25),
                          state: state,
                          fetchNextPage: fetchNextPage,
                          builderDelegate:
                              PagedChildBuilderDelegate<Pokemon>(
                            itemBuilder: (context, pokemon, index) {
                              return buildPokemonCard(pokemon);
                            },
                            firstPageProgressIndicatorBuilder: (_) =>
                                const Center(
                              child: CircularProgressIndicator(),
                            ),
                            newPageProgressIndicatorBuilder: (_) =>
                                const Padding(
                              padding: EdgeInsets.all(18),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            firstPageErrorIndicatorBuilder: (_) =>
                                buildEmptyState(
                              'No se pudieron cargar los Pokémon',
                            ),
                            noItemsFoundIndicatorBuilder: (_) =>
                                buildEmptyState(
                              'No hay Pokémon disponibles',
                            ),
                          ),
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