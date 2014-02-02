//
//  HKCGPoint.cpp
//  Pods
//
//  Created by Panos on 2/1/14.
//
//

#include "HKCGPoint.h"

#pragma mark — CGPoint additional functions and overloads

CGFloat CGPointDeterminant(CGPoint a, CGPoint b)
{
    return a.x * b.y - a.y * b.x;
}

CGFloat CGPointDot(CGPoint a, CGPoint b)
{
    return a.x * b.x + a.y * b.y;
}

CGFloat CGPointLengthSq(CGPoint p)
{
    return CGPointDot(p, p);
}

CGFloat CGPointLength(CGPoint p)
{
    return sqrt(CGPointLengthSq(p));
}

CGPoint CGPointNormalize(CGPoint p)
{
    CGFloat length = CGPointLength(p);
    
    return CGPointMake(p.x / length, p.y / length);
}

CGPoint CGPointAdd(CGPoint a, CGPoint b)
{
    return CGPointMake(a.x + b.x, a.y + b.y);
}

CGPoint CGPointSubtract(CGPoint a, CGPoint b)
{
    return CGPointMake(a.x - b.x, a.y - b.y);
}

CGPoint CGPointScale(CGPoint a, CGFloat f)
{
    return CGPointMake(a.x * f, a.y * f);
}

CGFloat CGPointDistance(CGPoint a, CGPoint b)
{
    return CGPointLength(CGPointSubtract(a, b));
}

CGFloat CGPointSignedAngle(CGPoint a, CGPoint b)
{
    CGFloat sinValue = a.x * b.y - a.y * b.x;
    CGFloat cosValue = CGPointDot(a, b);
    
    return atan2(sinValue, cosValue);
}

CGPoint CGPointRotateAround(CGPoint point, CGPoint pivot, CGFloat angle)
{
    CGPoint result = CGPointApplyAffineTransform(CGPointSubtract(point, pivot),
                                                 CGAffineTransformMakeRotation(angle));
    result = CGPointAdd(result, pivot);
    
    return result;
}

bool CGPointIsNaN(CGPoint point)
{
    return isnan(point.x) || isnan(point.y);
}
