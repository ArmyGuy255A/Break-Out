//
//  InequalityLevel.m
//  Break Out
//
//  Created by Phillip Dieppa on 6/23/13.
//  Copyright (c) 2013 Phillip Dieppa. All rights reserved.
//

#import "InequalityLevel.h"


@implementation InequalityLevel

@synthesize touchLaunch;
@synthesize ball;
@synthesize hud = _hud;


// Helper class method that creates a Scene with the level as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	InequalityLevel *layer = [InequalityLevel node];
    
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        //set the touch launch setting to YES to enable an initial launch setting.
        [self setTouchLaunch:YES];
        
        //Touch Enable
        [self setTouchEnabled:YES];
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        
       
        
        
        //Create the ball sprite and set it on top of the paddle
        ball = [[PDBreakoutBall alloc] initWithLayer:self];
        ball.position = ccp(winSize.width/2, winSize.height/2);
        [ball setColor:ccRED];
        [ball setBallSpeed:kPDBreakoutBallSpeed3x];
        [self addChild:ball];
        
        //CREATE THE LEVEL
        
                
        //Add the HUD
        _hud = [[PDHUDInequality alloc] initWithLayer:self];
        [self updateHUDBallPosition];
        
        //Set the ballSize in the Hud
        [_hud.ballSize setString:[NSString stringWithFormat:@"Width: %i px     Height: %i px     Radius (r): %.1f", (int)ball.contentSize.width, (int)ball.contentSize.height, (double)ball.contentSize.width/2]];
        [self addChild:_hud z:10];
        //Set the screensize in the Hud
        [_hud.screenSize setString:[NSString stringWithFormat:@"Width (w) %i px    Height (h): %i px", (int)winSize.width, (int)winSize.height]];
        
        //Fill out the formulas
        
        [self updateHUDFormulas];
        
        //Hide the answers
        _showAnswers = false;
        [_hud.iqLeft setVisible:_showAnswers];
        [_hud.iqRight setVisible:_showAnswers];
        [_hud.iqTop setVisible:_showAnswers];
        [_hud.iqBottom setVisible:_showAnswers];
        [_hud.iqLeftA setVisible:_showAnswers];
        [_hud.iqRightA setVisible:_showAnswers];
        [_hud.iqTopA setVisible:_showAnswers];
        [_hud.iqBottomA setVisible:_showAnswers];
        //Pause the game
        _paused = YES;
        
	}
    
    
    
	return self;
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //Send the ball in motion
    //add logic to determine if the ball is moving, if so.. no need to set the ball in motion
    if (touchLaunch == YES) {
        //Turn off touch launch
        [self setTouchLaunch:NO];
        
        //schedule the ticker with the game FPS
        [self schedule:@selector(ballTick1:) interval:1/120];
        [self schedule:@selector(ballTick2:) interval:1/60];
        
        int wall, ceiling;
        wall = (ball.run > 0) ? [CCDirector sharedDirector].winSize.width : 0;
        ceiling = (ball.rise > 0) ? [CCDirector sharedDirector].winSize.height : 0;
        CGPoint dest = [PDMath findBestWallEdge:ball.position knownWallXandCeilingOrFloorY:ccp(wall, ceiling) withSlope:ccp(ball.run, ball.rise)];
    
        //Long Version
        //Get the PTM radio for the distance the ball is going, d(in meters) = PTM / d(in pixels)
        //The ball will be traveling at the PTM_RATIO speed which is 16. Multiply it by the ball's speed multiplier
        //Get the duration the ball will need to travel from point a to b by dividing the d(in meters) by the speed(in meters).
        /*
        float dist = ccpDistance(ball.position, dest) / PTM_RATIO;
        float spd = (PTM_RATIO * ball.ballSpeed);
        float dur = dist/spd;
         */
        
        CCAction *moveAction = [CCMoveTo actionWithDuration:((ccpDistance(ball.position, dest))/PTM_RATIO)/(PTM_RATIO * ball.ballSpeed) position:dest];
        moveAction.tag = 1;
        [ball runAction:moveAction];
    }
        
    //Pause the game if the touch is > half the screens height
    UITouch *touch = (UITouch *)[touches anyObject];
    CGPoint touchPoint = [touch  locationInView:[touch view]];
    touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
    
    if (touchPoint.y > [CCDirector sharedDirector].winSize.height/2) {
        
        [self pauseGame];
        
    }
    
    //Show the labels
    if ((touchPoint.x > [CCDirector sharedDirector].winSize.width - 100) && (touchPoint.y < 100)) {
        [self showHideAnswers];
    }
    
    //Exit the game if the touch is in the bottom left of the screen
    if ((touchPoint.x < 100) && (touchPoint.y < 100)) {
        [self removeFromParentAndCleanup:YES];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[TitleScene scene]]];
    }
    
    
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject]; 
    CGPoint touchPoint = [touch  locationInView:[touch view]];
    touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  
}

-(void)ballTick1:(ccTime)dt {
    [self ballCollision];
}

-(void)ballTick2:(ccTime)dt {
    [self updateHUDBallPosition];
}



