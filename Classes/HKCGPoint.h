//
//  HKCGPoint.h
//  Pods
//
//  Created by Panos on 2/1/14.
//
//

#ifndef _HKCGPoint_h_
#define _HKCGPoint_h_

#include <math.h>
#include <CoreGraphics/CGBase.h>
#include <CoreGraphics/CGGeometry.h>
#include <CoreGraphics/CGAffineTransform.h>

#pragma mark — CGPoint additional functions and overloads

/**
 *  Returns the determinant between 2 CGPoints.
 *
 *  @param a The first point
 *  @param b The second point
 *
 *  @return The determinant
 */
CGFloat CGPointDeterminant(CGPoint a, CGPoint b);

/**
 *  Returns the dot-product between 2 CGPoints.
 *
 *  @param a The first point
 *  @param b The second point
 *
 *  @return The dot-product
 */
CGFloat CGPointDot(CGPoint a, CGPoint b);

/**
 *  Returns the squared length of a CGPoint.
 *
 *  @param p A point
 *
 *  @return The squared length.
 */
CGFloat CGPointLengthSq(CGPoint p);

/**
 *  Returns the length of a CGPoint
 *
 *  @param p A point
 *
 *  @return The length.
 */
CGFloat CGPointLength(CGPoint p);

/**
 *  Returns a normalized (unit length) version of a CGPoint
 *
 *  @param p A CGPoint
 *
 *  @return The normalized CGPoint.
 */
CGPoint CGPointNormalize(CGPoint p);

/**
 *  Returns the addition of 2 CGPoints.
 *
 *  @param a The first point
 *  @param b The second point
 *
 *  @return The addition of 2 points.
 */
CGPoint CGPointAdd(CGPoint a, CGPoint b);

/**
 *  Returns the difference between 2 CGPoints.
 *
 *  @param a The first point
 *  @param b The second point
 *
 *  @return The difference between 2 points.
 */
CGPoint CGPointSubtract(CGPoint a, CGPoint b);

/**
 *  Returns a CGPoint scaled by a scalar
 *
 *  @param a A point
 *  @param f A scalar
 *
 *  @return A scaled CGPoint.
 */
CGPoint CGPointScale(CGPoint a, CGFloat f);

/**
 *  Returns the distance between 2 CGPoints
 *
 *  @param a The first point
 *  @param b The second point
 *
 *  @return The distance between 2 points.
 */
CGFloat CGPointDistance(CGPoint a, CGPoint b);

/**
 *  Returns the signed angle between 2 CGPoints.
 *
 *  @param a The first CGPoint
 *  @param b The second CGPoint
 *
 *  @return A signed ange.
 */
CGFloat CGPointSignedAngle(CGPoint a, CGPoint b);

/**
 *  Rotates a point by a certain angle around a pivot.
 *
 *  @param point The point to rotate.
 *  @param pivot The pivot point
 *  @param angle The angle of rotation, in radians.
 *
 *  @return The rotated point.
 */
CGPoint CGPointRotateAround(CGPoint point, CGPoint pivot, CGFloat angle);

/**
 *  Returns true if either x or y is equal to NaN.
 *
 *  @param point The point to test.
 *
 *  @return True if x or y is equal to NaN.
 */
bool CGPointIsNaN(CGPoint point);

#endif /* defined(_HKCGPoint_h_) */
