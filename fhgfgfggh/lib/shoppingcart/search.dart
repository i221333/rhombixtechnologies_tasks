import 'package:provider/provider.dart';
import 'package:fhgfgfggh/shoppingcart/cartprovider.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> filteredItems = [];

  @override
  Widget build(BuildContext context) {
    final allItems = context.watch<AppState>().categoryItems.values.expand((list) => list).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Search'),),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SearchBar(
                controller: _controller,
                hintText: 'Search items...',
                onTapOutside: (PointerDownEvent event) {
                  FocusScope.of(context).unfocus();
                },
                onChanged: (query) {
                  setState(() {
                    filteredItems = allItems.where((item) =>
                        item['name'].toLowerCase().contains(query.toLowerCase())
                    ).toList();
                  });
                },
                trailing: const [Icon(Icons.search)],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: filteredItems.isEmpty
                    ? const Center(child: Text("No results found"))
                    : ListView.separated(
                  itemCount: filteredItems.length,
                  separatorBuilder: (context, index) => Divider(color: Colors.grey[400]),
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.asset('assets/${item['image']}', fit: BoxFit.contain),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                                Text(item['extras']['selected'], style: const TextStyle(color: Colors.grey)),
                                Text('\$${item['cost'].toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
