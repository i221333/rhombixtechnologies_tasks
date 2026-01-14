import 'package:fhgfgfggh/dynamic_ui.dart';
import 'package:flutter/material.dart';
class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image(image: AssetImage('assets/main.png')),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ThirdPage()),
                    );
                  },
                  child: Text('The Italian Place', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                )
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                child: Row(
                  children: [
                    Text('30-45 min • \$\$', style: TextStyle(color: Colors.grey, fontSize: 16),),
                    SizedBox(width: 10,),
                    Image(image: AssetImage('assets/star.png'), height: 15,),
                    Text(' (5.0)', style: TextStyle(color: Colors.grey))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                child: Row(
                  children: [
                    Expanded(child: Text('Appetizers', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                    Expanded(child: Text('Main Course', style: TextStyle(color: Colors.grey, fontSize: 18,))),
                    Expanded(child: Text('Desserts', style: TextStyle(color: Colors.grey, fontSize: 18,)))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Column(
                          children: [
                            Image(image: AssetImage('assets/calamari.png'), height: 90,),
                            Text('\$12.99', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        SizedBox(width: 15,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10,),
                            Text('Fried Calamari', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('Crispy calamari with', style: TextStyle(color: Colors.grey)),
                            Text('marinara sauce', style: TextStyle(color: Colors.grey))
                          ],
                        ),
                        SizedBox(width: 80),
                        Container(
                          height: 40,
                          width: 90,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.purple[50],
                              borderRadius: BorderRadius.circular(30)
                          ),
                          child: Text("Add", style: TextStyle(fontSize: 16),),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Column(
                          children: [
                            Image(image: AssetImage('assets/caprese.png'), height: 80,),
                            Text('\$10.99', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        SizedBox(width: 10,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 15,),
                            Text('Caprese Salad', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('Fresh mozzarella, tomatoes,', style: TextStyle(color: Colors.grey)),
                            Text('basil, balsamic glaze', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                        SizedBox(width: 30),
                        Container(
                          height: 40,
                          width: 90,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.purple[50],
                              borderRadius: BorderRadius.circular(30)
                          ),
                          child: Text("Add", style: TextStyle(fontSize: 16),),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Column(
                          children: [
                            Image(image: AssetImage('assets/bread.png'), height: 40,),
                            SizedBox(height: 0,),
                            Text('\$6.99', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        SizedBox(width: 5,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Garlic Bread', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('Garlic bread with melted', style: TextStyle(color: Colors.grey)),
                            Text('mozzarella cheese', style: TextStyle(color: Colors.grey))
                          ],
                        ),
                        SizedBox(width: 50),
                        Container(
                          height: 40,
                          width: 90,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.purple[50],
                              borderRadius: BorderRadius.circular(30)
                          ),
                          child: Text("Add", style: TextStyle(fontSize: 16),),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Column(
                          children: [
                            Image(image: AssetImage('assets/burger.png'), height: 60,),
                            SizedBox(height: 0,),
                            Text('\$9.99', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        SizedBox(width: 15,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Burger Barn', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('Wagyu beef burger with', style: TextStyle(color: Colors.grey)),
                            Text('american cheese and onions', style: TextStyle(color: Colors.grey))
                          ],
                        ),
                        SizedBox(width: 25),
                        Container(
                          height: 40,
                          width: 90,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.purple[50],
                              borderRadius: BorderRadius.circular(30)
                          ),
                          child: Text("Add", style: TextStyle(fontSize: 16),),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Column(
                          children: [
                            Image(image: AssetImage('assets/pasta.png'), height: 35,),
                            SizedBox(height: 15,),
                            Text('\$8.69', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        SizedBox(width: 15,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Pasta Paradise', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('Fettuccine pasta', style: TextStyle(color: Colors.grey)),
                            Text('customizable with choice of', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                        SizedBox(width: 25),
                        Container(
                          height: 40,
                          width: 90,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.purple[50],
                              borderRadius: BorderRadius.circular(30)
                          ),
                          child: Text("Add", style: TextStyle(fontSize: 16),),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
