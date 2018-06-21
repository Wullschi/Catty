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

final class DateWeekdaySensorMock: DateWeekdaySensor {
    var mockDate: Date = Date()
    
    override func date() -> Date {
        return mockDate
    }
}

final class DateWeekdaySensorTest: XCTestCase {
    
    var sensor: DateWeekdaySensorMock!
    
    override func setUp() {
        self.sensor = DateWeekdaySensorMock()
    }
    
    override func tearDown() {
        self.sensor = nil
    }
    
    func testTag() {
        XCTAssertEqual("DATE_WEEKDAY", type(of: sensor).tag)
    }
    
    func testRequiredResources() {
        XCTAssertEqual(ResourceType.noResources, type(of: sensor).requiredResource)
    }
    
    func testRawValue() {
        /* test Sunday */
        self.sensor.mockDate = Calendar.current.date(from: DateComponents(year: 2018, month: 6, day: 17, hour: 10))!
        XCTAssertEqual(1, Int(sensor.rawValue()))
        
        /* test Monday */
        self.sensor.mockDate = Calendar.current.date(from: DateComponents(year: 2018, month: 6, day: 18, hour: 10))!
        XCTAssertEqual(2, Int(sensor.rawValue()))
        
        /* test Tuesday */
        self.sensor.mockDate = Calendar.current.date(from: DateComponents(year: 2018, month: 6, day: 19, hour: 10))!
        XCTAssertEqual(3, Int(sensor.rawValue()))
        
        /* test Wednesday */
        self.sensor.mockDate = Calendar.current.date(from: DateComponents(year: 2018, month: 6, day: 20, hour: 10))!
        XCTAssertEqual(4, Int(sensor.rawValue()))
        
        /* test Thursday */
        self.sensor.mockDate = Calendar.current.date(from: DateComponents(year: 2018, month: 6, day: 21, hour: 10))!
        XCTAssertEqual(5, Int(sensor.rawValue()))
        
        /* test Friday */
        self.sensor.mockDate = Calendar.current.date(from: DateComponents(year: 2018, month: 6, day: 22, hour: 10))!
        XCTAssertEqual(6, Int(sensor.rawValue()))
        
        /* test Saturday */
        self.sensor.mockDate = Calendar.current.date(from: DateComponents(year: 2018, month: 6, day: 23, hour: 10))!
        XCTAssertEqual(7, Int(sensor.rawValue()))
        
        /* test edge case - almost the beginning of the next day - Tuesday */
        self.sensor.mockDate = Calendar.current.date(from: DateComponents(year: 2018, month: 6, day: 19, hour: 23))!
        XCTAssertEqual(3, Int(sensor.rawValue()))
    }
    
    func testStandardizedValue() {
        /* test Sunday */
        self.sensor.mockDate = Calendar.current.date(from: DateComponents(year: 2018, month: 6, day: 17, hour: 10))!
        XCTAssertEqual(7, Int(sensor.standardizedValue()))
        
        /* test Monday */
        self.sensor.mockDate = Calendar.current.date(from: DateComponents(year: 2018, month: 6, day: 18, hour: 10))!
        XCTAssertEqual(1, Int(sensor.standardizedValue()))
        
        /* test Tuesday */
        self.sensor.mockDate = Calendar.current.date(from: DateComponents(year: 2018, month: 6, day: 19, hour: 10))!
        XCTAssertEqual(2, Int(sensor.standardizedValue()))
        
        /* test Wednesday */
        self.sensor.mockDate = Calendar.current.date(from: DateComponents(year: 2018, month: 6, day: 20, hour: 10))!
        XCTAssertEqual(3, Int(sensor.standardizedValue()))
        
        /* test Thursday */
        self.sensor.mockDate = Calendar.current.date(from: DateComponents(year: 2018, month: 6, day: 21, hour: 10))!
        XCTAssertEqual(4, Int(sensor.standardizedValue()))
        
        /* test Friday */
        self.sensor.mockDate = Calendar.current.date(from: DateComponents(year: 2018, month: 6, day: 22, hour: 10))!
        XCTAssertEqual(5, Int(sensor.standardizedValue()))
        
        /* test Saturday */
        self.sensor.mockDate = Calendar.current.date(from: DateComponents(year: 2018, month: 6, day: 23, hour: 10))!
        XCTAssertEqual(6, Int(sensor.standardizedValue()))
        
        /* test edge case - almost the beginning of the next day - Tuesday */
        self.sensor.mockDate = Calendar.current.date(from: DateComponents(year: 2018, month: 6, day: 19, hour: 23))!
        XCTAssertEqual(2, Int(sensor.standardizedValue()))
    }
    
    func testShowInFormulaEditor() {
        XCTAssertTrue(sensor.showInFormulaEditor())
    }
}
