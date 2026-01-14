import 'package:fhgfgfggh/setstate_testing.dart';
import 'package:flutter/material.dart';

class ThirdPage extends StatelessWidget {
  ThirdPage({super.key});

  final List<String> text = <String>['Gift Cards', 'Essentials Shop Winger Edition', 'New In', 'Trends', 'Clothing', 'Shoes', 'Sports', 'Streetwear', 'Accessories'];
  final List<Icon> icons = <Icon>[Icon(Icons.card_giftcard), Icon(Icons.shopify), Icon(Icons.new_releases), Icon(Icons.trending_up), Icon(Icons.shield_sharp), Icon(Icons.card_giftcard), Icon(Icons.running_with_errors), Icon(Icons.card_giftcard), Icon(Icons.lock), Icon(Icons.arrow_forward_ios),  ];
  final List<String> category = <String>['Women', 'Men', 'Kids'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 35),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(10, 15, 120, 15),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child: Row(children: [
                    Icon(Icons.search),
                    SizedBox(width: 8),
                    Text("What are you looking for?"),
                  ],
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FourthPage()),
                    );
                  },
                  child: Container(
                      padding: EdgeInsets.fromLTRB(14, 14, 14, 14),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(30)
                      ),
                      child: Icon(Icons.list)),
                )
              ],
            ),
            SizedBox(height: 16),
            
            SizedBox(
              height: 55,
              child:
                ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: category.length,
                  itemBuilder: (BuildContext context, int index){
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                      child: Container(
                        height: 50,
                        width: (index == 0) ? 135 : 110,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        decoration: BoxDecoration(
                            color: index == 0 ? Colors.orange : Colors.white,
                            border: index == 0 ? Border.all(color: Colors.orange) : Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(30)
                        ),
                        child: Text(category[index], style: TextStyle(fontSize: 20),),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) => SizedBox(width: 0,),
                )
            ),
            SizedBox(height: 16),

            Expanded(
              child: ListView.separated(
                itemCount: text.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Container(
                      alignment: Alignment.center,
                      height: 65,
                      width: 380,
                      decoration: BoxDecoration(
                          color: index == 0 ? Colors.orange : Colors.grey[400],
                        borderRadius: BorderRadius.circular(30)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                          width: 15,
                        ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(30)
                            ),
                            child: icons[index],
                          ),
                          SizedBox(
                          width: 20,
                        ),
                          Expanded(child: Text(text[index])),
                          icons[icons.length - 1],
                          SizedBox(
                          width: 15,
                        ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) => SizedBox(height: 12,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}