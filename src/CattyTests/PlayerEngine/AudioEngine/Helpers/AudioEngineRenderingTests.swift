/**
 *  Copyright (C) 2010-2019 The Catrobat Team
 *  (http://developer.catrobat.org/credits)
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Affero General Public License as
 *  published by the Free Software Foundation, either version 3 of the
 *  License, or (at your option) any later version.
 *
 *  An additional term exception under section 7 of the GNU Affero
 *  General Public License, version 3, is available at
 *  (http://developer.catrobat.org/license_additional_term)
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *  GNU Affero General Public License for more details.
 *
 *  You should have received a copy of the GNU Affero General Public License
 *  along with this program.  If not, see http://www.gnu.org/licenses/.
 */

import AudioKit
import CryptoSwift
import Nimble
import XCTest

@testable import Pocket_Code

class AudioEngineRenderingTest: XCTestCase {

    var tape: AKAudioFile!
    var audioEngine: AudioEngine!
    var recorder: AKNodeRecorder!

    override func setUp() {
        super.setUp()

        do {
            tape = try AKAudioFile()
            audioEngine = AudioEngine(audioPlayerFactory: RenderingAudioPlayerFactory())
            audioEngine.postProcessingMixer.volume = 1
            audioEngine.start()
            audioEngine.playSound(fileName: "guitar_chords.mp3", key: "Background", filePath: "egal", expectation: nil)
            audioEngine.playSound(fileName: "bling_short.mp3", key: "Background", filePath: "egal", expectation: nil)
            expect(self.audioEngine.subtrees.count).toEventually(be(1))
        } catch {
            XCTFail("Could not set up audio engine integration test")
        }
    }

    override func tearDown() {
        super.tearDown()
        audioEngine.stop()
    }

    public func test1() {
        do {
            let akPlayer1 = self.audioEngine.subtrees["Background"]!.audioPlayerCache.object(forKey: "guitar_chords.mp3")?.akPlayer
            let akPlayer2 = self.audioEngine.subtrees["Background"]!.audioPlayerCache.object(forKey: "bling_short.mp3")?.akPlayer

            audioEngine.renderToFile(tape, duration: 2) {
                let dspTime = AVAudioTime(sampleTime: AVAudioFramePosition(1.96 * AKSettings.sampleRate), atRate: AKSettings.sampleRate)
                akPlayer2?.play(at: dspTime)
                akPlayer1?.play()
            }

            audioEngine.stop()
            let readTape = try AKAudioFile(forReading: tape.url)
            let player2 = try? AVAudioPlayer(contentsOf: tape.url)
            player2?.play()
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 4))

            let hashString = getHashString(tape: readTape)
            print("The hash is \(hashString)")

        } catch {
            print("error")
        }
    }

    private func getHashString(tape: AKAudioFile) -> String {
        let totalFloatCount = Int(tape.pcmBuffer.frameCapacity * tape.pcmBuffer.format.streamDescription.pointee.mBytesPerFrame / 4)

        let data1 = Data(buffer: UnsafeBufferPointer(start: tape.pcmBuffer.floatChannelData![0], count: totalFloatCount)).bytes
        let data2 = Data(buffer: UnsafeBufferPointer(start: tape.pcmBuffer.floatChannelData![1], count: totalFloatCount)).bytes

        var digest = MD5()
        _ = try? digest.update(withBytes: data1)
        _ = try? digest.update(withBytes: data2)

        let result = try? digest.finish()
        return result!.toHexString()
    }
}
