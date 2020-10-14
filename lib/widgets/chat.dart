import 'package:flutter/material.dart';

class Chat extends StatelessWidget {
  const Chat({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
            ),
            BoxShadow(
              color: Theme.of(context).canvasColor,
              spreadRadius: -2.0,
              blurRadius: 2.0,
            ),
          ],
          borderRadius: BorderRadius.circular(25),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Row(
                      children: [Text('Zirno : '), Text('Lets PLay')],
                    )
                  ],
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(const Radius.circular(35))),
                child: Container(
                  height: 40,
                  child: Row(
                    children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(),
                      )),
                      FittedBox(
                        fit: BoxFit.cover,
                        child: IconButton(
                          splashRadius: 20,
                          icon: Icon(
                            Icons.send,
                            color: Colors.red,
                          ),
                          onPressed: () {},
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
