//
//  PDPaddle.m
//  Break Out
//
//  Created by Phillip Dieppa on 6/28/13.
//  Copyright 2013 Phillip Dieppa. All rights reserved.
//

#import "PDPaddle.h"
#import "PDTypes.h"


@implementation PDPaddle
@synthesize impactBlocks;
@synthesize isMovingLeft;
@synthesize isMovingRight;


-(id)initWithLayer:(CCLayer *)layer {
    if ((self = [super initWithFile:@"paddle.png"])) {
        
        self.tag = kPDTagTypePaddle;
        [self setZOrder:1];

        isMovingLeft = NO;
        isMovingRight = NO;
        //[self setContentSize:CGSizeMake(150, 30)];
        //build the impact blocks
        
        /*
         rect1  -   1/-2
         rect2  -   1/-1
         rect3  -   2/-1
         rect4  -   5/-1
         rect5  -   10/-1
         rect6  -   10000/-1
         rect7  -   10000/1
         rect8  -   10/1
         rect9  -   5/1
         rect10 -   2/1
         rect11 -   1/1
         rect12 -   1/2
         
         <--rect1 ------------------ rect12-->
          __ __ __ __ __ __ __ __ __ __ __ __
         |__|__|__|__|__|__|__|__|__|__|__|__|
        */
        
        CGPoint rect1  = ccp(-2, 1);
        CGPoint rect2  = ccp(1, 1);
        CGPoint rect3  = ccp(1, 2);
        CGPoint rect4  = ccp(1, 5);
        CGPoint rect5  = ccp(1, 10);
        CGPoint rect6  = ccp(1, 10000);
        CGPoint rect7  = ccp(1, 10000);
        CGPoint rect8  = ccp(1, 10);
        CGPoint rect9  = ccp(1, 5);
        CGPoint rect10 = ccp(1, 2);
        CGPoint rect11 = ccp(1, 1);
        CGPoint rect12 = ccp(-2, 1);
        [impactBlocks addObject:[NSValue valueWithCGPoint:ccp(0, 0)]];
        //how many rects are there?
        int rects = 12;
        impactBlocks = [NSMutableArray arrayWithObjects:[NSValue valueWithCGPoint:rect1],
                        [NSValue valueWithCGPoint:rect2],
                        [NSValue valueWithCGPoint:rect3],
                        [NSValue valueWithCGPoint:rect4],
                        [NSValue valueWithCGPoint:rect5],
                        [NSValue valueWithCGPoint:rect6],
                        [NSValue valueWithCGPoint:rect7],
                        [NSValue valueWithCGPoint:rect8],
                        [NSValue valueWithCGPoint:rect9],
                        [NSValue valueWithCGPoint:rect10],
                        [NSValue valueWithCGPoint:rect11],
                        [NSValue valueWithCGPoint:rect12],
                        nil];
        
        //impact block size;
        CGSize rectSize = CGSizeMake(self.contentSize.width/rects, self.contentSize.height);
        
        for (int x = 0; x < rects; x++) {
            //create the impact blocks
            CCSprite *spr = [self blankSpriteWithSize:rectSize];
            //CCSprite *spr = [CCSprite spriteWithFile:@"blank.png"];
            [self addChild:spr z:2];
            float asdf = (rectSize.width * x);
            [spr setPosition:ccp(asdf, 0)];
            ccColor3B color = {0, (rects * x^2), 255 - ( rects * x^2)};
            [spr setColor:color];
            spr.opacity = 0;
            [impactBlocks insertObject:spr atIndex:rects + x];
            
        }
        
    }
    [impactBlocks retain];
    return self;
}

- (CCSprite*)blankSpriteWithSize:(CGSize)size
{
    CCSprite *sprite = [CCSprite node];
    GLubyte *buffer = malloc(sizeof(GLubyte)*4);
    for (int i=0;i<4;i++) {buffer[i]=255;}
    CCTexture2D *tex = [[CCTexture2D alloc] initWithData:buffer pixelFormat:kCCTexture2DPixelFormat_RGB5A1 pixelsWide:1 pixelsHigh:1 contentSize:size];
    [sprite setTexture:tex];
    [sprite setTextureRect:CGRectMake(0, 0, size.width, size.height)];
    [sprite setAnchorPoint:ccp(0, 0)];
    free(buffer);
    return sprite;
}

-(void)dealloc {
    [impactBlocks release];
    [super dealloc];
}

@end
