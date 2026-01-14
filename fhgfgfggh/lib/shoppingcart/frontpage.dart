import 'package:fhgfgfggh/shoppingcart/itemdetails.dart';
import 'package:fhgfgfggh/shoppingcart/cartprovider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'cart.dart';

class Frontpage extends StatefulWidget {
  const Frontpage({super.key});

  @override
  State<Frontpage> createState() => _FrontpageState();
}

class _FrontpageState extends State<Frontpage> with SingleTickerProviderStateMixin{
  late TabController tabController;
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> filteredItems = [];
  String searchQuery = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 4, vsync: this, animationDuration: Duration.zero);
  }

  @override
  Widget build(BuildContext context) {

    final appState = context.watch<AppState>();

    final category = appState.category;
    final categoryItems = appState.categoryItems;

    return Scaffold(
      appBar: AppBar(
        title: Text("Discover"),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 10, 15.0, 0.0),
            child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(30)
                ),
                child: Stack(
                  children: [
                    IconButton(onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Cart()
                        ),
                      );
                    }, icon: Icon(Icons.shopping_bag_outlined)),
                    if(appState.cart.isNotEmpty)
                      Positioned(
                        left: 30,
                        top: -2,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            border: Border.all(color: Colors.green),
                            borderRadius: BorderRadius.circular(30)
                          ),
                          child: Center(child: Text(
                            '${appState.cartCount().toInt()}',
                            style: TextStyle(color: Colors.white),)),
                        ),
                      )
                  ],
                )
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 🔍 Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: SearchBar(
                controller: _controller,
                hintText: 'Search items...',
                onTapOutside: (PointerDownEvent event) {
                  FocusScope.of(context).unfocus();
                  },
                onChanged: (query) {
                  final allItems = context.read<AppState>().categoryItems.values.expand((e) => e).toList();
                  setState(() {
                    searchQuery = query;
                    filteredItems = allItems
                        .where((item) => item['name'].toLowerCase().contains(query.toLowerCase()))
                        .toList();
                  });
                },
                trailing: [
                  if (searchQuery.isNotEmpty)
                    IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          searchQuery = '';
                          _controller.clear();
                        });
                      },
                    ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.search),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            // 🧠 Conditional: Show Search Results or Main UI
            if (searchQuery.isNotEmpty)
            // 🔎 Search Results show here immediately
              Expanded(
                child: ListView.separated(
                  itemCount: filteredItems.length,
                  separatorBuilder: (context, index) => Divider(color: Colors.grey[400]),
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: Image.asset('assets/${item['image']}', width: 50),
                        title: Text(item['name']),
                        subtitle: Text('\$${item['cost']}'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Itemdetails(item: item)),
                          );
                        },
                      ),
                    );
                  },
                ),
              )
            else
            // 🎯 Main UI shown only if no search
              Expanded(
                child: Column(
                  children: [
                    // 🔋 Banner
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 370,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Clearance",
                                  style: TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold)),
                              Text("Sales",
                                  style: TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold)),
                              SizedBox(height: 15),
                              Container(
                                width: 150,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: const [
                                    Icon(Icons.percent, color: Colors.green, size: 20),
                                    Text(" Upto 50%", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Positioned(
                          left: 90,
                          bottom: 0,
                          child: Image(image: AssetImage('assets/iphone15promax.png'), height: 230),
                        ),
                      ],
                    ),

                    // 📂 Categories
                    Row(
                      children: const [
                        SizedBox(width: 20, height: 70),
                        Expanded(child: Text("Categories", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          child: Text("See all", style: TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),

                    // 🧭 Tabs
                    TabBar(
                      padding: const EdgeInsets.only(left: 15),
                      controller: tabController,
                      tabAlignment: TabAlignment.start,
                      dividerColor: Colors.transparent,
                      isScrollable: true,
                      indicator: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.green),
                      ),
                      labelPadding: const EdgeInsets.symmetric(horizontal: 5),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black,
                      tabs: List.generate(category.length, (index) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black87),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(category[index]),
                        );
                      }),
                    ),
                    const SizedBox(height: 15),
                    Expanded(
                      child: TabBarView(
                        controller: tabController,
                        children: category.map((cat) {
                          final items = cat == 'All'
                              ? categoryItems.values.expand((list) => list).toList()
                              : categoryItems[cat] ?? [];

                          return GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                            ),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Itemdetails(item: item)),
                                  );
                                },
                                child: GridTile(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          height: 180,
                                          width: 180,
                                          child: Image.asset("assets/${item['image']}"),
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(item['name'], style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                                            ),
                                            const Image(image: AssetImage('assets/star.png'), height: 13),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 12.0),
                                              child: Text(" ${item['rating']}", style: TextStyle(fontWeight: FontWeight.bold)),
                                            ),
                                          ],
                                        ),
                                        Text("\$${item['cost']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
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
