//
//  HKCGPointTests.m
//  Demo
//
//  Created by Panos on 2/2/14.
//  Copyright (c) 2014 Panos. All rights reserved.
//

@import XCTest;
#import <HKCGPoint.h>

@interface HKCGPointTests : XCTestCase

@property (nonatomic, assign) CGPoint a;
@property (nonatomic, assign) CGPoint b;

@end

@implementation HKCGPointTests

- (void)setUp
{
    self.a = CGPointMake(1., .0);
    self.b = CGPointMake(.0, 1.);
}

- (void)testDeterminant
{
    XCTAssertTrue(CGPointDeterminant(self.a, self.b) == 1.);
    
    self.a = CGPointMake(.0, 42.);
    XCTAssertTrue(CGPointDeterminant(self.a, self.b) == .0);
    
    self.b = CGPointMake(-42., .0);
    XCTAssertTrue(CGPointDeterminant(self.a, self.b) == (42. * 42.));
}

- (void)testDot
{
    XCTAssertTrue(CGPointDot(self.a, self.b) == 0.);
    
    self.a = CGPointMake(12., 42.);
    self.b = CGPointMake(1., 1.);
    XCTAssertTrue(CGPointDot(self.a, self.b) == 12. + 42.);
    XCTAssertTrue(CGPointDot(self.b, self.b) == 2.);
}

- (void)testNormalize
{
    CGPoint vector = CGPointMake(42., 56.);
    CGPoint normalized = CGPointNormalize(vector);
    XCTAssertTrue(CGPointLength(normalized) == 1);
}

- (void)testAdd
{
    CGPoint c = CGPointAdd(self.a, self.b);
    XCTAssertTrue(c.x == 1.);
    XCTAssertTrue(c.y == 1.);
}

- (void)testSubtract
{
    CGPoint c = CGPointSubtract(self.a, self.b);
    XCTAssertTrue(c.x == 1.);
    XCTAssertTrue(c.y == -1.);
}

- (void)testScale
{
    CGPoint c = CGPointScale(self.a, 42.);
    XCTAssertTrue(c.x == 42.);
    XCTAssertTrue(c.y == .0);
}

- (void)testDistance
{
    CGFloat dist = CGPointDistance(self.a, self.b);
    XCTAssertTrue(dist == sqrt(2.));
    dist = CGPointDistance(CGPointZero, CGPointZero);
    XCTAssertTrue(dist == .0);
    dist = CGPointDistance(self.a, self.a);
    XCTAssertTrue(dist == .0);
}

@end
