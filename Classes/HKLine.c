//
//  HKLine.c
//  Pods
//
//  Created by Panos on 2/1/14.
//
//

#include "HKLine.h"

HKLine HKLineMake(CGPoint point, CGPoint vector)
{
    return (HKLine)
    {
        .point = point,
        .vector = vector
    };
}

HKLineIntersectionType HKLineIntersectWithTolerance(const HKLine u,
                                                    const HKLine v,
                                                    CGFloat tolerance,
                                                    CGPoint *outIntersection)
{
    CGFloat determinant = CGPointDeterminant(u.vector, v.vector);
    
    if (fabs(determinant) < tolerance)
    {
        determinant = CGPointDeterminant(CGPointSubtract(v.point, u.point), v.vector);
        if (fabs(determinant) < tolerance)
        {
            return HKLineIntersectionTypeOverlap;
        }
        
        return HKLineIntersectionTypeColinear;
    }
    
    if (outIntersection)
    {
        // We need k and l such as "u.point + k * u.vector = v.point + l * v.vector"
        CGFloat k = CGPointDeterminant(CGPointSubtract(v.point, u.point), v.vector) / CGPointDeterminant(u.vector, v.vector);
        *outIntersection = CGPointScale(CGPointAdd(u.point, u.vector), k);
    }
    
    return HKLineIntersectionTypePoint;
}

HKLineIntersectionType HKLineIntersect(const HKLine u,
                                       const HKLine v,
                                       CGPoint *outIntersection)
{
    return HKLineIntersectWithTolerance(u, v, .0, outIntersection);
}


