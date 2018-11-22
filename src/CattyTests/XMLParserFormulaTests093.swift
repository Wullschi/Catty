/**
 *  Copyright (C) 2010-2018 The Catrobat Team
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

import XCTest

@testable import Pocket_Code

class XMLParserFormulaTests093: XMLAbstractTest {
    var parserContext: CBXMLParserContext = CBXMLParserContext(languageVersion: CGFloat(Float32(0.93)))
    var formulaManager: FormulaManager = FormulaManager()
    
    override func setUp( ) {
        Util.activateTestMode(true)
    }
    
    func testValidFormulaList() {
        let document = self.getXMLDocumentForPath(xmlPath: self.getPathForXML(xmlFile: "ValidFormulaList"))
        let xmlElement = document.rootElement()
        var brickElement = Array<Any>()
        do {
            try brickElement = (xmlElement?.nodes(forXPath: "//program/objectList/object[1]/scriptList/script[1]/brickList/brick[2]"))!
        } catch let error as NSError {
            print("Error: \(error.domain)")
            XCTFail()
        }
        XCTAssertEqual(brickElement.count, 1)
        
        
        let brickXMLElement = brickElement.first as! GDataXMLElement
        let brick = self.parserContext.parse(from: brickXMLElement, withClass: SetVariableBrick.self) as! Brick
        
        XCTAssertTrue(brick.brickType == kBrickType.setVariableBrick, "Invalid brick type")
        XCTAssertTrue(brick.isKind(of: SetVariableBrick.self), "Invalid brick class")

        let setVariableBrick = brick as! SetVariableBrick;

        XCTAssertTrue(setVariableBrick.userVariable.name == "random from", "Invalid user variable name")

        let formula = setVariableBrick.variableFormula;
        // formula value should be: (1 * (-2)) + (3 / 4) = -1,25
        XCTAssertEqual(self.formulaManager.interpretDouble(formula!, for: SpriteObject()), -1.25, accuracy: 0.00001, "Formula not correctly parsed")
    }
    
    
}