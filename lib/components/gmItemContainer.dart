import 'package:flutter/material.dart';
import 'package:GradeManager/components/Math.dart';

class gmItemContainer extends StatefulWidget {
  final int rounding;
  final String itemName;
  final IconData icon;
  final dynamic grade;
  final Map<dynamic, dynamic> parent;
  final VoidCallback rewrapParent;
  final Widget child;
  final Function removeItemFunc;


  gmItemContainer({required this.itemName, required this.grade, required this.icon, required this.child, required this.parent, required this.rewrapParent, required this.removeItemFunc, required this.rounding});

  @override
  _gmItemContainerState createState() => _gmItemContainerState();
}

class _gmItemContainerState extends State<gmItemContainer> {

  Color _color = Colors.white;
  bool _showDelete = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => {
          Navigator.push(context, MaterialPageRoute(builder: (context) => widget.child))
        },
        onLongPressStart: (details) {
          setState(() {
            _color = Colors.red;
            _showDelete = true;
          });
        },
        onLongPressEnd: (details) {
          setState(() {
            _color = Colors.white;
            _showDelete = false;
          });
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                alignment: Alignment.center,
                title: Text("Delete ${widget.itemName}?", textAlign: TextAlign.center),
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                  ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 20, 30, 48)),
                      ),
                      icon: const Icon(Icons.cancel),
                      label: const Text("Cancel")
                  ),
                  ElevatedButton.icon(
                      onPressed: () {
                        final snackbar = widget.removeItemFunc(widget.parent, widget.itemName);
                        if (snackbar!=null) {
                          ScaffoldMessenger.of(context).showSnackBar(snackbar);
                        }
                        widget.rewrapParent();
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                      ),
                      icon: const Icon(Icons.delete_forever),
                      label: const Text("Delete")
                  )
                ],
              )
          );
        },
        child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 60,
            margin: const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
            decoration: BoxDecoration(
              color: _color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: DefaultTextStyle(
              style: const TextStyle(fontSize: 15, color: Colors.black),
              child: _showDelete ?
              Row(children: const [Expanded(flex: 9, child: Text("Delete", textAlign: TextAlign.center))]) :
              Row(
                children: [
                  Expanded(flex: 1, child: Icon(widget.icon)),
                  Expanded(flex: 7, child: Text(widget.itemName)),
                  Expanded(flex: 1, child: Text(roundToDesired(widget.grade, widget.rounding).toStringAsFixed(2))),
                ],
              ),
            )
        )
    );
  }
}