//
//  PDMath.h
//  SimpleGame
//
//  Created by Phillip Dieppa on 1/16/12.
//  Copyright (c) 2012 WO1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDMath : NSObject

+(CGPoint)findBestWallEdge:(CGPoint)p1 knownWallXandCeilingOrFloorY:(CGPoint)checkPoint withSlope:(CGPoint)m;

+(CGPoint)slope:(CGPoint)p1 p2:(CGPoint)p2;

+(CGPoint)quadraticEquation:(CGFloat)a b:(CGFloat)b c:(CGFloat)c;

+(CGFloat)pythagoreanC:(CGPoint)p1 p2:(CGPoint)p2;

+(CGFloat)yIntercept:(CGPoint)p1 m:(CGPoint)m;

+(CGFloat)xFromYIntercept:(CGFloat)y m:(CGPoint)m b:(CGFloat)b;
    
+(CGFloat)yFromYIntercept:(CGFloat)x m:(CGPoint)m b:(CGFloat)b;

+(CGPoint)extPtWithX:(float)newX p1:(CGPoint)p1 p2:(CGPoint)p2; 

+(CGPoint)extPtWithY:(float)newY p1:(CGPoint)p1 p2:(CGPoint)p2; 

+(CGPoint)lineCircleIntersection:(CGPoint)center p2:(CGPoint)p2 radius:(CGFloat)radius;

+(CGPoint)newPtWithDistance:(float)d p1:(CGPoint)p1 p2:(CGPoint)p2;

+(CGPoint)newPtWithAngle:(int)angle andDistance:(int)d fromOrigin:(CGPoint)origin;

+(int)randomIntFromA:(int)a toB:(int)b;


@end
