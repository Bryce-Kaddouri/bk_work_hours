import 'package:flutter/material.dart';

class AnimateButton extends StatefulWidget {
  const AnimateButton({super.key});

  @override
  State<AnimateButton> createState() => _AnimateButtonState();
}

class _AnimateButtonState extends State<AnimateButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(
          seconds: 1,
        ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        primary: Colors.red,
        minimumSize: Size(100, 100),
        maximumSize: Size(200, 200),
      ),
      icon: AnimatedBuilder(
        child: const Icon(Icons.delete),
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          return Transform.rotate(
            angle: _controller.value * 2.0 * 3.1415,
            child: const Icon(Icons.delete),
          );
        },
      ),
      onPressed: () async {
        _controller.forward(
          from: 0.0,
        );
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Supprimer'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: 120,
                  ),
                  const Text('Voulez-vous supprimer cet événement ?'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                    );
                  },
                  child: const Text('Annuler'),
                ),
                TextButton(
                  onPressed: () async {},
                  child: const Text('Supprimer'),
                ),
              ],
            );
          },
        );

        // await ApiInit().deleteEvent(
        //     details.appointments![0].id);
        // Navigator.pop(
        //   context,
        // );
      },
      label: const Text('Supprimer'),
    );
  }
}
