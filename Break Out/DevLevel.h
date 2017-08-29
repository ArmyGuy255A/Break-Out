//
//  DevLevel.h
//  Break Out
//
//  Created by Phillip Dieppa on 6/23/13.
//  Copyright (c) 2013 Phillip Dieppa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "cocos2d.h"
#import "PDTypes.h"


@interface DevLevel : CCLayer {
    NSMutableArray *_blocks;
    float _touchPointX;
    bool _paused;
    
}

@property (assign) bool autoIntelligence;
@property (assign) bool touchLaunch;
@property (nonatomic, retain) PDPaddle *paddle;
@property (nonatomic, retain) PDBreakoutBall *ball;
@property (retain) PDHeadsUpDisplay *hud;
// returns a CCScene that contains the level as the only child
+(CCScene *) scene;
-(void)pauseGame;

@end
