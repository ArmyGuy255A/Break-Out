//
//  PDHeadsUpDisplay.h
//  Tanks
//
//  Created by Phillip Dieppa on 2/4/12.
//  Copyright (c) 2012 WO1. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PDPlayer;
@interface PDHeadsUpDisplay : CCLayerColor {
    //class variables
    CCLabelBMFont *_blockCount;
    CCLabelBMFont *_oldSlope;
    CCLabelBMFont *_nextSlope;
    CCLabelBMFont *_ballSpeed;
    CCLabelBMFont *_xp;
}
//global properties
@property (assign) CCLabelBMFont *blockCount;
@property (assign) CCLabelBMFont *oldSlope;
@property (assign) CCLabelBMFont *nextSlope;
@property (assign) CCLabelBMFont *ballSpeed;
@property (assign) CCLabelBMFont *xp;

//class methods
-(id)initWithLayer:(CCLayer *)layer;

@end
