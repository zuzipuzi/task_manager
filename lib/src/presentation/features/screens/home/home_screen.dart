import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/src/presentation/base/cubit/cubit_state.dart';
import 'package:task_manager/src/presentation/features/screens/day/day_screen.dart';
import 'package:task_manager/src/presentation/features/screens/home/home_cubit.dart';
import 'package:task_manager/src/presentation/features/utils/logger.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const screenName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends CubitState<HomeScreen, HomeState, HomeCubit> {
  late PageController pageController;

  final formatter = DateFormat('yyyy-MM-dd');

  final logger = getLogger('HomeScreen');

  @override
  void initParams(BuildContext context) {
    super.initParams(context);
    cubit(context).initParams().then((value) {
      pageController =
          PageController(initialPage: cubit(context).state.currentMonthIndex);
      cubit(context).getCurrentMonth(cubit(context).state.currentMonthIndex);
    });
  }

  @override
  Widget buildWidget(BuildContext context) {
    return observeState(
      builder: (context, state) => Scaffold(
        appBar: state.currentMonth.isEmpty ? AppBar() : _appBar(state),
        body: state.currentMonth.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        _daysOfTheWeek(),
                        const SizedBox(height: 10),
                        Divider(color: Colors.blue.shade100, thickness: 2),
                        const SizedBox(height: 10),
                        SizedBox(height: 595, child: _buildPageView()),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  PreferredSizeWidget _appBar(HomeState state) {
    final List<String> monthNames = [
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
      'December',
    ];
    return AppBar(
      centerTitle: true,
      title: Text(
        '${monthNames.elementAt(state.currentMonth.elementAt(7).dateTime!.month - 1)} ${state.currentMonth.elementAt(7).dateTime!.year}',
      ),
      leading: IconButton(
          onPressed: () {
            pageController.jumpToPage(state.currentMonthIndex - 1);
            cubit(context).onPageChanged(state.currentMonthIndex - 1);
          },
          icon: const Icon(Icons.arrow_back_outlined)),
      actions: [
        IconButton(
            onPressed: () {
              pageController.jumpToPage(state.currentMonthIndex + 1);
              cubit(context).onPageChanged(state.currentMonthIndex + 1);
            },
            icon: const Icon(Icons.arrow_forward)),
      ],
    );
  }

  Widget _daysOfTheWeek() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _text('Mon'),
        _text('Tue'),
        _text('Wed'),
        _text('Thu'),
        _text('Fri'),
        _text('Sat'),
        _text('Sun'),
      ],
    );
  }

  Widget _text(String day) {
    return Text(day, style: const TextStyle(fontWeight: FontWeight.w500));
  }

  Widget _buildPageView() {
    return observeState(
      builder: (context, state) => PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        itemCount: state.months.length,
        onPageChanged: (monthIndex) {
          cubit(context).getCurrentMonth(monthIndex);
        },
        itemBuilder: (context, monthIndex) {
          return state.currentMonth.isEmpty
              ? const CircularProgressIndicator()
              : _buildGridView();
        },
      ),
    );
  }

  Widget _buildGridView() {
    return observeState(
      builder: (context, state) => GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: state.currentMonth.length,
        shrinkWrap: true,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
        itemBuilder: (context, dayIndex) {
          final date = state.currentMonth.elementAt(dayIndex);
          return GestureDetector(
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: formatter.format(state.initialDate!) ==
                            formatter.format(date.dateTime!)
                        ? Colors.blue.shade100
                        : Colors.white,
                  ),
                  child: Center(
                    child: Text(
                      date.dateTime!.day.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: date.dateTime!.month ==
                                state.currentMonth.elementAt(7).dateTime!.month
                            ? Colors.black
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
                if (date.tasks.isNotEmpty)
                  Positioned(
                      right: 1,
                      bottom: 1,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          date.tasks.length.toString(),
                          style: const TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      )),
              ],
            ),
            onTap: () => Beamer.of(context)
                .beamToNamed(DayScreen.screenName, data: date.toMap()),
          );
        },
      ),
    );
  }
}
