//
//  PDHeadsUpDisplay.h
//  Tanks
//
//  Created by Phillip Dieppa on 2/4/12.
//  Copyright (c) 2012 WO1. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PDPlayer;
@interface PDHUDInequality : CCLayerColor {
    //class variables
    CCLabelBMFont *_ballPosition, *_ballSize, *_screenSize;
    //CCLabelBMFont *_iqLeft, *_iqRight, *_iqTop, *_iqBottom;



}
//global properties
@property (assign) CCLabelBMFont *ballPosition, *ballSize, *screenSize;
@property (assign) CCLabelBMFont *iqLeft, *iqRight, *iqTop, *iqBottom, *iqLeftA, *iqRightA, *iqTopA, *iqBottomA;

//class methods
-(id)initWithLayer:(CCLayer *)layer;

-(void)setLabelPositionsInArray:(NSMutableArray *)labels startX:(int)x startY:(int)y withAngle:(float)angle;
@end
