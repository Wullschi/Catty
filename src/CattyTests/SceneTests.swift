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

import XCTest

@testable import Pocket_Code

final class SceneTests: XCTestCase {
    
    var screenSize: CGSize
    
    var pocketCodeCenter: CGPoint
    var pocketCodeBottomLeft: CGPoint
    var pocketCodeBottomRight: CGPoint
    var pocketCodeTopLeft: CGPoint
    var pocketCodeTopRight: CGPoint

    var sceneCenter: CGPoint
    var sceneBottomLeft: CGPoint
    var sceneBottomRight: CGPoint
    var sceneTopLeft: CGPoint
    var sceneTopRight: CGPoint
    
    override func setUp() {
        super.setUp()
        self.screenSize = Util.screenSize(false)
        
        self.pocketCodeCenter = CGPoint(x: 0, y: 0)
        self.pocketCodeBottomLeft = CGPoint(x: -240, y: -400)
        self.pocketCodeBottomRight = CGPoint(x: 240, y: -400)
        self.pocketCodeTopLeft = CGPoint(x: -240, y: 400)
        self.pocketCodeTopRight = CGPoint(x: 240, y: 400)
        
        self.sceneCenter = CGPoint(x: 240, y: 400)
        self.sceneBottomLeft = CGPoint(x: 0, y: 0)
        self.sceneBottomRight = CGPoint(x: 480, y: 0)
        self.sceneTopLeft = CGPoint(x: 0, y: 800)
        self.sceneTopRight = CGPoint(x: 480, y: 800)
    }
    
    func testTouchConversionCenter() {
        let scaledScene = SceneBuilderMock(project: ProjectMock(width: self.screenSize.width * 2, andHeight: self.screenSize.height * 2)).build()
        let scaledSceneCenter = CGPoint(x: self.screenSize.width/2, y: self.screenSize.height/2)
        let convertedCenter = CBSceneHelper.convertTouchCoordinateToPoint(coordinate: scaledSceneCenter, sceneSize: scaledScene.size)
        XCTAssertTrue(convertedCenter.equalTo(self.pocketCodeCenter), "The Scene Center is not correctly calculated")
    }
    
    func testTouchConversionCenterNoScale() {
        let scaledScene = SceneBuilderMock(project: ProjectMock(width: self.screenSize.width, andHeight: self.screenSize.height)).build()
        let scaledSceneCenter = CGPoint(x: self.screenSize.width/2, y: self.screenSize.height/2)
        let convertedCenter = CBSceneHelper.convertTouchCoordinateToPoint(coordinate: scaledSceneCenter, sceneSize: scaledScene.size)
        XCTAssertTrue(convertedCenter.equalTo(self.pocketCodeCenter), "The Scene Center is not correctly calculated")
    }
    
    func testTouchConversionBottomLeft() {
        let scaledScene = SceneBuilderMock(project: ProjectMock(width: self.screenSize.width * 2, andHeight: self.screenSize.height * 2)).build()
        let scaledSceneBottomLeft = CGPoint(x: 0, y: self.screenSize.height)
        let pocketCodeBottomLeft = CGPoint(x: scaledScene.size.width / 2 * -1, y: scaledScene.size.height / 2 * -1)

        let convertedBottomLeft = CBSceneHelper.convertTouchCoordinateToPoint(coordinate: scaledSceneBottomLeft, sceneSize: scaledScene.size)
        XCTAssertTrue(convertedBottomLeft.equalTo(pocketCodeBottomLeft), "The Bottom Left is not correctly calculated")
    }
    
    func testTouchConversionBottomRight() {
        let scaledScene = SceneBuilderMock(project: ProjectMock(width: self.screenSize.width * 2, andHeight: self.screenSize.height * 2)).build()
        let scaledSceneBottomRight = CGPoint(x: self.screenSize.width, y: self.screenSize.height)
        let pocketCodeBottomRight = CGPoint(x: scaledScene.size.width / 2, y: scaledScene.size.height / 2 * -1)
        
        let convertedBottomRight = CBSceneHelper.convertTouchCoordinateToPoint(coordinate: scaledSceneBottomRight, sceneSize: scaledScene.size)
        XCTAssertTrue(convertedBottomRight.equalTo(pocketCodeBottomRight), "The Bottom Right is not correctly calculated")
    }
    
    - (void)testTouchConversionTopLeft
    {
    CBScene *scaledScene = [[[SceneBuilder alloc] initWithProject:[[ProjectMock alloc] initWithWidth:self.screenSize.width * 2 andHeight: self.screenSize.height * 2]] build];
    CGPoint scaledSceneTopLeft = CGPointMake(0, 0);
    CGPoint pocketCodeTopLeft = CGPointMake(scaledScene.size.width / 2 * -1, scaledScene.size.height / 2);
    CGPoint convertedTopLeft = [CBSceneHelper convertTouchCoordinateToPointWithCoordinate:scaledSceneTopLeft sceneSize:scaledScene.size];
    XCTAssertTrue(CGPointEqualToPoint(convertedTopLeft, pocketCodeTopLeft), @"The Top Left is not correctly calculated");
    }
    
