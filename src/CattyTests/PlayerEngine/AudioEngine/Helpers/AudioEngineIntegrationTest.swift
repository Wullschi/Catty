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
import XCTest

@testable import Pocket_Code

class AudioEngineIntegrationTest: XMLAbstractTest {

    var tape: AKAudioFile!
    var audioEngine: AudioEngineMock!
    var recorder: AKNodeRecorder!

    override func setUp() {
        super.setUp()
        do {
            tape = try AKAudioFile()
            audioEngine = AudioEngineMock()
            recorder = audioEngine.addNodeRecorderAtMainOut(tape: tape)

        } catch {
            XCTFail("Could not initialize audio file occured")
        }
    }

    override func tearDown() {
        super.tearDown()
        audioEngine.shutdown()
    }

    func runAndRecord(duration: Int, scene: CBScene) {
        do {
            try recorder.record()
            _ = scene.startProject()
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 3))
            recorder.stop()
        } catch {
            XCTFail("Error occured")
        }
    }

    func calculateSimilarity(tape: AKAudioFile, referenceHash: String) -> Double {
        print("The recorded \(recorder.recordedDuration) Seconds")

        let readTape: AKAudioFile
        do {
            readTape = try AKAudioFile(forReading: tape.url)
        } catch {
            print("Could not read audio file")
            return 0
        }

        guard let (simHashString, duration) = generateFingerprint(fromSongAtUrl: readTape.url) else {
            print("No fingerprint was generated")
            return 0
        }

        print("The song duration is \(duration)")
        print("The binary fingerprint is: \(simHashString)")

        let currentSimHash = Array(simHashString).map({ Int(String($0))! })
        let referenceSimHash = Array(referenceHash).map({ Int(String($0))! })

        if referenceSimHash.count != currentSimHash.count {
            return 0
        }

        var matchingDigits = 0
        for i in 0..<referenceSimHash.count {
            if referenceSimHash[i] == currentSimHash[i] {
                matchingDigits += 1
            }
        }

        let similarity: Double = matchingDigits / referenceSimHash.count
        print("The similarity is \(similarity)")

        return similarity
    }

    func createScene(xmlFile: String) -> CBScene {
        let project = self.getProjectForXML(xmlFile: xmlFile)
        let sceneBuilder = SceneBuilder(project: project).withFormulaManager(formulaManager: FormulaManager(sceneSize: Util.screenSize(true))).withAudioEngine(audioEngine: audioEngine)
        return sceneBuilder.build()
    }
}

class AudioEngineMock: AudioEngine {
    var recorder: AKNodeRecorder?
    var tape: AKAudioFile?

    override internal func createNewAudioSubtree(key: String) -> AudioSubtree {
        let subtree = AudioSubtree(audioPlayerFactory: FingerprintingAudioPlayerFactory())
        subtree.setup(mainOut: mainOut)
        subtrees[key] = subtree
        return subtree
    }

    func addNodeRecorderAtMainOut(tape: AKAudioFile) -> AKNodeRecorder {
        do {
            recorder = try AKNodeRecorder(node: mainOut, file: tape)
        } catch {
            print("Should not happen")
        }

        return recorder!
    }
}
