//
//  HKLine.h
//  Pods
//
//  Created by Panos on 2/1/14.
//
//

#ifndef _HKLine_h_
#define _HKLine_h_

#include "HKCGPoint.h"

typedef enum HKLineIntersectionType
{
    HKLineIntersectionTypeColinear = 0,
    HKLineIntersectionTypeOverlap,
    HKLineIntersectionTypePoint,
} HKLineIntersectionType;

/**
 *  HKLine defines a 2D line (with infinite length) with a spatial point and a direction.
 */
typedef struct HKLine
{
    CGPoint point;
    CGPoint vector;
} HKLine;

/**
 *  Returns a line with the specified point and direction vector.
 *
 *  @param point  A CGPoint struct corresponding to a spatial position.
 *  @param vector A normalized CGPoint struct corresponding to a spatial direction.
 *
 *  @return A line.
 */
HKLine HKLineMake(CGPoint point, CGPoint vector);

/**
 *  Returns if 2 lines intersect, are colinear, or overlap.
 *
 *  @param u               The first line
 *  @param v               The second line
 *  @param tolerance       The tolerance with which the overlapping and colinearity are going to be tested.
 *  @param outIntersection An option CGPoint that will contain the intersection point. If the result is different from HKLineIntersectionTypePoint, this argument will be untouched.
 *
 *  @return The type of intersection.
 */
HKLineIntersectionType HKLineIntersectWithTolerance(const HKLine u,
                                                    const HKLine v,
                                                    CGFloat tolerance,
                                                    CGPoint *outIntersection);

/**
 *  Returns if 2 lines intersect, are colinear, or overlap. This function is the same as `HKLineIntersectWithTolerance` with the `tolerance` argument equal to 0.
 *
 *  @param u               The first line
 *  @param v               The second line
 *  @param outIntersection An option CGPoint that will contain the intersection point. If the result is different from HKLineIntersectionTypePoint, this argument will be untouched.
 *
 *  @return The type of intersection.
 */
HKLineIntersectionType HKLineIntersect(const HKLine u,
                                       const HKLine v,
                                       CGPoint *outIntersection);

#endif /* defined(_HKCGPoint_h_) */