    - (void)testTouchConversionTopRight
    {
    CBScene *scaledScene = [[[SceneBuilder alloc] initWithProject:[[ProjectMock alloc] initWithWidth:self.screenSize.width * 2 andHeight: self.screenSize.height * 2]] build];
    CGPoint scaledSceneTopRight = CGPointMake(self.screenSize.width, 0);
    CGPoint pocketCodeTopRight = CGPointMake(scaledScene.size.width / 2, scaledScene.size.height / 2);
    CGPoint convertedTopRight = [CBSceneHelper convertTouchCoordinateToPointWithCoordinate:scaledSceneTopRight sceneSize:scaledScene.size];
    XCTAssertTrue(CGPointEqualToPoint(convertedTopRight, pocketCodeTopRight), @"The Top Right is not correctly calculated");
    }
    
    - (void)testVariableLabel
    {
    Project *project = [[ProjectMock alloc] initWithWidth:self.screenSize.width andHeight: self.screenSize.height];
    CBScene *scene = [[[SceneBuilder alloc] initWithProject:project] build];
    
    UserVariable *userVariable = [[UserVariable alloc] init];
    [project.variables.programVariableList addObject:userVariable];
    
    XCTAssertNil(userVariable.textLabel);
    
    XCTAssertTrue([scene startProject]);
    
    XCTAssertNotNil(userVariable.textLabel);
    XCTAssertTrue(userVariable.textLabel.isHidden);
    XCTAssertEqual(SKLabelHorizontalAlignmentModeLeft, userVariable.textLabel.horizontalAlignmentMode);
    XCTAssertEqual(kSceneLabelFontSize, userVariable.textLabel.fontSize);
    XCTAssertEqual(0, [userVariable.textLabel.text length]);
    }
    
    private func createSpriteNodeWithBubble(x xPosition: Double, y yPosition: Double, andSentence sentence: String) -> CBSpriteNode {
        let project = ProjectMock()!
        
        let spriteObject = SpriteObject()
        spriteObject.name = "SpriteObjectName"
        
        let spriteNode = CBSpriteNodeMock(spriteObject: spriteObject)
        spriteObject.spriteNode = spriteNode
        spriteObject.project = project
        
        project.objectList.add(spriteObject)
        spriteNode.mockedScene = SceneBuilderMock(project: ProjectMock(width: CGFloat(kIphoneXSceneWidth), andHeight: CGFloat(kIphoneXSceneHeight))).build()
        
        BubbleBrickHelper.addBubble(to: spriteNode, withText: sentence, andType: CBBubbleType.thought)
        spriteNode.catrobatPosition = CGPoint(x: 0, y: 0)
        spriteNode.catrobatPosition = CGPoint(x: xPosition, y: yPosition)
        
        return spriteNode
    }
    
    func testSayForTitleSingular() {
        let sayForBrick = SayForBubbleBrick()
        sayForBrick.intFormula = Formula(double: 1)
        let translation = kLocalizedSay + " %@\n" + kLocalizedFor + " %@ " + kLocalizedSecond
        XCTAssertEqual(translation, sayForBrick.brickTitle, "Wrong brick title")
    }
    
    func testSayForTitlePlural() {
        let sayForBrick = SayForBubbleBrick()
        sayForBrick.intFormula = Formula(double: 2)
        let translation = kLocalizedSay + " %@\n" + kLocalizedFor + " %@ " + kLocalizedSeconds
        XCTAssertEqual(translation, sayForBrick.brickTitle, "Wrong brick title")
    }
    
    func testThinkForTitleSingular() {
        let thinkForBrick = ThinkForBubbleBrick()
        thinkForBrick.intFormula = Formula(double: 1)
        let translation = kLocalizedThink + " %@\n" + kLocalizedFor + " %@ " + kLocalizedSecond
        XCTAssertEqual(translation, thinkForBrick.brickTitle, "Wrong brick title")
    }
    
    func testThinkForTitlePlural() {
        let thinkForBrick = ThinkForBubbleBrick()
        thinkForBrick.intFormula = Formula(double: 2)
        let translation = kLocalizedThink + " %@\n" + kLocalizedFor + " %@ " + kLocalizedSeconds
        XCTAssertEqual(translation, thinkForBrick.brickTitle, "Wrong brick title")
    }
    
    func testOneLineSentenceInBubble() {
        let spriteNode = createSpriteNodeWithBubble(x: 0, y: 0, andSentence: "Hello")
        let bubble = spriteNode.children.first
        let bubbleHeight = bubble!.frame.size.height
        
        XCTAssertTrue(bubbleHeight == CGFloat(kBubbleHeightOneLine))
    }
    
    func testTwoLineSentenceInBubble() {
        let spriteNode = createSpriteNodeWithBubble(x: 0, y: 0, andSentence: "That's a 2 line text")
        let bubble = spriteNode.children.first
        let bubbleHeight = bubble!.frame.size.height
        
        XCTAssertTrue(bubbleHeight == CGFloat(kBubbleHeightTwoLines))
    }
    
    func testThreeLineSentenceInBubble() {
        let spriteNode = createSpriteNodeWithBubble(x: 0, y: 0, andSentence: "This is a 3 line text :)")
        let bubble = spriteNode.children.first
        let bubbleHeight = bubble!.frame.size.height
        XCTAssertTrue(bubbleHeight == CGFloat(kBubbleHeightThreeLines))
    }
}
