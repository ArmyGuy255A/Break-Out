//
//  PDMath.m
//  SimpleGame
//
//  Created by Phillip Dieppa on 1/16/12.
//  Copyright (c) 2012 WO1. All rights reserved.
//

#import "PDMath.h"

@implementation PDMath



+(CGPoint)findBestWallEdge:(CGPoint)p1 knownWallXandCeilingOrFloorY:(CGPoint)checkPoint withSlope:(CGPoint)m {
    //This function will use the following formula to determine the closest location between two points
    //Step 1: Find the y-intercept
    CGPoint p2, p3;
    p2 = ccp(checkPoint.x, 0);
    p3 = ccp(0, checkPoint.y);
    float b = [PDMath yIntercept:p1 m:m];
    
    //Step 2: Find p2's y coordinate
    p2.y = [PDMath yFromYIntercept:p2.x m:m b:b];
    
    //Step 3: Find p3's x coordinate
    p3.x = [PDMath xFromYIntercept:p3.y m:m b:b];
    
    //Step 4: Find out which point is closer
    float d1, d2;
    d1 = ccpDistance(p1, p2);
    d2 = ccpDistance(p1, p3);
    
    //Step 5: Return the closes point
    return (d1 < d2) ? p2 : p3;

}

+(CGPoint)slope:(CGPoint)p1 p2:(CGPoint)p2 {
    CGPoint s;
    
    s.y = p2.y - p1.y;
    s.x = p2.x - p1.x;
    
    return s;
}

+(CGPoint)quadraticEquation:(CGFloat)a b:(CGFloat)b c:(CGFloat)c {
    float x1 = -b + sqrtf(powf(b, 2) - 4 * a * c) / 2 * a;
    float x2 = -b - sqrtf(powf(b, 2) - 4 * a * c) / 2 * a;
    CGPoint result = ccp(x1, x2);
    
    return result;
}

+(CGFloat)pythagoreanC:(CGPoint)p1 p2:(CGPoint)p2 {
    return 0.0f; 
}

+(CGFloat)yIntercept:(CGPoint)p1 m:(CGPoint)m {
    //Finds a y-intercept for a point with a known slope
    //y = mx + b
    float b = p1.y - ((m.y / m.x) * p1.x);
    return b;
}

+(CGFloat)xFromYIntercept:(CGFloat)y m:(CGPoint)m b:(CGFloat)b {
    //Finds a missing x value on a line with a known slope and y-intercept
    // x = (y-b)/m
    CGFloat x = (y - b) * (m.x / m.y);
    return x;
}

+(CGFloat)yFromYIntercept:(CGFloat)x m:(CGPoint)m b:(CGFloat)b {
    //Finds a missing y value on a line with a known slope and y-intercept
    CGFloat y = (m.y / m.x) * x + b;
    
    return y;
}

+(CGPoint)extPtWithX:(float)newX p1:(CGPoint)p1 p2:(CGPoint)p2 {
    //This function returns a new point on a line with a given x value.
    CGPoint newCoord;
    
    newCoord.x = newX;
    
    CGPoint slope = [PDMath slope:p1 p2:p2];
    
    newCoord.y = ((slope.y * (newX - p2.x)) / slope.x) + p2.y;
    
    return newCoord;
}

+(CGPoint)extPtWithY:(float)newY p1:(CGPoint)p1 p2:(CGPoint)p2 {
    //This function returns a new point on a line with a given y value.
    CGPoint newCoord;
    
    newCoord.y = newY;
    
    CGPoint slope = [PDMath slope:p1 p2:p2];
    
    newCoord.x = ((slope.x * (newY - p2.y)) / slope.y) + p2.x;
    
    return newCoord;
}

