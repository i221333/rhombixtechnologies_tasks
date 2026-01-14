import 'package:provider/provider.dart';
import 'package:fhgfgfggh/todolist/todolistprovider.dart';
import 'package:flutter/material.dart';

class Todolist extends StatefulWidget {
  const Todolist({super.key});

  @override
  State<Todolist> createState() => _TodolistState();
}

class _TodolistState extends State<Todolist> with SingleTickerProviderStateMixin{
  late TabController tabController;
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> filteredItems = [];
  String searchQuery = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final appState = Provider.of<AppState>(context, listen: false);
    tabController = TabController(length: appState.category.length, vsync: this);
    appState.reloadTasks();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: null,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    return pickedDate;
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    final category = appState.category;

    return Scaffold(
      appBar: AppBar(title: Center(child: Text('To Do List')),),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue[900]),
              child: Container(
                child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('To Do List', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),),
                      ]
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text(' Home '),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text(' Settings '),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('LogOut'),
            ),
          ],
        ),
      ),
      body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: SearchBar(
                  controller: _controller,
                  hintText: 'Search...',
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
              TabBar(
                padding: const EdgeInsets.only(left: 15),
                controller: tabController,
                tabAlignment: TabAlignment.start,
                dividerColor: Colors.transparent,
                isScrollable: true,
                indicator: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
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
                flex: 50,
                child: TabBarView(
                  controller: tabController,
                  children: category.map((cat) {
                    final List<Map<String, dynamic>> categoryItems;
                    if (searchQuery != '') {
                      categoryItems = filteredItems;
                    } else {
                      categoryItems = context.read<AppState>().categoryItems.values.expand((e) => e).toList();
                    }

                    final items = cat == 'All'
                        ? categoryItems
                        : categoryItems.where((item) => item['category'] == cat).toList();

                    print('Testing');
                    print(items.length);
                    return ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return Dismissible(
                            key: ValueKey(item['id']),
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            secondaryBackground: Container(
                              color: Colors.yellow,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: const Icon(Icons.edit, color: Colors.white),
                            ),
                            confirmDismiss: (direction) async {
                                if (direction == DismissDirection.endToStart) {
                                  DateTime? selectedDate;
                                  final TextEditingController nameController = TextEditingController();
                                  String? dropdownValue;

                                  await showDialog(
                                    context: context,
                                    builder: (context) => StatefulBuilder(
                                      builder: (context, setState) => AlertDialog(
                                        title: Text('Edit Task'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(15.0),
                                              child: TextField(
                                                controller: nameController,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                                  ),
                                                  labelText: 'Name',
                                                  labelStyle: TextStyle(
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                style: TextStyle(color: Colors.black87),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(15.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: OutlinedButton(
                                                      onPressed: () async {
                                                        final picked = await _selectDate(context);
                                                        if (picked != null) {
                                                          setState(() {
                                                            selectedDate = picked;
                                                          });
                                                        }
                                                      },
                                                      style: ButtonStyle(
                                                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(10.0),
                                                          ),
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(10.0),
                                                        child: Text(
                                                          selectedDate != null
                                                              ? selectedDate.toString().split(' ')[0]
                                                              : 'Date',
                                                          style: const TextStyle(
                                                            color: Colors.black87,
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Expanded(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                        border: Border.all(color: Colors.black54),
                                                      ),
                                                      child: DropdownButton<String>(
                                                        alignment: Alignment.center,
                                                        padding: EdgeInsets.only(right: 10.0),
                                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                                        icon: const Icon(Icons.arrow_drop_down),
                                                        hint: Padding(
                                                          padding: const EdgeInsets.all(9.0),
                                                          child: Text(
                                                            "Category",
                                                            style: TextStyle(color: Colors.black87),
                                                          ),
                                                        ),
                                                        value: dropdownValue,
                                                        items: category.map((String cat) {
                                                          return DropdownMenuItem<String>(
                                                            value: cat,
                                                            child: Text(
                                                              cat,
                                                              style: TextStyle(color: Colors.black),
                                                            ),
                                                          );
                                                        }).toList(),
                                                        onChanged: (String? newValue) {
                                                          setState(() {
                                                            dropdownValue = newValue!;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                style: TextButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(15),
                                                  ),
                                                  foregroundColor: Colors.black,
                                                  backgroundColor: Colors.white,
                                                ),
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 18),
                                                  child: Text('Cancel', style: TextStyle(fontSize: 18)),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  if (nameController.text != '' ||
                                                      selectedDate != null ||
                                                      dropdownValue != null) {
                                                    context.read<AppState>().updateTask(
                                                      Task.fromJson({
                                                        'id': item['id'],
                                                        'name': nameController.text.isNotEmpty
                                                            ? nameController.text
                                                            : item['name'],
                                                        'date': selectedDate != null
                                                            ? selectedDate.toString().split(' ')[0]
                                                            : item['date'],
                                                        'isChecked': item['isChecked'],
                                                        'category': dropdownValue != null
                                                            ? dropdownValue!
                                                            : item['category'],
                                                      }),
                                                    );
                                                    Navigator.pop(context);
                                                  } else {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) => AlertDialog(
                                                        content: Padding(
                                                          padding: const EdgeInsets.all(15.0),
                                                          child: Text(
                                                            'Error! missing field values',
                                                            style: TextStyle(
                                                                fontSize: 16, fontWeight: FontWeight.bold),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                                style: TextButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(15),
                                                  ),
                                                  foregroundColor: Colors.white,
                                                  backgroundColor: Colors.deepPurpleAccent,
                                                ),
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                                                  child: Text(
                                                    'Edit Task',
                                                    style: TextStyle(fontSize: 18),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                                else if(direction == DismissDirection.startToEnd)
                                  return true;
                                return null;
                                },
                            onDismissed: (direction) {
                              if (direction == DismissDirection.startToEnd) {
                                context.read<AppState>().deleteTask(Task.fromJson(item));
                              }
                            },
                            child: ListTile(
                              key: ValueKey(item['id']),
                              leading: Checkbox(
                                value: item['isChecked'] == 1,
                                onChanged: (bool? value) {
                                  context.read<AppState>().toggleCheck(Task.fromJson(item));
                                },
                              ),
                              title: Text(
                                item['name'],
                                style: TextStyle(
                                  decoration: item['isChecked'] == 1 ? TextDecoration.lineThrough : null,
                                ),
                              ),
                              subtitle: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${item['date']}'),
                                  Text('#${item['category']}'),
                                ],
                              ),
                            ),
                          );
                        },
                    );
                  }).toList(),
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(320.0, 0, 10, 20),
                child: FloatingActionButton(
                  backgroundColor: Colors.grey,
                  onPressed: (){},
                  child: IconButton(
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddTask()
                          ),
                        );
                      }, icon: Icon(Icons.add, color: Colors.white,)
                  ),
                ),
              )
            ],
          )
      ),
    );
  }
}

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  DateTime? selectedDate;
  late final TextEditingController nameController;
  late final TextEditingController categoryController;
  late String? dropdownValue;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    categoryController = TextEditingController();
    dropdownValue = null;
  }

  @override
  void dispose() {
    nameController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: null,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    setState(() {
      selectedDate = pickedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final category = appState.category;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: Column(
            children: [
              Text('Add Your Task', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                    labelText: 'Name',
                    labelStyle: TextStyle(
                      color: Colors.black87,
                    ),
                  ),
                  style: TextStyle(color: Colors.black87),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                          onPressed: () => _selectDate(context),
                          style:
                            ButtonStyle(
                              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Text(selectedDate != null? selectedDate.toString().split(' ')[0] : 'Select Date' , style: const TextStyle(color: Colors.black87, fontSize: 16),),
                          )),
                    ),
                    SizedBox(width: 20,),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          border: Border.all(color: Colors.black54),
                        ),
                        child: DropdownButton(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(right: 10.0),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          icon: const Icon(Icons.arrow_drop_down),
                          hint: Padding(
                            padding: const EdgeInsets.all(9.0),
                            child: Text("Select Category", style: TextStyle(color: Colors.black87),),
                          ),
                          value: dropdownValue,
                          items: category.map((String cat) {
                            return DropdownMenuItem<String>(
                              value: cat, // 👈 Fix here
                              child: Text(
                                cat,
                                style: TextStyle(color: Colors.black),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue = newValue!;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                  onPressed: (){
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Add Category'),
                          content: TextField(
                            controller: categoryController,
                            decoration: InputDecoration(
                              hintText: 'Enter category name',
                              labelStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: TextStyle(color: Colors.black87),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Close dialog
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                if(categoryController.text != '')
                                {
                                  //context.read<AppState>().addCategory(categoryController.text);
                                  Navigator.pop(context);
                                }
                                else {
                                  showDialog(context: context,
                                      builder: (context) => AlertDialog(
                                        content: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Text('Error! Category name missing', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                        ),
                                      )
                                  );
                                }
                              },
                              child: const Text('Add'),
                            ),
                          ],
                        ),
                      );
                      /*Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddTask()
                          ),
                        );*/
                    },
                  style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15), // 👈 Set your corner radius here
                      ),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.deepPurpleAccent
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18),
                    child: Text('Add Category',  style: TextStyle(fontSize: 16),),
                  )
              ),
              SizedBox(height: 50,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                      onPressed: (){
                          Navigator.pop(context);
                          },
                      style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15), // 👈 Set your corner radius here
                          ),
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 18),
                        child: Text('Cancel', style: TextStyle(fontSize: 18)),
                      )
                  ),
                  TextButton(
                      onPressed: (){
                          if(nameController.text != '' && selectedDate != null && dropdownValue != null)
                          {
                            context.read<AppState>().addTask(
                                Task.fromJson({
                                  'name': nameController.text,
                                  'date': selectedDate.toString().split(' ')[0],
                                  'isChecked': 0,
                                  'category': dropdownValue!,
                                })
                            );
                            Navigator.pop(context);
                          }
                          else {
                            showDialog(context: context,
                              builder: (context) => AlertDialog(
                                content: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text('Error! missing field values', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                ),
                              )
                            );
                          }
                      },
                      style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15), // 👈 Set your corner radius here
                          ),
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.deepPurpleAccent
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                        child: Text('Add Task', style: TextStyle(fontSize: 18),),
                      )
                  ),
                ],
              ),
            ],
          )
      ),
    );
  }
}

