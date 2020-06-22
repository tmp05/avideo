import 'package:flutter/material.dart';

class MultiSelectChip extends StatefulWidget {
  final List<String> reportList;
  final List<String> selectedReportList;
  final Function(List<String>) onSelectionChanged;

  MultiSelectChip(this.reportList, this.selectedReportList, {this.onSelectionChanged});

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {

  List<String> selectedChoices=List();

  _buildChoiceList() {
    List<Widget> choices = List();
    widget.reportList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          selected: selectedChoices.contains(item),
          onSelected: (selected) {
            setState(() {
              selectedChoices.contains(item)
                  ? selectedChoices.remove(item)
                  : selectedChoices.add(item);
              widget.onSelectionChanged(selectedChoices);
            });
          },
        ),
      ));
    });

    return choices;
  }

  @override
  Widget build(BuildContext context) {
    if (selectedChoices.length==0) setState(() {
      selectedChoices = widget.selectedReportList.toList();
    });
    print('now we rebuild and have in selectedChoices items= '+selectedChoices.length.toString());
    print('now we rebuild and have in selectedReportList items= '+widget.selectedReportList.length.toString());
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}