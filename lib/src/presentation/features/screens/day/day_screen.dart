import 'package:beamer/beamer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/src/domain/entities/date.dart';
import 'package:task_manager/src/presentation/base/cubit/cubit_state.dart';
import 'package:task_manager/src/presentation/features/screens/day/day_cubit.dart';
import 'package:task_manager/src/presentation/features/screens/home/home_screen.dart';
import 'package:task_manager/src/presentation/features/utils/logger.dart';
import 'package:task_manager/src/presentation/features/widgets/text_field_widget.dart';

class DayScreen extends StatefulWidget {
  const DayScreen({Key? key}) : super(key: key);

  static const screenName = '/day';

  @override
  State<DayScreen> createState() => _DayScreenState();
}

class _DayScreenState extends CubitState<DayScreen, DayState, DayCubit> {
  final TextEditingController _titleController = TextEditingController();
  final ValueKey _titleTextFieldKey = const ValueKey('titleTextFieldKey');
  final TextEditingController _descriptionController = TextEditingController();
  final ValueKey _descriptionTextFieldKey =
      const ValueKey('descriptionTextFieldKey');
  final _formKey = GlobalKey<FormState>();

  final logger = getLogger('DayScreen');

  @override
  void initParams(BuildContext context) {
    super.initParams(context);
    final state = cubit(context).state;

    final date =
        Beamer.of(context).currentBeamLocation.data as Map<String, dynamic>;
    cubit(context).getDate(Date.fromMap(date));

    _titleController
      ..text = state.task.title
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _titleController.text.length))
      ..addListener(() {
        cubit(context).onTitleChanged(_titleController.text);
      });
    _descriptionController
      ..text = state.task.description
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _descriptionController.text.length))
      ..addListener(() {
        cubit(context).onDescriptionChanged(_descriptionController.text);
      });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  @override
  Widget buildWidget(BuildContext context) {
    return observeState(
      builder: (context, state) => Scaffold(
        appBar: _appBar(state),
        body: observeState(builder: (context, state) => _buildHomeBody()),
      ),
    );
  }

  Widget _buildHomeBody() {
    return observeState(
      builder: (context, state) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: state.currentDate.tasks.length,
                  itemBuilder: (context, index) =>
                      _buildTaskDescription(index: index)),
              _buildFormTask(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar(DayState state) {
    return AppBar(
      centerTitle: true,
      title: Text(
        DateFormat.yMMMMEEEEd().format(state.currentDate.dateTime!),
        style: const TextStyle(fontSize: 18),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_outlined),
        onPressed: () => Beamer.of(context).beamToNamed(HomeScreen.screenName),
      ),
    );
  }

  Widget _buildTaskDescription({required int index}) {
    return observeState(
      builder: (context, state) => Dismissible(
        key: Key(state.currentDate.tasks.elementAt(index).title),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.currentDate.tasks.elementAt(index).title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  state.currentDate.tasks.elementAt(index).description,
                  style: const TextStyle(
                      fontWeight: FontWeight.w300, fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  DateFormat.Hm()
                      .format(state.currentDate.tasks.elementAt(index).time!),
                  style: const TextStyle(
                      fontWeight: FontWeight.w300, fontSize: 24),
                )
              ],
            ),
          ),
        ),
        onDismissed: (direction) => cubit(context).removeTask(index),
      ),
    );
  }

  Widget _buildFormTask() {
    return observeState(
      builder: (context, state) => Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFieldWidget(
                    key: _titleTextFieldKey,
                    controller: _titleController,
                    title: true),
                TextFieldWidget(
                    key: _descriptionTextFieldKey,
                    controller: _descriptionController,
                    title: false),
                const SizedBox(height: 15),
                GestureDetector(
                  child: Text(
                    DateFormat.Hm().format(state.task.time!),
                    style: const TextStyle(
                        fontWeight: FontWeight.w300, fontSize: 24),
                  ),
                  onTap: () => _showDialog(state,
                      onTimeChanged: (DateTime date) =>
                          cubit(context).onTimeChanged(date)),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        cubit(context).addTask();
                        _titleController.clear();
                        _descriptionController.clear();
                      }
                    },
                    child: const Text('Save')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _showDialog(DayState state,
      {required Function(DateTime) onTimeChanged}) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
        content: SizedBox(
          height: 100,
          child: CupertinoDatePicker(
              use24hFormat: true,
              mode: CupertinoDatePickerMode.time,
              minuteInterval: 30,
              initialDateTime: state.task.time,
              onDateTimeChanged: (val) => onTimeChanged(val)),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close"),
            ),
          )
        ],
      ),
    );
  }
}
