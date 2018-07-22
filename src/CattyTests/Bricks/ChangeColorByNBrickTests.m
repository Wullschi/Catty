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

#import <XCTest/XCTest.h>
#import "AbstractBrickTests.h"
#import "WhenScript.h"
#import "Pocket_Code-Swift.h"

@interface ChangeColorByNBrickTests : AbstractBrickTests
@end

@implementation ChangeColorByNBrickTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testChangeColorByNBrickPositive
{
    SpriteObject *object = [[SpriteObject alloc] init];
    Program *program = [Program defaultProgramWithName:@"a" programID:nil];
    CBSpriteNode *spriteNode = [[CBSpriteNode alloc] initWithSpriteObject:object];
    object.spriteNode = spriteNode;
    object.program = program;
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *filePath = [bundle pathForResource:@"test.png" ofType:nil];
    NSData *imageData = UIImagePNGRepresentation([UIImage imageWithContentsOfFile:filePath]);
    Look *look = [[Look alloc] initWithName:@"test" andPath:@"test.png"];
    [imageData writeToFile:[NSString stringWithFormat:@"%@images/%@", [object projectPath], @"test.png"]atomically:YES];
    
    Script *script = [[WhenScript alloc] init];
    script.object = object;
    
    ChangeColorByNBrick *brick = [[ChangeColorByNBrick alloc] init];
    brick.script = script;
    [object.lookList addObject:look];
    [object.lookList addObject:look];
    object.spriteNode.currentLook = look;
    object.spriteNode.currentUIImageLook = [UIImage imageWithContentsOfFile:filePath];
    object.spriteNode.catrobatColor = 0.0;
    
    Formula *color = [[Formula alloc] init];
    FormulaElement *formulaTree = [[FormulaElement alloc] init];
    formulaTree.type = NUMBER;
    formulaTree.value = @"70";
    color.formulaTree = formulaTree;
    brick.changeColor = color;
    
    dispatch_block_t action = [brick actionBlock];
    action();
    
    XCTAssertEqualWithAccuracy(70.0f, spriteNode.catrobatColor, 0.1f, @"ChangeColorBrick - Color not correct");
    
    [Program removeProgramFromDiskWithProgramName:program.header.programName programID:program.header.programID];
}

- (void)testChangeColorByNBrickWrongInput
{
    SpriteObject *object = [[SpriteObject alloc] init];
    Program *program = [Program defaultProgramWithName:@"a" programID:nil];
    CBSpriteNode *spriteNode = [[CBSpriteNode alloc] initWithSpriteObject:object];
    object.spriteNode = spriteNode;
    object.program = program;
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *filePath = [bundle pathForResource:@"test.png" ofType:nil];
    NSData *imageData = UIImagePNGRepresentation([UIImage imageWithContentsOfFile:filePath]);
    Look *look = [[Look alloc] initWithName:@"test" andPath:@"test.png"];
    [imageData writeToFile:[NSString stringWithFormat:@"%@images/%@", [object projectPath], @"test.png"]atomically:YES];
    
    Script *script = [[WhenScript alloc] init];
    script.object = object;
    
    ChangeColorByNBrick *brick = [[ChangeColorByNBrick alloc] init];
    brick.script = script;
    [object.lookList addObject:look];
    [object.lookList addObject:look];
    object.spriteNode.currentLook = look;
    object.spriteNode.currentUIImageLook = [UIImage imageWithContentsOfFile:filePath];
    object.spriteNode.catrobatColor = 10.0;
    
    Formula *color = [[Formula alloc] init];
    FormulaElement *formulaTree = [[FormulaElement alloc] init];
    formulaTree.type = NUMBER;
    formulaTree.value = @"a";
    color.formulaTree = formulaTree;
    brick.changeColor = color;
    
    dispatch_block_t action = [brick actionBlock];
    action();
    
    XCTAssertEqualWithAccuracy(10.0f, spriteNode.catrobatColor, 0.1f, @"ChangeColorBrick - Color not correct");
    
    [Program removeProgramFromDiskWithProgramName:program.header.programName programID:program.header.programID];
}

