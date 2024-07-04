import 'package:flutter/material.dart';

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.black.withOpacity(0.35),
        ),
        Align(
          alignment: Alignment.center,
          child: FittedBox(
            fit: BoxFit.none,
            child: SizedBox(
              height: 100,
              width: 100,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: const Padding(
                  padding: EdgeInsets.all(25.0),
                  child: CircularProgressIndicator(
                    color: Colors.purple,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
