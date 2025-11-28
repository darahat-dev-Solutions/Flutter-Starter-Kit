import 'package:ai_chat/core/utils/logger.dart';
import 'package:audioplayers/audioplayers.dart';

/// Perform Notification sound
class SoundService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AppLogger _appLogger = AppLogger();

  ///This function calling _audioPlayer for play sound
  Future<void> playNotificationSound() async {
    try {
      /// Play notification sound from assets/sounds folder
      await _audioPlayer.play(AssetSource('sounds/notification.mp3'));
    } catch (e) {
      _appLogger.error("Error Playing sound: $e");
    }
  }
}
