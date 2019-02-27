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

@objc extension PlayNoteBrick: CBInstructionProtocol {

    @nonobjc func instruction(audioEngine: AudioEngine) -> CBInstruction {

        guard let object = self.script?.object else { fatalError("This should never happen!") }

        return CBInstruction.execClosure { context, _ in
            var speakText = "Sorry, this is not a speak brick."
            if Double(speakText) != nil {
                let num = (speakText as NSString).doubleValue
                speakText = (num as NSNumber).stringValue
            }

            let utterance = AVSpeechUtterance(string: speakText)
            utterance.rate = (floor(NSFoundationVersionNumber) < 1200 ? 0.15 : 0.5)

            let synthesizer = AVSpeechSynthesizer()
            synthesizer.speak(utterance)
            context.state = .runnable
        }
    }
}