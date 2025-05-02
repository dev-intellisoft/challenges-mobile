import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:taski/data/models/task_model.dart';
import 'package:taski/presentation/viewmodels/task_viewmodel.dart';
import 'package:intl/intl.dart';
import 'package:taski/presentation/widgets/add_task_bottom_sheet.dart';

class TaskList extends StatefulWidget {
  final bool isCompleted;

  const TaskList({
    super.key,
    required this.isCompleted,
  });

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  final ScrollController _scrollController = ScrollController();
  bool isCardOpen = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (widget.isCompleted) {
        context.read<TaskViewModel>().loadCompletedTasks();
      } else {
        context.read<TaskViewModel>().loadTasks();
      }
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/icons/no_task_icon.svg'),

          const SizedBox(height: 16),
          Text(
            widget.isCompleted
                ? 'No completed tasks yet'
                : 'You have no task listed.',
            style: const TextStyle(
              fontSize: 16,
              color: Color.fromRGBO(141, 156, 184, 1)
            ),
          ),
          if (!widget.isCompleted) ...[
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) => const AddTaskBottomSheet(),
                );
              },
              child: Container(
                height: 50,
                width: 151,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(0, 127, 255, .1),
                  borderRadius: BorderRadius.circular(12)
                ),
                child: const Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, size: 20, color: Color.fromRGBO(0, 127, 255, 1), ),
                      SizedBox(width: 8),
                      Text('Create task', style: TextStyle(
                          color: Color.fromRGBO(0, 127, 255, 1),
                        fontWeight: FontWeight.w600,
                        fontSize: 18

                      ),),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskViewModel>(
      builder: (context, viewModel, child) {
        final tasks = widget.isCompleted
            ? viewModel.completedTasks
            : viewModel.tasks;

        if (tasks.isEmpty && !viewModel.isLoading) {
          return _buildEmptyState();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.isCompleted)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Completed Tasks',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO: Implement delete all completed tasks
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.error,
                      ),
                      child: const Text('Delete all'),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: tasks.length + (viewModel.isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == tasks.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  return TaskCard(
                    task: tasks[index],
                    isCompleted: widget.isCompleted,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final bool isCompleted;

  const TaskCard({
    super.key,
    required this.task,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isCompleted
        ? const Color(0xFF49454F).withOpacity(0.7)
        : const Color(0xFF1C1B1F);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  context.read<TaskViewModel>().toggleTaskCompletion(task);
                },
                child: isCompleted?SvgPicture.asset('assets/icons/done.svg'):SvgPicture.asset('assets/icons/unchecked.svg'),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromRGBO(63, 61, 86, 1),
                        decoration: isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    if (task.description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        task.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color.fromRGBO(141, 156, 184, 1),
                          fontWeight: FontWeight.w400,
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                icon: SvgPicture.asset('assets/icons/more.svg'),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.delete_outline, color: Colors.red),
                            title: const Text('Delete'),
                            onTap: () {
                              Navigator.pop(context);
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Delete Task'),
                                  content: const Text(
                                    'Are you sure you want to delete this task?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        context
                                            .read<TaskViewModel>()
                                            .deleteTask(task);
                                        Navigator.pop(context);
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.red,
                                      ),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
} 