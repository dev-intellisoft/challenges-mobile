import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:taski/presentation/viewmodels/task_viewmodel.dart';
import 'package:taski/presentation/widgets/task_list.dart';
import 'package:taski/data/models/task_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {
      _isSearching = value.isNotEmpty;
    });
    context.read<TaskViewModel>().searchTasks(value);
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF4FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          width: 2,
          color: Color.fromRGBO(0, 127, 255, .5),
        ),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Search a task...',
          hintStyle: const TextStyle(
            color: Color(0xFF49454F),
            fontSize: 16,
          ),
          prefixIcon: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SvgPicture.asset('assets/icons/blue_search.svg',),
          ),
          suffixIcon: _isSearching
              ? IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Color(0xFF49454F),
                  ),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _onSearchChanged('');
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/icons/no_task_icon.svg'),
          const SizedBox(height: 16),
          Text(
            'No result found.',
            style: TextStyle(
              color: Color.fromRGBO(141, 156, 184, 1)
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(List<TaskModel> results) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final task = results[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            title: Text(
              task.title,
              style: TextStyle(
                decoration:
                    task.isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: Text(task.description),
            leading: Icon(
              task.isCompleted
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
              color: task.isCompleted
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchBar(),
        if (_isSearching)
          Expanded(
            child: Consumer<TaskViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final results = viewModel.searchResults;
                if (results.isEmpty) {
                  return _buildEmptyState();
                }

                return _buildSearchResults(results);
              },
            ),
          ),
      ],
    );
  }
} 