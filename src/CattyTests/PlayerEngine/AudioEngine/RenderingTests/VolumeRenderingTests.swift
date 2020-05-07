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

class VolumeRenderingTests: AudioEngineRenderingTests {

    var player1: AKPlayer!
    var player2: AKPlayer!
    var player3: AKPlayer!
    var player4: AKPlayer!

    override func setUp() {
        super.setUp()

        audioEngine.playSound(fileName: "sine_low.wav", key: "Background", filePath: "egal", expectation: nil)
        audioEngine.playSound(fileName: "kontrabass_jazz.wav", key: "Background", filePath: "egal", expectation: nil)
        audioEngine.playSound(fileName: "bling_short.wav", key: "Object1", filePath: "egal", expectation: nil)
        audioEngine.playSound(fileName: "piano_jazz.wav", key: "Object1", filePath: "egal", expectation: nil)

        expect(self.audioEngine.subtrees.count).toEventually(be(2))
        expect(self.audioEngine.subtrees["Background"]?.audioPlayerCache.getKeySet().count) == 2
        expect(self.audioEngine.subtrees["Object1"]?.audioPlayerCache.getKeySet().count) == 2

        player1 = self.audioEngine.subtrees["Background"]!.audioPlayerCache.object(forKey: "sine_low.wav")!.akPlayer
        player2 = self.audioEngine.subtrees["Background"]!.audioPlayerCache.object(forKey: "kontrabass_jazz.wav")!.akPlayer
        player3 = self.audioEngine.subtrees["Object1"]!.audioPlayerCache.object(forKey: "bling_short.wav")!.akPlayer
        player4 = self.audioEngine.subtrees["Object1"]!.audioPlayerCache.object(forKey: "piano_jazz.wav")!.akPlayer
    }

    public func testSetVolumeToExpectOnlyPlayersOfObject1ToChangeVolume() {
        let referenceHash = "5ab7a3d6071769f5309e2a6b474f94b2"
        let renderDuration = 3.0

        audioEngine.setVolumeTo(percent: 40.0, key: "Background")
        let hash = audioEngine.renderToFile(tape, duration: renderDuration) {
            let dspTime = AVAudioTime(sampleTime: AVAudioFramePosition(0.0 * AKSettings.sampleRate), atRate: AKSettings.sampleRate)
            let dspTime1 = AVAudioTime(sampleTime: AVAudioFramePosition(0.4 * AKSettings.sampleRate), atRate: AKSettings.sampleRate)
            let dspTime2 = AVAudioTime(sampleTime: AVAudioFramePosition(0.6 * AKSettings.sampleRate), atRate: AKSettings.sampleRate)
            let dspTime3 = AVAudioTime(sampleTime: AVAudioFramePosition(0.8 * AKSettings.sampleRate), atRate: AKSettings.sampleRate)
            self.player1.play(at: dspTime)
            self.player2.play(at: dspTime1)
            self.player3.play(at: dspTime2)
            self.player4.play(at: dspTime3)
        }

        //playRenderedTape(tape: tape, duration: renderDuration)
        //let tapeHash = getTapeHash()

        expect(hash) == referenceHash
    }

    public func testChangeVolumeByExpectOnlyPlayersOfObject1ToChangeVolume() {
        let referenceHash = "5ab7a3d6071769f5309e2a6b474f94b2"
        let renderDuration = 2.0

        audioEngine.changeVolumeBy(percent: -60.0, key: "Background")
        let hash = audioEngine.renderToFile(tape, duration: renderDuration) {
            let dspTime = AVAudioTime(sampleTime: AVAudioFramePosition(0.0 * AKSettings.sampleRate), atRate: AKSettings.sampleRate)
            let dspTime1 = AVAudioTime(sampleTime: AVAudioFramePosition(0.4 * AKSettings.sampleRate), atRate: AKSettings.sampleRate)
            let dspTime2 = AVAudioTime(sampleTime: AVAudioFramePosition(0.6 * AKSettings.sampleRate), atRate: AKSettings.sampleRate)
            let dspTime3 = AVAudioTime(sampleTime: AVAudioFramePosition(0.8 * AKSettings.sampleRate), atRate: AKSettings.sampleRate)
            self.player1.play(at: dspTime)
            self.player2.play(at: dspTime1)
            self.player3.play(at: dspTime2)
            self.player4.play(at: dspTime3)
        }

        //playRenderedTape(tape: tape, duration: renderDuration)
        //let tapeHash = getTapeHash()

        expect(hash) == referenceHash

    }
}
