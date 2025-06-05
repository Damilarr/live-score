import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LeagueMatches extends StatefulWidget {
  const LeagueMatches({super.key});
  @override
  State<LeagueMatches> createState() => _LeagueMatchesState();
}

class _LeagueMatchesState extends State<LeagueMatches> {
  DateTime selectedDate = DateTime.now();
  final List<DateTime> nextFiveDays = List.generate(
    5,
    (index) => DateTime.now().add(Duration(days: index)),
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Horizontal ListView for the next 5 days
          Expanded(
            child: SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: nextFiveDays.length,
                itemBuilder: (context, index) {
                  final date = nextFiveDays[index];
                  final isSelected =
                      selectedDate.day == date.day &&
                      selectedDate.month == date.month &&
                      selectedDate.year == date.year;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDate = date; // Update the selected date
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            DateFormat.E().format(
                              date,
                            ), // Day of the week (e.g., Sun)
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                          Text(
                            DateFormat.d().format(
                              date,
                            ), // Day of the month (e.g., 02)
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Calendar Icon for custom date selection
          GestureDetector(
            onTap: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );

              if (pickedDate != null) {
                setState(() {
                  selectedDate = pickedDate; // Update the selected date
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Icon(Icons.calendar_today, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