#pragma mark - Ball Collision Start

-(void)ballCollision {
    
    /*
     Ball Move Actions
     Action Tag 1: Ball Hit Block
     Action Tag 2: Ball Hit Left Wall, now moving right
     Action Tag 3: Ball Hit Ceiling, now moving down
     Action Tag 4: Ball Hit Corner
     Action Tag 5: Ball Hit Paddle
     Action Tag 6: Ball Hit Right Wall, now moving left
     Action Tag 7: Ball Hit Floor, now moving up
     */
    bool pendingDirectionChange = NO;
    
#pragma mark Screen Collision
    //See if the ball hit the screen.
    if (!pendingDirectionChange) {
        
        //used to determine if the ball is in a corner
        bool leftRight = NO, upDown = NO;
        
        //Ceiling
        if (ball.position.y > [CCDirector sharedDirector].winSize.height - ball.contentSize.height/2) {
            upDown = YES;
            if (![ball getActionByTag:3] && ![ball getActionByTag:4]) {
                [self screenBounce:false upDown:true withActionTag:3];
            }
        }
        
        //Floor
        if (ball.position.y < ball.contentSize.height/2) {
            upDown = YES;
            if (![ball getActionByTag:7] && ![ball getActionByTag:4]) {
                [self screenBounce:false upDown:true withActionTag:7];
            }
        }
        
        //Left wall
        if (ball.position.x < ball.contentSize.width/2) {

            leftRight = YES;
            if (![ball getActionByTag:2] && ![ball getActionByTag:4]) {
                [self screenBounce:true upDown:false withActionTag:2];
            }
        }
        
        //Right wall
        if (ball.position.x > ([CCDirector sharedDirector].winSize.width - ball.contentSize.width/2)) {
            leftRight = YES;
            if (![ball getActionByTag:6] && ![ball getActionByTag:4]) {
                [self screenBounce:true upDown:false withActionTag:6];
            }
        }
        
        //Corners
        if (leftRight && upDown) {
            //Stuck in a corner!
            if (![ball getActionByTag:4]) {
                [self screenBounce:false upDown:false withActionTag:4];
            }
        }
    }
}

-(void)screenBounce:(bool)leftRight upDown:(bool)upDown withActionTag:(int)actionTag {
    //Stop all movements
    [ball stopAllActions];
    
    if (leftRight) {
        [ball changeDirectionLeftRight];
    }
    
    if (upDown) {
        [ball changeDirectionUpDown];
    }
    
    int wall, ceiling;
    wall = (ball.run > 0) ? [CCDirector sharedDirector].winSize.width : 0;
    ceiling = (ball.rise > 0) ? [CCDirector sharedDirector].winSize.height : 0;
    CGPoint dest = [PDMath findBestWallEdge:ball.position knownWallXandCeilingOrFloorY:ccp(wall, ceiling) withSlope:ccp(ball.run, ball.rise)];
    CCAction *moveAction = [CCMoveTo actionWithDuration:((ccpDistance(ball.position, dest))/PTM_RATIO)/(PTM_RATIO * ball.ballSpeed) position:dest];
    moveAction.tag = actionTag;
    [ball runAction:moveAction];
    
    [self pauseGame];
}

-(void)updateHUDBallPosition {
    [_hud.ballPosition setString:[NSString stringWithFormat:@"x = %.2f    y = %.2f", ball.position.x, ball.position.y]];
    [self updateHUDFormulas];
}

-(void)updateHUDFormulas {

    [_hud.iqLeftA setString:[NSString stringWithFormat:@"%.2f > %.2f",ball.position.x, ball.contentSize.width/2]];
    [_hud.iqRightA setString:[NSString stringWithFormat:@"%.2f < %i - %.2f",ball.position.x, (int)[CCDirector sharedDirector].winSize.width,ball.contentSize.width/2]];
    [_hud.iqTopA setString:[NSString stringWithFormat:@"%.2f < %i - %.2f", ball.position.y, (int)[CCDirector sharedDirector].winSize.height, ball.contentSize.height/2]];
    [_hud.iqBottomA setString:[NSString stringWithFormat:@"%.2f > %.2f", ball.position.y, ball.contentSize.height/2]];
    
}

-(void)showHideAnswers {
    
    _showAnswers = !_showAnswers;
    
    [_hud.iqLeft setVisible:_showAnswers];
    [_hud.iqRight setVisible:_showAnswers];
    [_hud.iqTop setVisible:_showAnswers];
    [_hud.iqBottom setVisible:_showAnswers];
    [_hud.iqLeftA setVisible:_showAnswers];
    [_hud.iqRightA setVisible:_showAnswers];
    [_hud.iqTopA setVisible:_showAnswers];
    [_hud.iqBottomA setVisible:_showAnswers];
}

-(void)pauseGame {

    if (_paused) {
        _paused = NO;
        [self.actionManager resumeTarget:ball];
    } else {
        _paused = YES;
        [self.actionManager pauseTarget:ball];
    }
}
#pragma mark - Dealloc


- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
    [ball release];
	[super dealloc];
}

@end
