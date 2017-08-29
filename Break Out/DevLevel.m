//
//  DevLevel.m
//  Break Out
//
//  Created by Phillip Dieppa on 6/23/13.
//  Copyright (c) 2013 Phillip Dieppa. All rights reserved.
//

#import "DevLevel.h"


@implementation DevLevel

@synthesize touchLaunch;
@synthesize ball;
@synthesize paddle;
@synthesize autoIntelligence;
@synthesize hud = _hud;


// Helper class method that creates a Scene with the level as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	DevLevel *layer = [DevLevel node];
    
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
        
        //Create paddle and add it to the layer
        paddle = [[PDPaddle alloc] initWithLayer:self];
        paddle.position = ccp(winSize.width/4, 50);
        [self addChild:paddle];
        //add auto intelligence to the paddle.
        self.autoIntelligence = YES;
        
        //Create the ball sprite and set it on top of the paddle
        ball = [[PDBreakoutBall alloc] initWithLayer:self];
        ball.position = ccp(paddle.position.x,paddle.position.y + (ball.contentSize.height/2) + (paddle.contentSize.height/2));
        //ball.position = ccp(350,600);
        [self addChild:ball];
        
        //CREATE THE LEVEL
        
        _blocks = [[NSMutableArray alloc] init];
        
        int rb = 0;
        int cb = 0;
        int box = 0;
        bool rowUp = true;
        
        for (int r = 0; r < 10; r++) {
            //NSLog(@"New Row!");
            
            //Add some blocks along a column
            for(int i = 0; i < 10; i++) {
                
                //Create a funky level
                if (i >= 0 && i <= 3) {
                    cb++;
                } else if (i >= 4 && i <= 5) {
                    cb = 5;
                } else if (i >= 6) {
                    cb--;
                }
                
                box = rb+cb;
                
                static int padding=2;
                
                // Create block and add it to the layer
                CCSprite *block = [CCSprite spriteWithFile:[NSMutableString stringWithFormat:@"block-%i.png",box]];
                int xOffset = padding+block.contentSize.width / 2 + ((block.contentSize.width+padding)*i);
                block.position = ccp(xOffset, winSize.height - (r * block.contentSize.height + 2) - block.contentSize.height/2);
                block.tag = 3;
                
                [_blocks addObject:block];
                [self addChild:block];
                
            }
            //reset the column numbers
            cb = 0;
            
            //make sure the row box number "XX" is never <0 or > 20. Need to ensure the tiles remain in a valid number sequence.
            if (rb == 0) {
                rowUp = true;
            } else if (rb == 20) {
                rowUp = false;
            }
            
            //do some row logic
            if (rowUp == true) {
                rb += 10;
            } else {
                rb -= 10;
            }
            
            
        }
        
        //Add the HUD
        _hud = [[PDHeadsUpDisplay alloc] initWithLayer:self];
        [self updateHUDBlockCount];
        [self updateHUDBallSpeed];
        [self addChild:_hud z:10];
        
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
        [self schedule:@selector(ballTick:) interval:1/120];
        
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
        [self updateNewSlope:ccp(ball.run, ball.rise)];
    }
        
    //Pause the game if the touch is > half the screens height
    UITouch *touch = (UITouch *)[touches anyObject];
    CGPoint touchPoint = [touch  locationInView:[touch view]];
    touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
    
    if (touchPoint.y > [CCDirector sharedDirector].winSize.height/2) {
        
        [self pauseGame];
        
    }
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject]; 
    CGPoint touchPoint = [touch  locationInView:[touch view]];
    touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
    
    //Set the touch area from the bottom of the screen to the top of the paddle. Also added a buffer of one paddle width above the paddle for people with sausage fingers.
    if (touchPoint.y < (paddle.position.y + paddle.contentSize.height*2)) {
        [paddle setPosition:ccp(touchPoint.x, paddle.position.y)];
    }
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    /*
    //remove the touch point x value, if the touch was in the paddle
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:[touch view]];
    touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
    if (CGRectContainsPoint(paddle.boundingBox, touchPoint)) {
        NSLog(@"Removing TouchPointX");
        _touchPointX = 0;
    }
     */
}

-(void)ballTick:(ccTime)dt {
    [self ballCollision];
        
}



