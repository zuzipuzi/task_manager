part of 'home_cubit.dart';

class HomeState extends Equatable {
  const HomeState(
      {this.firstDate,
      this.lastDate,
      this.initialDate,
      this.months = const [],
      this.currentMonthIndex = 0,
      this.currentMonth = const [],
      this.loading = false});

  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? initialDate;
  final List<List<Date>> months;
  final int currentMonthIndex;
  final List<Date> currentMonth;
  final bool loading;

  HomeState copyWith({
    DateTime? firstDate,
    DateTime? lastDate,
    DateTime? initialDate,
    List<List<Date>>? months,
    int? currentMonthIndex,
    List<Date>? currentMonth,
    bool? loading,
  }) {
    return HomeState(
      firstDate: firstDate ?? this.firstDate,
      lastDate: lastDate ?? this.lastDate,
      initialDate: initialDate ?? this.initialDate,
      months: months ?? this.months,
      currentMonthIndex: currentMonthIndex ?? this.currentMonthIndex,
      currentMonth: currentMonth ?? this.currentMonth,
      loading: loading ?? this.loading,
    );
  }

  @override
  List<Object?> get props => [
        firstDate,
        lastDate,
        initialDate,
        months,
        currentMonthIndex,
        currentMonth,
        loading,
      ];
}
