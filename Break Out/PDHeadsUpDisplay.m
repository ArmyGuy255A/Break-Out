//
//  PDHeadsUpDisplay.m
//  Tanks
//
//  Created by Phillip Dieppa on 2/4/12.
//  Copyright (c) 2012 WO1. All rights reserved.
//

#import "PDHeadsUpDisplay.h"


@implementation PDHeadsUpDisplay

@synthesize blockCount = _blockCount;
@synthesize oldSlope = _oldSlope;
@synthesize nextSlope = _nextSlope;
@synthesize ballSpeed = _ballSpeed;
@synthesize xp = _xp;


-(id)initWithLayer:(CCLayer *)layer {
    if (self = [super initWithColor:ccc4(255, 0, 0, 0)]) {
        
        //variable initialization
        
        //set bounds
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        [self setContentSize:CGSizeMake(winSize.width, winSize.height)];
        [self setAnchorPoint:ccp(0.5, 0.5)];
        
        //initialize font labels
        //_xp = [CCLabelTTF labelWithString:@"Experience: " fontName:@"TravelingTypewriter" fontSize:15];
        _blockCount = [CCLabelTTF labelWithString:@"Block Count: " fontName:@"TravelingTypewriter" fontSize:15];
        _oldSlope = [CCLabelTTF labelWithString:@"(0, 0)" fontName:@"TravelingTypewriter" fontSize:20];
        _nextSlope = [CCLabelTTF labelWithString:@"y = mx + b" fontName:@"TravelingTypewriter" fontSize:20];
        _ballSpeed = [CCLabelTTF labelWithString:@"Ball Speed: " fontName:@"TravelingTypewriter" fontSize:15];
        
        /*
         Label positions
         LEVEL:X  XP:X  KILLS:X  HP:X  ENEMIES:X
         */
        float widthInterval = winSize.width / 5;
        float labelHeight = winSize.height * .02;
        
        
        [_blockCount setPosition:ccp(widthInterval * 1, labelHeight)];
        //[_xp setPosition:ccp(widthInterval * 2, labelHeight)];
        
        CCLabelTTF *oldSlopeTitle = [CCLabelTTF labelWithString:@"Ball Position" fontName:@"TravelingTypewriter" fontSize:25];
        [oldSlopeTitle setPosition:ccp(widthInterval * 1.5, labelHeight*16)];
        [_oldSlope setPosition:ccp(widthInterval * 1.5, labelHeight*14)];
        
        CCLabelTTF *nextSlopeTitle = [CCLabelTTF labelWithString:@"Current Slope" fontName:@"TravelingTypewriter" fontSize:25];
        [nextSlopeTitle setPosition:ccp(widthInterval * 3.5, labelHeight*16)];
        [_nextSlope setPosition:ccp(widthInterval * 3.5, labelHeight*14)];
        [_ballSpeed setPosition:ccp(widthInterval * 4, labelHeight)];

        
        
        //[self addChild:_xp];
        [self addChild:_blockCount];
        [self addChild:oldSlopeTitle];
        [self addChild:_oldSlope];
        [self addChild:nextSlopeTitle];
        [self addChild:_nextSlope];
        [self addChild:_ballSpeed];
    }
    
    return self;
}


@end
