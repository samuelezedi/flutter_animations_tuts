import 'package:flutter/material.dart';

class SamAnimations extends StatefulWidget {
  Widget child;
  double begin;
  double end;
  Duration duration;
  Curve curve;
  bool _shake = false;
  bool _fade = false;
  bool _scale = false;
  bool _rotate = false;
  ShakeType shakeType;
  Color fadeBegin;
  Color fadeEnd;
  bool repeat = false;
  Function(bool x) listener;
  Function(AnimationStatus x) listenerStatus;
  Function(AnimationController) controller;
  Widget Function(BuildContext x, Animation xx) builder;

  SamAnimations.shake(
      {this.child,
      this.begin,
      this.end,
      this.duration,
      this.repeat,
      this.listener,
      this.shakeType})
      : this._shake = true,
        assert(shakeType != null),
        assert(duration != null),
        assert(child != null);

  SamAnimations.fade(
      {this.fadeBegin, this.fadeEnd, this.repeat, this.duration, this.builder})
      : this._fade = true,
        assert(builder != null),
        assert(duration != null);

  SamAnimations.scale(
      {this.begin, this.end, this.repeat, this.duration, this.builder})
      : this._scale = true,
        assert(builder != null),
        assert(duration != null);

  SamAnimations.rotate(
      {this.begin, this.end, this.repeat, this.duration, this.child})
      : this._rotate = true,
        assert(child != null),
        assert(duration != null);

  @override
  _SamAnimationsState createState() => _SamAnimationsState();
}

class _SamAnimationsState extends State<SamAnimations>
    with SingleTickerProviderStateMixin {
  Animation<double> _shakeAnimation;
  Animation<Color> _fadeAnimation;
  AnimationController _animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: widget.duration);
    if (widget._shake) {
      _shakeAnimation = Tween<double>(begin: widget.begin, end: widget.end)
          .animate(_animationController);
      _shakeAnimation.addListener(() {
        setState(() {
          // widget.listener(true);
          // widget.controller(_animationController);
        });
      });
      _shakeAnimation.addStatusListener((status) {
        // widget.listenerStatus(status);
        if (widget.repeat) {
          if (status == AnimationStatus.completed) {
            _animationController.reverse();
          } else if (status == AnimationStatus.dismissed) {
            _animationController.forward();
          }
        }
      });
      _animationController.forward();
    }

    if (widget._fade) {
      _fadeAnimation = ColorTween(begin: widget.fadeBegin, end: widget.fadeEnd)
          .animate(_animationController);
      _fadeAnimation.addListener(() {
        setState(() {
          // widget.listener(true);
          // widget.controller(_animationController);
        });
      });
      _fadeAnimation.addStatusListener((status) {
        // widget.listenerStatus(status);
        if (widget.repeat) {
          if (status == AnimationStatus.completed) {
            _animationController.reverse();
          } else if (status == AnimationStatus.dismissed) {
            _animationController.forward();
          }
        }
      });
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget._shake) {
      return Transform.translate(
        offset: Offset(
            widget.shakeType == ShakeType.Horizonatally
                ? _shakeAnimation.value
                : 0.0,
            widget.shakeType == ShakeType.Vertically
                ? _shakeAnimation.value
                : 0.0),
        child: widget.child,
      );
    } else if (widget._fade) {
      return Builder(
        builder: (context) {
          return widget.builder(context, _fadeAnimation);
        },
      );
    }
  }
}

enum ShakeType { Horizonatally, Vertically }
