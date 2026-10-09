import 'package:flutter/material.dart';

class TaskListScreen extends StatefulWidget {

  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState()=> _TaskListScreen();

}
  class _TaskListScreen extends State<TaskListScreen>{
    final List<String> filters = ["All", "On Track", "At Risk", "Overdue"];
    String selectedFilter = "All";

    @override
    Widget build(BuildContext context) {
      // Primary dark blue matching your palette
      const Color darkBlue = Color(0xFF1E4ED8);

      return Scaffold(
        backgroundColor: const Color(0xFFF8FAFC), // Light canvas background
        appBar: AppBar(
          backgroundColor: darkBlue,
          elevation: 0,
          centerTitle: true,
          // I think it is okay if we remove menu icon, I don't see its importance
          /*leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              // Can open a drawer or show navigation
            },
          )*/
          title: const Text(
            'Tasks',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          // 3. User Avatar
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: const Color(0xFF3B82F6), // Lighter blue accent
                child: const Text(
                  'JB',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        body:Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children:[
                  Expanded(
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color:Colors.white,
                        border:Border.all(color:const Color(0xFFE2E8F0)),
                        borderRadius:BorderRadius.circular(10),
                      ),
                      child: TextField(
                        decoration:InputDecoration(
                          border: InputBorder.none,
                          prefixIcon:Icon(Icons.search, color: Color(0xFF94A3B8)),
                          hintText: "Search tasks....",
                          hintStyle: TextStyle(color:Color(0xFF94A3B8), fontSize: 14,),
                          contentPadding: EdgeInsets.symmetric(vertical:12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 46, 
                    height:46,
                    decoration: BoxDecoration(
                        color:Colors.white,
                        border:Border.all(color:const Color(0xFFE2E8F0)),
                        borderRadius:BorderRadius.circular(10),
                      ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.tune,
                        color:Color(0xFF475569),
                        size:20,
                      ),
                      onPressed: ()=>{}
                      ),
                    ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: filters.map((filter) {
                  final bool isSelected = selectedFilter == filter;

                  return GestureDetector(
                    
                    onTap: () {
                      setState(() {
                        selectedFilter = filter;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF1E4ED8): Colors.white,
                        border: isSelected ? Border.all(color: Color(0xFF1E4ED8)): Border.all(color: Color(0xFFE2E8F0)),
                        borderRadius: BorderRadius.circular(15)
                      ),
                      child: isSelected? Text(filter, 
                      style: TextStyle(
                        color: Colors.white, 
                        fontWeight: FontWeight.w600,
                        fontSize: 14),) : Text(filter, style: TextStyle(color: Colors.black)),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        // Floating Action Button for task creation
        floatingActionButton: FloatingActionButton(
          backgroundColor: darkBlue,
          onPressed: () async {
            await Navigator.pushNamed(context, '/create-edit');
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
      );
    }

  }
