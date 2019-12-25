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

        audioEngine.playSound(fileName: "guitar_chords.mp3", key: "Background", filePath: "egal", expectation: nil)
        audioEngine.playSound(fileName: "bling_short.mp3", key: "Background", filePath: "egal", expectation: nil)
        audioEngine.playSound(fileName: "kontrabass_jazz.mp3", key: "Object1", filePath: "egal", expectation: nil)
        audioEngine.playSound(fileName: "piano_jazz.mp3", key: "Object1", filePath: "egal", expectation: nil)

        expect(self.audioEngine.subtrees.count).toEventually(be(2))
        expect(self.audioEngine.subtrees["Background"]?.audioPlayerCache.getKeySet().count) == 2
        expect(self.audioEngine.subtrees["Object1"]?.audioPlayerCache.getKeySet().count) == 2

        player1 = self.audioEngine.subtrees["Background"]!.audioPlayerCache.object(forKey: "guitar_chords.mp3")!.akPlayer
        player2 = self.audioEngine.subtrees["Background"]!.audioPlayerCache.object(forKey: "bling_short.mp3")!.akPlayer
        player3 = self.audioEngine.subtrees["Object1"]!.audioPlayerCache.object(forKey: "kontrabass_jazz.mp3")!.akPlayer
        player4 = self.audioEngine.subtrees["Object1"]!.audioPlayerCache.object(forKey: "piano_jazz.mp3")!.akPlayer
    }

    public func testSetVolumeToExpectOnlyPlayersOfObject1ToChangeVolume() {
        let referenceHash = "2895a0f3f1e84f972852a146eaad3cf4"
        let renderDuration = 2.0

        audioEngine.setVolumeTo(percent: 40.0, key: "Object1")
        audioEngine.renderToFile(tape, duration: renderDuration) {
            self.player1.play()
            self.player2.play()
            self.player3.play()
            self.player4.play()
        }

        playRenderedTape(tape: tape, duration: renderDuration)
        let tapeHash = getTapeHash()

        expect(tapeHash) == referenceHash
    }

    public func testChangeVolumeByExpectOnlyPlayersOfObject1ToChangeVolume() {
        let referenceHash = "2895a0f3f1e84f972852a146eaad3cf4"
        let renderDuration = 2.0

        audioEngine.changeVolumeBy(percent: -60.0, key: "Object1")
        audioEngine.renderToFile(tape, duration: renderDuration) {
            self.player1.play()
            self.player2.play()
            self.player3.play()
            self.player4.play()
        }

        playRenderedTape(tape: tape, duration: renderDuration)
        let tapeHash = getTapeHash()

        expect(tapeHash) == referenceHash
    }
}
