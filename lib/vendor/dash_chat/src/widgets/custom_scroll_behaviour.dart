part of dash_chat;

/// Custom scroll behaviour for the the [ChatView].
class CustomScrollBehaviour extends ScrollBehavior {
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
