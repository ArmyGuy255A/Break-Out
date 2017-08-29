//
//  PDBreakoutBall.m
//  Break Out
//
//  Created by Phillip Dieppa on 6/26/13.
//  Copyright 2013 Phillip Dieppa. All rights reserved.
//

#import "PDBreakoutBall.h"


@implementation PDBreakoutBall

@synthesize ballPowerup = _ballPowerup;
@synthesize ballSpeed = _ballSpeed;
@synthesize rise = _rise;
@synthesize run = _run;

-(id)initWithLayer:(CCLayer *)layer {
    if ((self = [super initWithFile:@"RicosHead22.png"])) {
        _ballPowerup = kPDBreakoutBallPowerupNormal;
        _ballSpeed = 15;
        self.tag = kPDTagTypeBall;
        [self setZOrder:1];
        //default slope is 1/2
        _rise = 2;
        _run = 1;
        
    }
    
    return self;
}


-(void)changeDirectionUpDown {
    self.rise *= -1;
}

-(void)changeDirectionLeftRight {
    self.run *= -1;
}



@end
