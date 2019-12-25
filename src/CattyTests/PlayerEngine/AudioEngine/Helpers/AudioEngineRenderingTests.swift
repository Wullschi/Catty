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

class AudioEngineRenderingTests: XCTestCase {

    var tape: AKAudioFile!
    var audioEngine: AudioEngine!

    override func setUp() {
        super.setUp()

        tape = try? AKAudioFile()
        audioEngine = AudioEngine(audioPlayerFactory: RenderingAudioPlayerFactory())
        audioEngine.postProcessingMixer.volume = 1
        audioEngine.start()
    }

    override func tearDown() {
        super.tearDown()
        audioEngine.stop()
    }

    public func getTapeHash() -> String {
        let readTape = try? AKAudioFile(forReading: tape.url)
        let totalFloatCount = Int(readTape!.pcmBuffer.frameCapacity * readTape!.pcmBuffer.format.streamDescription.pointee.mBytesPerFrame / 4)
        let data1 = Data(buffer: UnsafeBufferPointer(start: readTape!.pcmBuffer.floatChannelData![0], count: totalFloatCount)).bytes
        let data2 = Data(buffer: UnsafeBufferPointer(start: readTape!.pcmBuffer.floatChannelData![1], count: totalFloatCount)).bytes

        var digest = MD5()
        _ = try? digest.update(withBytes: data1)
        _ = try? digest.update(withBytes: data2)
        let hashArray = try? digest.finish()
        let tapeHash = hashArray!.toHexString()
        print("The hash is \(tapeHash)")

        return tapeHash
    }

    public func playRenderedTape(tape: AKAudioFile, duration: Double) {
        let tapePlayer = try? AVAudioPlayer(contentsOf: tape.url)
        tapePlayer!.play()
        RunLoop.current.run(until: Date(timeIntervalSinceNow: duration + 0.5))
    }
}
