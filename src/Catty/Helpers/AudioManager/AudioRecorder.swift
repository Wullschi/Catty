//
//  AudioRecorder.swift
//  Catty
//
//  Created by Benjamin Wullschleger on 04.10.18.
//

import Foundation
import AudioKit

class AudioRecorder {
    init() {
    }
    
    static func getNewAudioRecorder(node: AKNode) -> AKAudioFile? {
        // Create file URL
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let filePath = documents + "/recorded1"
        let fileURL = URL(fileURLWithPath: filePath)
        
        FileManager.default.createFile(atPath: fileURL.path, contents: nil, attributes: nil)
        
        // Create AKAudioFile
        let format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: 48000, channels: 2, interleaved: true)
        let file : AKAudioFile
        
        do {
            try file = AKAudioFile(forWriting: fileURL, settings: format!.settings)
//            let recorder1 = try AKNodeRecorder(node: node)
//            return recorder1
        } catch {
            return nil
        }
        
        return file
    }
}
