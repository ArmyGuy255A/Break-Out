//
//  PDHeadsUpDisplay.m
//  Tanks
//
//  Created by Phillip Dieppa on 2/4/12.
//  Copyright (c) 2012 WO1. All rights reserved.
//

#import "PDHUDInequality.h"


@implementation PDHUDInequality

@synthesize ballPosition = _ballPosition;
@synthesize ballSize = _ballSize;
@synthesize screenSize = _screenSize;
@synthesize iqLeft, iqRight, iqTop, iqBottom, iqLeftA, iqRightA, iqTopA, iqBottomA;



-(id)initWithLayer:(CCLayer *)layer {
    if (self = [super initWithColor:ccc4(255, 0, 0, 0)]) {
        
        //variable initialization
        
        //set bounds
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        [self setContentSize:CGSizeMake(winSize.width, winSize.height)];
        [self setAnchorPoint:ccp(0.5, 0.5)];
        
        
        NSMutableArray *iqLeftLabels = [[NSMutableArray alloc] init];
        NSMutableArray *iqRightLabels = [[NSMutableArray alloc] init];
        NSMutableArray *iqTopLabels = [[NSMutableArray alloc] init];
        NSMutableArray *iqBottomLabels = [[NSMutableArray alloc] init];
        //Inequality Expressions
        iqLeft = [CCLabelTTF labelWithString:@"x > r" fontName:@"Times New Roman" fontSize:20];
        iqLeftA = [CCLabelTTF labelWithString:@"adsf" fontName:@"Times New Roman" fontSize:16];
        iqRight = [CCLabelTTF labelWithString:@"x < w - r" fontName:@"Times New Roman" fontSize:20];
        iqRightA = [CCLabelTTF labelWithString:@"asdf" fontName:@"Times New Roman" fontSize:16];
        iqTop = [CCLabelTTF labelWithString:@"y < h - r" fontName:@"Times New Roman" fontSize:20];
        iqTopA = [CCLabelTTF labelWithString:@"asdf" fontName:@"Times New Roman" fontSize:16];
        iqBottom = [CCLabelTTF labelWithString:@"y > r" fontName:@"Times New Roman" fontSize:20];
        iqBottomA = [CCLabelTTF labelWithString:@"adsf" fontName:@"Times New Roman" fontSize:16];
        
        //ADD LABELS TO AN ARRAY AND ADD THEM USING THE FUNCTION
        [iqLeftLabels addObject:iqLeft];
        [iqLeftLabels addObject:iqLeftA];
        [self setLabelPositionsInArray:iqLeftLabels startX:winSize.width*.1 startY:winSize.height/2 withAngle:0];
        
        [iqRightLabels addObject:iqRight];
        [iqRightLabels addObject:iqRightA];
        [self setLabelPositionsInArray:iqRightLabels startX:winSize.width*.9 startY:winSize.height/2 withAngle:0];
        
        [iqTopLabels addObject:iqTop];
        [iqTopLabels addObject:iqTopA];
        [self setLabelPositionsInArray:iqTopLabels startX:winSize.width/2 startY:winSize.height*.9 withAngle:0];
        
        [iqBottomLabels addObject:iqBottom];
        [iqBottomLabels addObject:iqBottomA];
        [self setLabelPositionsInArray:iqBottomLabels startX:winSize.width/2 startY:winSize.height*.1 withAngle:0];
        
        
        CCLabelTTF *ballPosition = [CCLabelTTF labelWithString:@"Ball Position" fontName:@"Times New Roman" fontSize:25];
        _ballPosition = [CCLabelTTF labelWithString:@"x = 0    y = 0" fontName:@"Times New Roman" fontSize:20];
        CCLabelTTF *ballSize = [CCLabelTTF labelWithString:@"Ball Size" fontName:@"Times New Roman" fontSize:25];
        _ballSize = [CCLabelTTF labelWithString:@"Width: Height: Radius:" fontName:@"Times New Roman" fontSize:20];
        CCLabelTTF *screenSize = [CCLabelTTF labelWithString:@"Screen Size" fontName:@"Times New Roman" fontSize:25];
        _screenSize = [CCLabelTTF labelWithString:@"Screen Size" fontName:@"Times New Roman" fontSize:20];
        
        NSMutableArray *ballLabels = [[NSMutableArray alloc] init];
        [ballLabels addObject:ballPosition];
        [ballLabels addObject:_ballPosition];
        [ballLabels addObject:ballSize];
        [ballLabels addObject:_ballSize];
        [ballLabels addObject:screenSize];
        [ballLabels addObject:_screenSize];
        
        [self setLabelPositionsInArray:ballLabels startX:winSize.width/2 startY:winSize.height*.4 withAngle:0];
        
    }
    
    return self;
}

-(void)setLabelPositionsInArray:(NSMutableArray *)labels startX:(int)x startY:(int)y withAngle:(float)angle {
    
    CCLabelTTF *label;
    NSEnumerator *e = [labels objectEnumerator];
    int lastX, lastY;
    lastX = x;
    lastY = y;
    
    while ((label = [e nextObject]) != nil) {
        
        if (angle == 0) {
            //Normal Orientation
            [label setPosition:ccp(lastX, lastY - label.contentSize.height)];
            
        }
        
        if (angle == 90) {
            //Text Reading from Bottom to Top
            [label setPosition:ccp(lastX - label.contentSize.height, lastY)];
            
        }
        
        if (angle == 270) {
            //Text Reading from Top to Bottom
            [label setPosition:ccp(lastX + label.contentSize.height, lastY)];
        }
        
        [label setRotation:angle];
        lastX = label.position.x;
        lastY = label.position.y;
        [self addChild:label];
    }
        
}


@end
