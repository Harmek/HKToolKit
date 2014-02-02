//
//  HKCGPointOperators.cpp
//  Pods
//
//  Created by Panos on 2/1/14.
//
//

#include "HKCGPointOperators.h"

CGPoint operator+(const CGPoint& lhs, const CGPoint& rhs)
{
    return CGPointAdd(lhs, rhs);
}

CGPoint operator-(const CGPoint& lhs, const CGPoint& rhs)
{
    return CGPointSubtract(lhs, rhs);
}

CGPoint operator*(const CGPoint& lhs, CGFloat k)
{
    return CGPointScale(lhs, k);
}

CGPoint operator*(CGFloat k, const CGPoint& rhs)
{
    return CGPointScale(rhs, k);
}

CGPoint operator/(const CGPoint& lhs, CGFloat k)
{
    return CGPointScale(lhs, 1. / k);
}
