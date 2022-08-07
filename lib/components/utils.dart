class Utils {

  static String durationToMinutes(Duration duration) {
    var minutes = duration.inMinutes;
    return minutes < 10 ? "0$minutes" : "$minutes";
  }

  static String durationToRemainderSeconds(Duration duration) {
    int result = duration.inSeconds % 60;
    return result < 10 ? "0$result" : "$result";
  }

  static String appendZero(int item) {
    return item < 10 ? "0$item" : "$item";
  }
}