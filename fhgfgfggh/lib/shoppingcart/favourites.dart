import 'package:provider/provider.dart';
import 'package:fhgfgfggh/shoppingcart/cartprovider.dart';
import 'package:flutter/material.dart';

import 'package:fhgfgfggh/shoppingcart/itemdetails.dart';

class Favourites extends StatefulWidget {
  const Favourites({super.key});

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final favourites = appState.favourites;

    return Scaffold(
      appBar: AppBar(
        title: Text('Favourites'),
      ),
      body: SafeArea(
          child: (favourites.isEmpty)? Expanded(flex: 50, child: Center(child: Text('You have no favourites'))) :
          ListView.separated(
              itemCount: favourites.length,
              separatorBuilder: (context, index) => Divider(color: Colors.grey[400], thickness: 1),
              itemBuilder: (context, index) {
                final item = favourites[index];

                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10)
                        ),
                        height: 80,
                        width: 80,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: GestureDetector(onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Itemdetails(item: item)),
                            );
                          },child: Image.asset('assets/${item['image']}', fit: BoxFit.contain)),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                                      Text(item['extras']['selected'], style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    context.read<AppState>().removeFromFavourite(item);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('${item['name']} removed from favourites')),
                                    );
                                  },
                                  icon: const Icon(Icons.close),
                                )
                              ],
                            ),
                            Text('\$${item['cost'].toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      ),
    );
  }
}
