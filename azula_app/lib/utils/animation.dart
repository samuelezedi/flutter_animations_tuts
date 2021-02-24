
import 'package:flutter/material.dart';

class SamAnimations extends StatefulWidget {
  Widget child;
  double begin;
  double end;
  Duration duration;
  Curve curve;
  bool _shake = false;
  bool repeat = false;
  Function(bool x) listener;
  Function (AnimationStatus x) listenerStatus;
  Function (AnimationController ) controller;

  SamAnimations.shake({this.child, this.begin, this.end, this.duration, this.repeat, this.listener}) : this._shake = true, assert(child!=null);


  @override
  _SamAnimationsState createState() => _SamAnimationsState();
}

class _SamAnimationsState extends State<SamAnimations> with SingleTickerProviderStateMixin {

  Animation<double> _shakeAnimation;
  AnimationController _animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(vsync: this, duration: widget.duration);
    if(widget._shake){
      _shakeAnimation = Tween<double>(begin: widget.begin, end: widget.end).animate(_animationController);
      _shakeAnimation.addListener(() {
        setState(() {
          // widget.listener(true);
          // widget.controller(_animationController);
        });
      });
      _shakeAnimation.addStatusListener((status) {
        // widget.listenerStatus(status);
        if(status == AnimationStatus.completed){
          _animationController.reverse();
        } else if(status == AnimationStatus.dismissed){
          _animationController.forward();
        }
      });

      _animationController.forward();
    }

  }
  @override
  Widget build(BuildContext context) {
    return Transform.translate(offset: Offset(
      _shakeAnimation.value,
      0.0
    ),child: widget.child,);
  }
}
