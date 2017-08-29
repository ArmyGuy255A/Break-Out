//
//  PDTypes.h
//  Break Out
//
//  Created by Phillip Dieppa on 6/26/13.
//  Copyright (c) 2013 Phillip Dieppa. All rights reserved.
//

#define PTM_RATIO 10.0

typedef enum {
    kPDBreakoutBallPowerupNormal,
    kPDBreakoutBallPowerupFire,
    kPDBreakoutBallPowerupIce,
    kPDBreakoutBallPowerupPassthrough
} kPDBreakoutBallPowerup;

typedef enum {
    kPDBreakoutBallSpeed1x = 1,
    kPDBreakoutBallSpeed2x = 2,
    kPDBreakoutBallSpeed3x = 3,
    kPDBreakoutBallSpeed4x = 4,
    kPDBreakoutBallSpeed5x = 5,
    kPDBreakoutBallSpeed6x = 6,
    kPDBreakoutBallSpeed7x = 7,
    kPDBreakoutBallSpeed8x = 8,
    kPDBreakoutBallSpeed9x = 9,
    kPDBreakoutBallSpeed10x = 10
} kPDBreakoutBallSpeed;

typedef enum {
    kPDTagTypeBall,
    kPDTagTypePaddle,
    kPDTagTypeWallLeft,
    kPDTagTypeWallRight,
    kPDTagTypeWallCeiling,
    kPDTagTypeWallFloor,
    kPDTagTypeBlock
} kPDTagType;

#import "cocos2d.h"
#import "PDMath.h"
#import "PDBreakoutBall.h"
#import "PDHeadsUpDisplay.h"
#import "PDHUDInequality.h"
#import "PDPaddle.h"