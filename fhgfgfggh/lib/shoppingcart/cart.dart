import 'package:provider/provider.dart';
import 'package:fhgfgfggh/shoppingcart/cartprovider.dart';
import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final cart = appState.cart;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 10),
          child: Container(
                width: 0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(30)
                ),
                child: Center(
                  child: SizedBox(
                    child: IconButton(
                      padding: EdgeInsets.zero,
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        icon: Center(child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Icon(Icons.arrow_back_ios),
                        )),
                    ),
                  ),
                )
            ),
        ),
        title: Center(
          child: Text('My Cart'),
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 15.0, 0.0),
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child: IconButton(onPressed: (){}, icon: Icon(Icons.more_horiz),)
              )
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              (cart.isEmpty)? Expanded(flex: 50, child: Center(child: Text('Your cart is empty')))
                  : Expanded(
                      flex: 50,
                      child: ListView.separated(
                  itemCount: cart.length,
                  separatorBuilder: (context, index) => Divider(color: Colors.grey[400], thickness: 1),
                  itemBuilder: (context, index) {
                    final item = cart[index];

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10)
                          ),
                          height: 120,
                          width: 120,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Image.asset('assets/${item['image']}', fit: BoxFit.contain),
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
                                      context.read<AppState>().removeFromCart(item);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('${item['name']} removed from cart')),
                                      );
                                    },
                                    icon: const Icon(Icons.close),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(child: Text('\$${item['cost'].toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold))),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(color: Colors.grey),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: IconButton(
                                            icon: const Text('—', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                            onPressed: () {
                                              context.read<AppState>().decrementCounter(index);
                                            }
                                          ),
                                        ),
                                      ),
                                      Text('${item['count']}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                      Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(color: Colors.grey),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: IconButton(
                                            icon: const Text('+', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400)),
                                            onPressed: () {
                                              context.read<AppState>().incrementCounter(index);
                                            }
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
                  ),
              Spacer(),
              Container(
                padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("ADJ3AK"),
                    Row(
                      children: [
                        Text("Promocode applied ", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),),
                        Icon(Icons.check_circle, color: Colors.green,),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Subtotal: '),
                  Text('\$${appState.subtotal()}'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Delivery Fee: '),
                  Text('\$5'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Discount: ',),
                  Text('40%',),
                ],
              ),
              Divider(
                color: Colors.grey[400], // Line color
                thickness: 1,       // Line thickness
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0), // Change your radius here
                  ),backgroundColor: Colors.green, foregroundColor: Colors.white),
                  onPressed: (){
                    if(cart.isNotEmpty) {
                      context.read<AppState>().clearCart();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Thank You for placing your order')),
                      );
                    }
                    else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Your cart is empty')),
                      );
                    }
                    },
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Check out for", style: TextStyle(fontSize: 20),),
                        Text(" \$${appState.total()}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      ],
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
