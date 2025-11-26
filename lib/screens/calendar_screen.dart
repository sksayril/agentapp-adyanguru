import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  late ValueNotifier<List<Task>> _selectedTasks;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  // Sample tasks data
  final Map<DateTime, List<Task>> _tasks = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _selectedTasks = ValueNotifier(_getTasksForDay(_selectedDay));

    // Initialize sample tasks
    _initializeSampleTasks();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  void _initializeSampleTasks() {
    final today = DateTime.now();
    
    // Today's tasks
    _tasks[today] = [
      Task(
        title: 'Follow up with Lead #108',
        time: '10:00 AM',
        type: TaskType.followUp,
      ),
      Task(
        title: 'Client Meeting - John Doe',
        time: '2:00 PM',
        type: TaskType.meeting,
      ),
      Task(
        title: 'Review pending applications',
        time: '4:00 PM',
        type: TaskType.review,
      ),
    ];

    // Tomorrow's tasks
    final tomorrow = today.add(const Duration(days: 1));
    _tasks[tomorrow] = [
      Task(
        title: 'Complete documentation',
        time: '11:00 AM',
        type: TaskType.documentation,
      ),
      Task(
        title: 'Call client - Sarah',
        time: '3:00 PM',
        type: TaskType.call,
      ),
    ];

    // Day after tomorrow
    final dayAfter = today.add(const Duration(days: 2));
    _tasks[dayAfter] = [
      Task(
        title: 'Team meeting',
        time: '10:00 AM',
        type: TaskType.meeting,
      ),
    ];

    // Next week
    final nextWeek = today.add(const Duration(days: 7));
    _tasks[nextWeek] = [
      Task(
        title: 'Monthly review',
        time: '9:00 AM',
        type: TaskType.review,
      ),
    ];
  }

  List<Task> _getTasksForDay(DateTime day) {
    final dateKey = DateTime(day.year, day.month, day.day);
    return _tasks[dateKey] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      _selectedTasks.value = _getTasksForDay(selectedDay);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _selectedTasks.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Calendar',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Calendar Widget
                  _buildCalendar(),
                  const SizedBox(height: 30),
                  // Selected Date Header
                  _buildSelectedDateHeader(),
                  const SizedBox(height: 15),
                  // Tasks List
                  _buildTasksList(),
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TableCalendar<Task>(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        calendarFormat: _calendarFormat,
        eventLoader: _getTasksForDay,
        startingDayOfWeek: StartingDayOfWeek.monday,
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          weekendTextStyle: TextStyle(color: Colors.grey[600]),
          selectedDecoration: BoxDecoration(
            color: Colors.blue[600],
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: Colors.blue[100],
            shape: BoxShape.circle,
          ),
          markerDecoration: BoxDecoration(
            color: Colors.orange,
            shape: BoxShape.circle,
          ),
          markersMaxCount: 3,
          markerSize: 6,
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: true,
          titleCentered: true,
          formatButtonShowsNext: false,
          formatButtonDecoration: BoxDecoration(
            color: Colors.blue[600],
            borderRadius: BorderRadius.circular(8),
          ),
          formatButtonTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
          leftChevronIcon: Icon(Icons.chevron_left, color: Colors.blue[600]),
          rightChevronIcon: Icon(Icons.chevron_right, color: Colors.blue[600]),
        ),
        onDaySelected: _onDaySelected,
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
      ),
    );
  }

  Widget _buildSelectedDateHeader() {
    final dateStr = '${_selectedDay.day} ${_getMonthName(_selectedDay.month)} ${_selectedDay.year}';
    final isToday = isSameDay(_selectedDay, DateTime.now());
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isToday ? 'Today' : _getDayName(_selectedDay.weekday),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              dateStr,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(20),
          ),
          child: ValueListenableBuilder<List<Task>>(
            valueListenable: _selectedTasks,
            builder: (context, tasks, _) {
              return Text(
                '${tasks.length} ${tasks.length == 1 ? 'Task' : 'Tasks'}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[700],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTasksList() {
    return ValueListenableBuilder<List<Task>>(
      valueListenable: _selectedTasks,
      builder: (context, tasks, _) {
        if (tasks.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(
                  Icons.event_busy,
                  size: 60,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 15),
                Text(
                  'No tasks scheduled',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Tap on a date to add tasks',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: tasks.map((task) => _buildTaskItem(task)).toList(),
        );
      },
    );
  }

  Widget _buildTaskItem(Task task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _getTaskColor(task.type).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _getTaskIcon(task.type),
              color: _getTaskColor(task.type),
              size: 24,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      task.time,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey[400],
          ),
        ],
      ),
    );
  }

  Color _getTaskColor(TaskType type) {
    switch (type) {
      case TaskType.meeting:
        return Colors.blue;
      case TaskType.call:
        return Colors.green;
      case TaskType.followUp:
        return Colors.orange;
      case TaskType.review:
        return Colors.purple;
      case TaskType.documentation:
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  IconData _getTaskIcon(TaskType type) {
    switch (type) {
      case TaskType.meeting:
        return Icons.people;
      case TaskType.call:
        return Icons.phone;
      case TaskType.followUp:
        return Icons.trending_up;
      case TaskType.review:
        return Icons.description;
      case TaskType.documentation:
        return Icons.folder;
      default:
        return Icons.event;
    }
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }

  String _getDayName(int weekday) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return days[weekday - 1];
  }
}

class Task {
  final String title;
  final String time;
  final TaskType type;

  Task({
    required this.title,
    required this.time,
    required this.type,
  });
}

enum TaskType {
  meeting,
  call,
  followUp,
  review,
  documentation,
}