+(CGPoint)lineCircleIntersection:(CGPoint)origin p2:(CGPoint)p2 radius:(CGFloat)r {
    CGPoint isx;
    //This function returns a point on a ray where a circle and line meet. 
    //The ray must start at the origin of the circle and only pass through once
    
    float i = 0;
    float ii = 0;
    float iii = 0;
    float x1 = 0;
    float x2 = 0;
    float y1 = 0;
    float y2 = 0;
    //First, get the equation of the line
    //m = slope
    //b = y intercept
    //y=mx+b
    CGPoint slope = [self slope:origin p2:p2];
    float m = slope.y / slope.x;
    float b = m * origin.x - origin.y;
    //x = 
    //
    //Find our circle
    //(x-h)^2 + (y-k)^2 = r^2
    //h = origin.x
    //k = origin.y
    float h = origin.x;
    float k = origin.y;
    //solve for x with the quadradic equation
    i = -(-2*h+2*b-2*k);
    ii = sqrtf(powf(-2*h+2*b-2*k, 2) - 4*powf(m, 2) * (powf(h, 2)+powf((b-k),2)-powf(r,2)));
    iii = 2 * powf(m, 2);
    
    x1 = ((i + ii) / iii);
    x2 = ((i - ii) / iii);
    
    //now solve for y;
    y1 = m*x1 + b;
    y2 = m*x2 + b;
    
    if (x1 >= 0 && x1 <= 1024) {
        isx.x = x1;
    } else {
        isx.x = x2;
    }
    if (y1 >= 0 && y1 <= 768) {
        isx.y = y1;
    } else {
        isx.y = y2;
    }
    
    //NSLog(@"x:%f, y:%f", isx.x, isx.y);
    
    return isx;
    
}

+(CGPoint)newPtWithDistance:(float)d p1:(CGPoint)p1 p2:(CGPoint)p2 {
    float c1 = ccpDistance(p1, p2);
    float a1;
    float b1;
    float c2 = d;
    float a2;
    float b2;
    
    //take inverse of d if it is negative
    if (d < 0) {
        d = -d;
    }
    
    //abort if d == 0
    if (d == 0) return ccp(0, 0);
    
    /*
    //if the distance is less than the maximum distance. Use the current point
    if (c1 < d) {
        return p2;
    }
    */
    
    //The intersection of both lines.
    CGPoint p3 = ccp(p1.x, p2.y);
    
    //Find the missing distances for the base triangle
    a1 = ccpDistance(p1, p3);
    b1 = ccpDistance(p3, p2);
    
    //Find the distances for the smaller triangle. c2 is given in the method.
    a2 = a1 * c2 / c1;
    b2 = b1 * c2 / c1;
    
    CGPoint np = ccp(p1.x - b2, p1.y - a2);
    
    CGPoint slope = [self slope:p1 p2:p2];
    
    if (slope.x > 0 && slope.y > 0) {
        //up and to the right
        np = ccp(p1.x + b2, p1.y + a2);
    } else if (slope.x > 0 && slope.y < 0) {
        //down and to the right
        np = ccp(p1.x + b2, p1.y - a2);
    } else if (slope.x < 0 && slope.y < 0) {
        //down and to the left
        np = ccp(p1.x - b2, p1.y - a2);
    } else if (slope.x < 0 && slope.y > 0) {
        //up and to the left
        np = ccp(p1.x - b2, p1.y + a2);
    } else if (slope.y == 0) {
        //Right or Left?
        if (slope.x < 0) {
            //left
            np = ccp(p1.x - b2, p1.y);
        } else {
            //right
            np = ccp(p1.x + b2, p1.y);
        }
    } else if (slope.x == 0) {
        //Up or Down ?
        if (slope.y < 0) {
            //down
            np = ccp(p1.x, p1.y - a2);
        } else {
            //up
            np = ccp(p1.x, p1.y + a2);
        }
    }
    
    return np;
    
}

+(CGPoint)newPtWithAngle:(int)angle andDistance:(int)d fromOrigin:(CGPoint)origin {
    
    //increase the angle if its < -360
    for (;angle <=-360; angle += 360);
    
    //if the angle is negative, convert it to a positive angle
    angle = angle < 0 ? 360 - angle : angle;
    
    //reduce the angle if its > 360
    for (;angle >= 360; angle -= 360);
    
    //convert the angle to radians for sin and cos functions
    float rad = angle * M_PI/180;
    
    int cosX = cos(rad) < 0 ? -1 : 1;
    int sinY = sin(rad) < 0 ? -1 : 1;
    
    //horizontal and vertical line test
    cosX = angle == 90 || angle == 270 ? 0 : cosX;
    sinY = angle == 0 || angle == 180 ? 0 : sinY;
    
    //if its horizontal or vertical, return the vertical or horizontal point on the line
    if ((cosX || sinY ) == 0) return ccp(origin.x + d * cosX, origin.y + d * sinY);
    
    float rise, run = 0;
    float ang1;
    
    ang1 = (90 - angle) * M_PI/180;
    rise = (d * sin(rad)) * sinY;
    run = (d * sin(ang1)) * cosX;
    
    return ccp(origin.x + run, origin.y + rise);
}

+(int)randomIntFromA:(int)a toB:(int)b {
    int d = b - a;
    int r = arc4random() % (d + 1) ;
    int ran = a + r;
    return ran;
}

@end
