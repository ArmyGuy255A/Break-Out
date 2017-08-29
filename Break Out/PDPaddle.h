//
//  PDPaddle.h
//  Break Out
//
//  Created by Phillip Dieppa on 6/28/13.
//  Copyright 2013 Phillip Dieppa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDTypes.h"

@interface PDPaddle : CCSprite {
    //CGRect _rect1, _rect2, _rect3, _rect4, _rect5, _rect6, _rect7, _rect8, _rect9, _rect10, _rect11, _rect12;
}

@property (assign) bool isMovingLeft, isMovingRight;
@property (nonatomic, retain) NSMutableArray *impactBlocks;
-(id)initWithLayer:(CCLayer *)layer;


@end
