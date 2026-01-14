import 'package:provider/provider.dart';
import 'package:fhgfgfggh/shoppingcart/cartprovider.dart';
import 'package:flutter/material.dart';

class Itemdetails extends StatefulWidget {
  late dynamic item;

  Itemdetails({super.key, required this.item});

  @override
  State<Itemdetails> createState() => _ItemdetailsState();
}

class _ItemdetailsState extends State<Itemdetails> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isFav = appState.isFavourite(widget.item);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color:Colors.grey[300],
                      borderRadius: BorderRadius.circular(10)
                  ),
                  height: 350,
                  width: double.infinity,
                  child: Image.asset("assets/${widget.item['image']}", fit: BoxFit.contain,)
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30)
                          ),
                          child: IconButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              icon: Padding(
                              padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                              child: Icon(Icons.arrow_back_ios),
                          )
                          )
                      ),
                    ),
                    SizedBox(width: 220,),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                                borderRadius: BorderRadius.circular(30)
                            ),
                            child: IconButton(onPressed: (){
                              context.read<AppState>().toggleFavourite(widget.item);
                              ScaffoldMessenger.of(context).showSnackBar(
                                !isFav? SnackBar(content: Text('${widget.item['name']} added to favourites'))
                                    : SnackBar(content: Text('${widget.item['name']} removed from favourites'))
                              );
                            }, icon: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border,
                                color: isFav ? Colors.red : Colors.grey[700],
                                ),
                            ))
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                          borderRadius: BorderRadius.circular(30)
                        ),
                        child: IconButton(onPressed: (){}, icon: Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                          child: Icon(Icons.download),
                        ))
                      )
                    ),
                  ],
                ),
              ]
            ),
            Row(
              children: [
                Expanded(child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Text(widget.item['name'], style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                )),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                      child: Row(
                        children: [
                          Icon(Icons.percent, color: Colors.white, size: 20,),
                          Text(" OnSale", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(25.0, 0.0, 0.0, 0.0),
                  child:
                  Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(30)
                      ),
                      child:
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18.0),
                          child: Row(
                            children: [
                              Image(image: AssetImage('assets/star.png'), height: 18,),
                              Text("  ${widget.item['rating']}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                            ]
                          ),
                        )
                  )
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                  child:
                  Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(30)
                      ),
                      child:
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18.0),
                          child: Row(
                            children: [
                              Icon(Icons.thumb_up, color: Colors.green,),
                              Text("  ${widget.item['rating']}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                            ]
                          ),
                        )
                  )
                ),
                SizedBox(width: 10,),
                Text("100 reviews", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),)
              ],
            ),
            Expanded(
              flex: 50,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: SingleChildScrollView(child: Text('${widget.item['description']}', style: TextStyle(fontSize: 16),)),
              ),
            ),
            Spacer(),
            DefaultTabController(
              initialIndex: widget.item['extras']['options'].indexOf(widget.item['extras']['selected']),
              animationDuration: Duration.zero,
              length: widget.item['extras']['options'].length,
              child: TabBar(
                onTap: (index){
                  setState(() {
                    widget.item['extras']['selected'] = widget.item['extras']['options'][index];
                    widget.item['cost'] = widget.item['extras']['costs'][index];
                  });
                },
                padding: EdgeInsets.only(left: 15, bottom: 25),
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
                tabs: List.generate(widget.item['extras']['options'].length, (index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black87),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(widget.item['extras']['options'][index]),
                  );
                }),
              ),
            ),
            Column(
              children: [
                Divider(
                  color: Colors.grey[300], // Line color
                  thickness: 1,       // Line thickness
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("\$${widget.item['cost']}", style: TextStyle(color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold, decoration: TextDecoration.lineThrough, decorationStyle: TextDecorationStyle.solid, decorationColor: Colors.grey, decorationThickness: 2.0)),
                        Text("\$${applyDiscount()}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,)),
                      ],
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0), // Change your radius here
                        ),backgroundColor: Colors.green, foregroundColor: Colors.white),
                        onPressed: (){
                          // Create a fresh item copy with the current selected option
                          final currentItem = deepCopyItem(widget.item);
                          context.read<AppState>().addToCart(currentItem);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${widget.item['name']} added to cart')),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40),
                          child: Text("Add to Cart", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                        )
                    )
                  ],
                ),
                SizedBox(height: 10,)
              ],
            )
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> deepCopyItem(Map<String, dynamic> item) {
    return {
      'name': item['name'],
      'description': item['description'],
      'cost': item['cost'],
      'rating': item['rating'],
      'image': item['image'],
      'count': item['count'] ?? 1,
      'extras': {
        'options': List<String>.from(item['extras']['options']),
        'selected': item['extras']['selected'],
      }
    };
  }

  double applyDiscount(){
    double discount = 0.40;
    return double.parse((widget.item['cost'] * (1 - discount)).toStringAsFixed(2));
  }
}
