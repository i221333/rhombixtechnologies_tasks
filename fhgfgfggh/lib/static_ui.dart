import 'package:fhgfgfggh/image_ui.dart';
import 'package:flutter/material.dart';
class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                Container(
                    padding: EdgeInsets.fromLTRB(14, 14, 14, 14),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(30)
                    ),
                    child: Icon(Icons.list))
              ],
            ),
            SizedBox(height: 16),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 55,
                  width: 130,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child: Text("Women", style: TextStyle(fontSize: 20),),
                ),
                Container(
                  height: 55,
                  width: 110,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child: Text("Men", style: TextStyle(fontSize: 20)),
                ),
                Container(
                  height: 55,
                  width: 110,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child: Text("Kids", style: TextStyle(fontSize: 20)),
                )
              ],
            ),
            SizedBox(height: 16),

            Container(
              alignment: Alignment.center,
              height: 65,
              width: 380,
              decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(30)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SecondPage()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(30)
                      ),
                      child: Icon(Icons.card_giftcard),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(child: Text("Gift Cards")),
                  Icon(Icons.arrow_forward_ios),
                  SizedBox(
                    width: 15,
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),

            Container(
              alignment: Alignment.center,
              height: 65,
              width: 380,
              decoration: BoxDecoration(
                  color: Colors.grey[400],
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
                    child: Icon(Icons.shopify),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(child: Text("Essential Shop winger Edition")),
                  Icon(Icons.arrow_forward_ios),
                  SizedBox(
                    width: 15,
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),

            Container(
              alignment: Alignment.center,
              height: 65,
              width: 380,
              decoration: BoxDecoration(
                  color: Colors.grey[400],
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
                    child: Icon(Icons.new_releases),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(child: Text("New In")),
                  Icon(Icons.arrow_forward_ios),
                  SizedBox(
                    width: 15,
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),

            Container(
              alignment: Alignment.center,
              height: 65,
              width: 380,
              decoration: BoxDecoration(
                  color: Colors.grey[400],
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
                    child: Icon(Icons.trending_up),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(child: Text("Trends")),
                  Icon(Icons.arrow_forward_ios),
                  SizedBox(
                    width: 15,
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),

            Container(
              alignment: Alignment.center,
              height: 65,
              width: 380,
              decoration: BoxDecoration(
                  color: Colors.grey[400],
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
                    child: Icon(Icons.shield_sharp),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(child: Text("Clothing")),
                  Icon(Icons.arrow_forward_ios),
                  SizedBox(
                    width: 15,
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),

            Container(
              alignment: Alignment.center,
              height: 65,
              width: 380,
              decoration: BoxDecoration(
                  color: Colors.grey[400],
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
                    child: Icon(Icons.card_giftcard),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(child: Text("Shoes")),
                  Icon(Icons.arrow_forward_ios),
                  SizedBox(
                    width: 15,
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),

            Container(
              alignment: Alignment.center,
              height: 65,
              width: 380,
              decoration: BoxDecoration(
                  color: Colors.grey[400],
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
                    child: Icon(Icons.running_with_errors),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(child: Text("Sports")),
                  Icon(Icons.arrow_forward_ios),
                  SizedBox(
                    width: 15,
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),

            Container(
              alignment: Alignment.center,
              height: 65,
              width: 380,
              decoration: BoxDecoration(
                  color: Colors.grey[400],
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
                    child: Icon(Icons.card_giftcard),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(child: Text("Streetwear")),
                  Icon(Icons.arrow_forward_ios),
                  SizedBox(
                    width: 15,
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),

            Container(
              alignment: Alignment.center,
              height: 65,
              width: 380,
              decoration: BoxDecoration(
                  color: Colors.grey[400],
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
                    child: Icon(Icons.lock),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(child: Text("Accessories")),
                  Icon(Icons.arrow_forward_ios),
                  SizedBox(
                    width: 15,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
