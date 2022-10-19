//
//  AudioPlayer.swift
//  Restart
//
//  Created by Ezequiel Fritz on 19/10/22.
//

import Foundation
import AVFoundation

final class AudioPlayer {
    var audioPlayer: AVAudioPlayer?

    func playSound(sound: String, type: String) {
        if let path = Bundle.main.path(forResource: sound, ofType: type) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                audioPlayer?.play()
            } catch {
                print("Could not play the sound file.")
            }
        }
    }
}
