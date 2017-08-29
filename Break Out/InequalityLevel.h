//
//  InequalityLevel.h
//  Break Out
//
//  Created by Phillip Dieppa on 6/23/13.
//  Copyright (c) 2013 Phillip Dieppa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "cocos2d.h"
#import "PDTypes.h"


@interface InequalityLevel : CCLayer {
    float _touchPointX;
    bool _paused;
    bool _showAnswers;
    
}

@property (assign) bool touchLaunch;
@property (nonatomic, retain) PDBreakoutBall *ball;
@property (retain) PDHUDInequality *hud;
// returns a CCScene that contains the level as the only child
+(CCScene *) scene;
-(void)pauseGame;
@end