-(void)movePaddle {
    //auto move with ball if the slope's run is going down
    if (ball.numberOfRunningActions > 0) {
        //move the paddle
        if ([paddle numberOfRunningActions] == 0) {
            CCAction *ballAction = nil;
            for (int x = 0; ballAction == nil; x++) {
                //NSLog(@"Looking for ball action by tag: %i", x);
                ballAction = [[ball actionManager] getActionByTag:x target:ball];
            }
            if ([ballAction class] == [CCMoveTo class] ) {
                //NSLog(@"Got an action! Let's rock!");
                CCMoveTo *ballDestMove = (CCMoveTo *)ballAction;
                
                //see if we're moving left
                
                int x = (paddle.boundingBox.origin.x - ballDestMove.endPosition.x) * -1;
                //NSLog(@"Moving Paddle in this direction: %i", x);
                if (x > 0) {
                    paddle.isMovingRight = YES;
                    paddle.isMovingLeft = NO;
                } else if (x == 0) {
                    paddle.isMovingLeft = NO;
                    paddle.isMovingRight = NO;
                } else {
                    paddle.isMovingRight = NO;
                    paddle.isMovingLeft = YES;
                }
                CCAction *movePaddle = [CCMoveTo actionWithDuration:ballDestMove.duration position:ccp(ballDestMove.endPosition.x + [PDMath randomIntFromA:0 toB:25], paddle.boundingBox.origin.y + paddle.boundingBox.size.height/2)];
                //Tag 1 is an auto-move
                [movePaddle setTag:1];
                [paddle runAction:movePaddle];
                //paddle.position = ccp(ballDestMove.endPosition.x , 50);
            }
        }
        
    }
    
}

