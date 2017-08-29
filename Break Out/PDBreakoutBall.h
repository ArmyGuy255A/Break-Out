//
//  PDBreakoutBall.h
//  Break Out
//
//  Created by Phillip Dieppa on 6/26/13.
//  Copyright 2013 Phillip Dieppa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDTypes.h"

@interface PDBreakoutBall : CCSprite {
    int _rise;
    int _run;
    kPDBreakoutBallSpeed _ballSpeed;
    kPDBreakoutBallPowerup _ballPowerup;
    
}

@property (assign) int rise, run;
@property (assign) kPDBreakoutBallPowerup ballPowerup;
@property (assign) kPDBreakoutBallSpeed ballSpeed;

-(id)initWithLayer:(CCLayer *)layer;
-(void)changeDirectionUpDown;
-(void)changeDirectionLeftRight;




@end
