import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

typedef LikeCallback<T> = void Function(T item);
typedef IsLikedCallback<T> = bool Function(T item);
typedef IdCallback<T> = int Function(T item);

class LikeButton<T> extends StatelessWidget {
  final T item;
  final IsLikedCallback<T> isLiked;
  final IdCallback<T> getId;
  final LikeCallback<T> onLike;
  final LikeCallback<T> onUnlike;

  const LikeButton({
    super.key,
    required this.item,
    required this.isLiked,
    required this.getId,
    required this.onLike,
    required this.onUnlike,
  });

  @override
  Widget build(BuildContext context) {
    final liked = isLiked(item);
    final id = getId(item);

    return GestureDetector(
      onTap: () {
        if (liked) {
          onUnlike(item);
        } else {
          onLike(item);
        }
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) => ScaleTransition(
          scale: animation,
          child: child,
        ),
        child: liked
            ? SvgPicture.asset(
          "assets/icons/heart_filled.svg",
          key: ValueKey('liked_$id'),
          width: 18,
          height: 18,
          colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),
        )
            : SvgPicture.asset(
          "assets/icons/heart.svg",
          key: ValueKey('unliked_$id'),
          width: 18,
          height: 18,
          colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
        ),
      ),
    );
  }
}