#pragma mark - Ball Collision Start
-(void)ballCollision {
    
    /*
     Ball Move Actions
     Action Tag 1: Ball Hit Block
     Action Tag 2: Ball Hit Left/Right Wall
     Action Tag 3: Ball Hit Ceiling/Floor
     Action Tag 4: Ball Hit Corner
     Action Tag 5: Ball Hit Paddle
     */
    NSMutableArray *blocksToDelete = [NSMutableArray arrayWithCapacity:_blocks.count];
    bool pendingDirectionChange = NO;
    bool pendingDirectionChangeUpDown = NO;
    bool pendingDirectionChangeLeftRight = NO;
    CGRect intersection;
    
    //see if the ball hits a set of blocks.
    for (CCSprite *block in _blocks) {
        CGRect blockRect = CGRectMake(block.position.x - (block.boundingBox.size.width/2),
                                      block.position.y - (block.boundingBox.size.height/2),
                                      block.boundingBox.size.width,
                                      block.boundingBox.size.height);
        if (CGRectIntersectsRect(ball.boundingBox, blockRect)) {
            
            intersection = CGRectIntersection(ball.boundingBox, blockRect);
            
            //NSLog(@"Impact With Block!");
            [blocksToDelete addObject:block];
            
            //pause the ball and signify a direction change
            [ball stopAllActions];
            pendingDirectionChange = YES;
            
        }
    }
    
    if (blocksToDelete.count > 0) {
        for (CCSprite *block in blocksToDelete) {
            [self removeChild:block cleanup:YES];
            [_blocks removeObject:block];
        }
        [blocksToDelete removeAllObjects];

    }
    
    //get the ball coordinates
    CGPoint bottomLeftCorner = ball.boundingBox.origin;
    CGPoint bottomRightCorner = ccp(ball.boundingBox.origin.x + ball.boundingBox.size.width, ball.boundingBox.origin.y);
    CGPoint topLeftCorner = ccp(ball.boundingBox.origin.x, ball.boundingBox.origin.y + ball.boundingBox.size.height);
    CGPoint topRightCorner = ccp(ball.boundingBox.origin.x + ball.boundingBox.size.width, ball.boundingBox.origin.y + ball.boundingBox.size.height);
    
    //See if the ball hit the screen or paddle.
    if (!pendingDirectionChange) {
        //float s = 0, t = 0;
        
        //get the screen coordinates
        CGPoint screenBLCorner = ccp(0, 0);
        CGPoint screenBRCorner = ccp([CCDirector sharedDirector].winSize.width, 0);
        CGPoint screenTLCorner = ccp(0, [CCDirector sharedDirector].winSize.height);
        CGPoint screenTRCorner = ccp([CCDirector sharedDirector].winSize.width, [CCDirector sharedDirector].winSize.height);
        
        
        
        bool leftRight = NO, upDown = NO;
        
#pragma mark Paddle Hit
        
        //get the ball coordinates
        //CGPoint pBottomLeftCorner = paddle.boundingBox.origin;
        //CGPoint pBottomRightCorner = ccp(paddle.boundingBox.origin.x + paddle.boundingBox.size.width, paddle.boundingBox.origin.y);
        CGPoint pTopLeftCorner = ccp(paddle.boundingBox.origin.x, paddle.boundingBox.origin.y + paddle.boundingBox.size.height);
        CGPoint pTopRightCorner = ccp(paddle.boundingBox.origin.x + paddle.boundingBox.size.width, paddle.boundingBox.origin.y + paddle.boundingBox.size.height);
        
        //See if the ball hit the paddle
        // CGPoint ballBottomLeft = ccp(ball.position.x - (ball.contentSize.width/2), ball.position.y - (ball.contentSize.height/2));
        //CGPoint ballBottomRight = ccp(ballBottomLeft.x + ball.contentSize.width, ballBottomLeft.y);
        
        if ((ccpSegmentIntersect(bottomLeftCorner, topLeftCorner, pTopLeftCorner, pTopRightCorner)||
             ccpSegmentIntersect(bottomRightCorner, topRightCorner, pTopLeftCorner, pTopRightCorner)) && (![ball getActionByTag:5] && ![ball getActionByTag:4])) {
            upDown = YES;
                        
            //NSLog(@"Paddle Hit");
            
            
            //Ball hit paddle
            [ball stopActionByTag:1];
            [ball stopActionByTag:2];
            [ball stopActionByTag:3];
            [ball stopActionByTag:4];
            
            //Find out where so we can change the slope!
            bool slopeChanged = NO;
            int x = 0;
            do {
                //NSLog(@"%i", x);
                
                //iterate through the children until one is found for the collision
                CCSprite *impactBlock = (CCSprite *)[paddle.impactBlocks objectAtIndex:x + (paddle.impactBlocks.count/2)];
                CGRect rect1 = ball.boundingBox;
                CGRect rect2 = CGRectMake(impactBlock.boundingBox.origin.x + paddle.boundingBox.origin.x, impactBlock.boundingBox.origin.y+ paddle.boundingBox.origin.y, impactBlock.boundingBox.size.width, impactBlock.boundingBox.size.height);
                
                if (CGRectIntersectsRect(rect1, rect2)) {
                    //Exit the do-while loop because we hit the paddle in an impact area
                    slopeChanged = YES;
                    
                    //Get the slope from the impactBlocks array contained in the paddle object
                    NSValue *slopeValue = (NSValue *)[paddle.impactBlocks objectAtIndex:x];
                    CGPoint newSlope;
                    [slopeValue getValue:&newSlope];
                    
                    //Change the rise. Multiply by -1 because the ball is traveling down
                    ball.rise = newSlope.y * (ball.rise / abs(ball.rise));
                    
                    //Change the run. Need to make sure the ball moves naturally. So we use the following equation:
                    // run/absoluteValue(run) = +/-1
                    // Then we use that number to change the new slope through multiplication
                    ball.run = newSlope.x * (ball.run / abs(ball.run));
                    //Determine if it's the first or last block
                    if ((x == 0) || (x == (paddle.impactBlocks.count / 2)-1)) {
                        //NSLog(@"Hit the first or Last Block");
                        [ball changeDirectionLeftRight];
                    } else {
                        //NSLog(@"Hit the middle somewhere");
                    }
                    
                } else {
                    
                    x++;
                    
                    if (x == (paddle.impactBlocks.count / 2) - 1) {
                        slopeChanged = YES;
                    }
                }
                
            } while (slopeChanged == NO);
            
           
            //change the direction of the ball
            [ball changeDirectionUpDown];
            
            //Move the ball
            int wall, ceiling;
            wall = (ball.run > 0) ? [CCDirector sharedDirector].winSize.width : 0;
            ceiling = (ball.rise > 0) ? [CCDirector sharedDirector].winSize.height : 0;
            CGPoint dest = [PDMath findBestWallEdge:ball.position knownWallXandCeilingOrFloorY:ccp(wall, ceiling) withSlope:ccp(ball.run, ball.rise)];
            
            CCAction *moveAction = [CCMoveTo actionWithDuration:((ccpDistance(ball.position, dest))/PTM_RATIO)/(PTM_RATIO * ball.ballSpeed) position:dest];
            moveAction.tag = 5;
            [ball runAction:moveAction];
            
        }
        
        //Left Wall & Right Wall
        if (ccpSegmentIntersect(topLeftCorner, topRightCorner, screenBLCorner, screenTLCorner) ||
            ccpSegmentIntersect(bottomLeftCorner, bottomRightCorner, screenBLCorner, screenTLCorner) ||
            ccpSegmentIntersect(topLeftCorner, topRightCorner, screenBRCorner, screenTRCorner)||
            ccpSegmentIntersect(bottomLeftCorner, bottomRightCorner, screenBRCorner, screenTRCorner)) {
            //This is used to determine if the ball is in a corner
            leftRight = YES;
            
            //check to see if the ball is pending a move from the left or right or corner
            if (![ball getActionByTag:2] && ![ball getActionByTag:4]) {
                //NSLog(@"Impact With Sides!");
                
                //Move the ball
                [ball stopActionByTag:1];
                [ball stopActionByTag:3];
                [ball stopActionByTag:5];
                [ball changeDirectionLeftRight];
                int wall, ceiling;
                wall = (ball.run > 0) ? [CCDirector sharedDirector].winSize.width : 0;
                ceiling = (ball.rise > 0) ? [CCDirector sharedDirector].winSize.height : 0;
                CGPoint dest = [PDMath findBestWallEdge:ball.position knownWallXandCeilingOrFloorY:ccp(wall, ceiling) withSlope:ccp(ball.run, ball.rise)];
                CCAction *moveAction = [CCMoveTo actionWithDuration:((ccpDistance(ball.position, dest))/PTM_RATIO)/(PTM_RATIO * ball.ballSpeed) position:dest];
                moveAction.tag = 2;
                
                [ball runAction:moveAction];
                
                if (self.autoIntelligence) {
                    [paddle stopAllActions];
                    [self movePaddle];
                }
            }
           
        }
        
        //Collision Detection if the ball is bounding off the ceiling or floor
        //Ceiling and Floor
        if (ccpSegmentIntersect(bottomLeftCorner, topLeftCorner, screenBLCorner, screenBRCorner)||
            ccpSegmentIntersect(bottomRightCorner, topRightCorner, screenBLCorner, screenBRCorner)||
            ccpSegmentIntersect(bottomLeftCorner, topLeftCorner, screenTLCorner, screenTRCorner)||
            ccpSegmentIntersect(bottomRightCorner, topRightCorner, screenTLCorner, screenTRCorner)) {
            //This is used to determine if the ball is in a corner
            upDown = YES;
            
            //check to see if the ball is pending a move from the ceiling or floor or corner
            if (![ball getActionByTag:3] && ![ball getActionByTag:4]) {
                //NSLog(@"Impact With Top or Bottom!");
                
                if (ccpSegmentIntersect(bottomLeftCorner, topLeftCorner, screenBLCorner, screenBRCorner)||
                    ccpSegmentIntersect(bottomRightCorner, topRightCorner, screenBLCorner, screenBRCorner)) {
                    NSLog(@"Game Over!");
                    
                    [self removeFromParentAndCleanup:YES];
                    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[TitleScene scene]]];
                }
                
                //Move the ball
                [ball stopActionByTag:1];
                [ball stopActionByTag:2];
                [ball stopActionByTag:5];
                [ball changeDirectionUpDown];
                int wall, ceiling;
                wall = (ball.run > 0) ? [CCDirector sharedDirector].winSize.width : 0;
                ceiling = (ball.rise > 0) ? [CCDirector sharedDirector].winSize.height : 0;
                CGPoint dest = [PDMath findBestWallEdge:ball.position knownWallXandCeilingOrFloorY:ccp(wall, ceiling) withSlope:ccp(ball.run, ball.rise)];
                CCAction *moveAction = [CCMoveTo actionWithDuration:((ccpDistance(ball.position, dest))/PTM_RATIO)/(PTM_RATIO * ball.ballSpeed) position:dest];
                moveAction.tag = 3;
                
                //find out if the ball hit the floor
                
                
                [ball runAction:moveAction];
                if (self.autoIntelligence) {
                    [paddle stopAllActions];
                    [self movePaddle];
                }
            }
        }
        
        //Corners
        if (leftRight && upDown) {
            //Stuck in a corner!
            
            if (![ball getActionByTag:4]) {
                //NSLog(@"I'm Stuck in a corner!");
                
                //Stop any lateral or horizontal moves
                [ball stopActionByTag:1];
                [ball stopActionByTag:2];
                [ball stopActionByTag:3];
                [ball stopActionByTag:5];
                
                int wall, ceiling;
                wall = (ball.run > 0) ? [CCDirector sharedDirector].winSize.width : 0;
                ceiling = (ball.rise > 0) ? [CCDirector sharedDirector].winSize.height : 0;
                CGPoint dest = [PDMath findBestWallEdge:ball.position knownWallXandCeilingOrFloorY:ccp(wall, ceiling) withSlope:ccp(ball.run, ball.rise)];
                CCAction *moveAction = [CCMoveTo actionWithDuration:((ccpDistance(ball.position, dest))/PTM_RATIO)/(PTM_RATIO * ball.ballSpeed) position:dest];
                moveAction.tag = 4;
                [ball runAction:moveAction];
                if (self.autoIntelligence) {
                    [paddle stopAllActions];
                    [self movePaddle];
                }
            }
        }
        
        
    }

    
    //See if the ball needs to change direction based on a block hit
    if (pendingDirectionChange) {
        //Find if the impact happend on the top, bottom, left, or right of the ball.
                
        int isX, isY;
        isX = intersection.origin.x - ball.boundingBox.origin.x;
        isY = intersection.origin.y - ball.boundingBox.origin.y;
        
        if (isX > 0 || isX < 0 || (isX == 0 && isY == 0 && (intersection.size.width < 4))) {
            [ball changeDirectionLeftRight];
        }
        if (isY > 0 || isY < 0 || (isX == 0 && isY == 0 && (intersection.size.width >= 4))) {
            [ball changeDirectionUpDown];
        }
        
        //change the direction of the ball
        if (pendingDirectionChangeUpDown) {
            [ball changeDirectionUpDown];
        }
        if (pendingDirectionChangeLeftRight) {
            [ball changeDirectionLeftRight];
        }
        
        //Move the ball
        int wall, ceiling;
        wall = (ball.run > 0) ? [CCDirector sharedDirector].winSize.width : 0;
        ceiling = (ball.rise > 0) ? [CCDirector sharedDirector].winSize.height : 0;
        CGPoint dest = [PDMath findBestWallEdge:ball.position knownWallXandCeilingOrFloorY:ccp(wall, ceiling) withSlope:ccp(ball.run, ball.rise)];
        
        CCAction *moveAction = [CCMoveTo actionWithDuration:((ccpDistance(ball.position, dest))/PTM_RATIO)/(PTM_RATIO * ball.ballSpeed) position:dest];
        moveAction.tag = 1;
        [ball runAction:moveAction];
        
        if (self.autoIntelligence) {
            [paddle stopAllActions];
            [self movePaddle];
        }
    }
    
    [self updateHUDBlockCount];
    [self updateNewSlope:ccp(ball.run, ball.rise)];
    [self updateHUDBallPosition];
}

-(void)updateHUDBlockCount {
    [_hud.blockCount setString:[NSString stringWithFormat:@"Block Count: %i", _blocks.count]];
}
-(void)updateHUDBallSpeed {
    [_hud.ballSpeed setString:[NSString stringWithFormat:@"Ball Speed: %i mph", ball.ballSpeed]];
}

-(void)updateNewSlope:(CGPoint)newSlope{
    [_hud.nextSlope setString:[NSString stringWithFormat:@"y = (%i / %i)x + %i", (int)newSlope.y , (int)newSlope.x, (int)[PDMath yIntercept:ball.position m:newSlope]]];
}

-(void)updateHUDBallPosition {
    [_hud.oldSlope setString:[NSString stringWithFormat:@"(%i, %i)", (int)ball.position.x, (int)ball.position.y]];
}



-(void)pauseGame {
    
    if (_paused) {
        _paused = NO;
        [self.actionManager resumeTarget:ball];
        [self.actionManager resumeTarget:paddle];
    } else {
        _paused = YES;
        [self.actionManager pauseTarget:ball];
        [self.actionManager pauseTarget:paddle];
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
