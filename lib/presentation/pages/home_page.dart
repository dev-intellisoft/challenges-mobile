import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taski/presentation/viewmodels/task_viewmodel.dart';
import 'package:taski/presentation/widgets/task_list.dart';
import 'package:taski/presentation/widgets/add_task_bottom_sheet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskViewModel>().loadTasks();
    });
  }

  void _onItemTapped(int index) {
    if (index == 1) { // Create tab
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => const AddTaskBottomSheet(),
      );
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
    if (index == 3) { // Done tab
      context.read<TaskViewModel>().loadCompletedTasks();
    }
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(80),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Taski',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            const Text(
              'John',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey[300],
              child: const Icon(Icons.person),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeText() {
    final tasks = context.watch<TaskViewModel>().tasks;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.displayLarge,
              children: const [
                TextSpan(text: 'Welcome, '),
                TextSpan(
                  text: 'John',
                  style: TextStyle(color: Color(0xFF0066FF)),
                ),
                TextSpan(text: '.'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            tasks.isEmpty
                ? 'Create tasks to achieve more.'
                : "You've got ${tasks.length} tasks to do.",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeText(),
          Expanded(
            child: _selectedIndex == 3
                ? const TaskList(isCompleted: true)
                : const TaskList(isCompleted: false),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        height: 60,
        selectedIndex: _selectedIndex == 1 ? 0 : _selectedIndex,
        onDestinationSelected: _onItemTapped,
        backgroundColor: Colors.white,
        indicatorColor: Colors.transparent,
        destinations: [
          NavigationDestination(
            icon: Icon(
              Icons.view_list_outlined,
              color: _selectedIndex == 0
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
            label: 'Todo',
          ),
          NavigationDestination(
            icon: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade400,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                Icons.add,
                color: Colors.grey.shade400,
                size: 16,
              ),
            ),
            label: 'Create',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.search_outlined,
              color: _selectedIndex == 2
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.check_box_outlined,
              color: _selectedIndex == 3
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
            label: 'Done',
          ),
        ],
      ),
    );
  }
} 