- (void)testChangeColorByNBrickNegative
{
    SpriteObject *object = [[SpriteObject alloc] init];
    Program *program = [Program defaultProgramWithName:@"a" programID:nil];
    CBSpriteNode *spriteNode = [[CBSpriteNode alloc] initWithSpriteObject:object];
    object.spriteNode = spriteNode;
    object.program = program;
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *filePath = [bundle pathForResource:@"test.png" ofType:nil];
    NSData *imageData = UIImagePNGRepresentation([UIImage imageWithContentsOfFile:filePath]);
    Look *look = [[Look alloc] initWithName:@"test" andPath:@"test.png"];
    [imageData writeToFile:[NSString stringWithFormat:@"%@images/%@", [object projectPath], @"test.png"]atomically:YES];
    
    Script *script = [[WhenScript alloc] init];
    script.object = object;
    
    ChangeColorByNBrick* brick = [[ChangeColorByNBrick alloc] init];
    brick.script = script;
    [object.lookList addObject:look];
    [object.lookList addObject:look];
    object.spriteNode.currentLook = look;
    object.spriteNode.currentUIImageLook = [UIImage imageWithContentsOfFile:filePath];
    object.spriteNode.catrobatColor = 20.0;
    
    Formula* color = [[Formula alloc] init];
    FormulaElement* formulaTree = [[FormulaElement alloc] init];
    formulaTree.type = NUMBER;
    formulaTree.value = @"-10";
    color.formulaTree = formulaTree;
    brick.changeColor = color;
    
    dispatch_block_t action = [brick actionBlock];
    action();
    
    XCTAssertEqualWithAccuracy(10.0f, spriteNode.catrobatColor, 0.1f, @"ChangeColorBrick - Color not correct");
    
    [Program removeProgramFromDiskWithProgramName:program.header.programName programID:program.header.programID];
}

- (void)testChangeColorByNBrickMoreThan2Pi
{
    SpriteObject *object = [[SpriteObject alloc] init];
    Program *program = [Program defaultProgramWithName:@"a" programID:nil];
    CBSpriteNode *spriteNode = [[CBSpriteNode alloc] initWithSpriteObject:object];
    object.spriteNode = spriteNode;
    object.program = program;
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *filePath = [bundle pathForResource:@"test.png" ofType:nil];
    NSData *imageData = UIImagePNGRepresentation([UIImage imageWithContentsOfFile:filePath]);
    Look *look = [[Look alloc] initWithName:@"test" andPath:@"test.png"];
    [imageData writeToFile:[NSString stringWithFormat:@"%@images/%@", [object projectPath], @"test.png"]atomically:YES];
    
    Script *script = [[WhenScript alloc] init];
    script.object = object;
    
    ChangeColorByNBrick* brick = [[ChangeColorByNBrick alloc] init];
    brick.script = script;
    [object.lookList addObject:look];
    [object.lookList addObject:look];
    object.spriteNode.currentLook = look;
    object.spriteNode.currentUIImageLook = [UIImage imageWithContentsOfFile:filePath];
    object.spriteNode.ciHueAdjust = ColorSensor.defaultRawValue;
    
    Formula* color = [[Formula alloc] init];
    FormulaElement* formulaTree = [[FormulaElement alloc] init];
    formulaTree.type = NUMBER;
    formulaTree.value = @"-730";
    color.formulaTree = formulaTree;
    brick.changeColor = color;
    
    dispatch_block_t action = [brick actionBlock];
    action();
    
    XCTAssertEqualWithAccuracy(200-130.0f, spriteNode.catrobatColor, 0.1f, @"ChangeColorBrick - Color not correct");
    
    [Program removeProgramFromDiskWithProgramName:program.header.programName programID:program.header.programID];
}

@end
