//
//  HKCGPointOperators.h
//  Pods
//
//  Created by Panos on 2/1/14.
//
//

#ifndef __HKCGPointOperators__
#define __HKCGPointOperators__

#include "HKCGPoint.h"

CGPoint operator+(const CGPoint& lhs, const CGPoint& rhs);
CGPoint operator-(const CGPoint& lhs, const CGPoint& rhs);
CGPoint operator*(const CGPoint& lhs, CGFloat k);
CGPoint operator*(CGFloat k, const CGPoint& rhs);
CGPoint operator/(const CGPoint& lhs, CGFloat k);

#endif /* defined(__HKCGPointOperators__) */
