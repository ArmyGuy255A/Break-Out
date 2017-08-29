//
//  HelloWorldLayer.m
//  Break Out
//
//  Created by Phillip Dieppa on 6/23/13.
//  Copyright Phillip Dieppa 2013. All rights reserved.
//


// Import the interfaces
#import "TitleScene.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - TitleScene

// HelloWorldLayer implementation
@implementation TitleScene

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	TitleScene *layer = [TitleScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		
		// create and initialize a Label
		//CCLabelTTF *label = [CCLabelTTF labelWithString:@"Breakout" fontName:@"Marker Felt" fontSize:64];
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Breakout" fontName:@"TravelingTypewriter" fontSize:64];
        CCLabelTTF *label2 = [CCLabelTTF labelWithString:@"Northeast High Gaming Academy" fontName:@"TravelingTypewriter" fontSize:32];
		
		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
	
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height * .85 );
        label2.position =  ccp( size.width /2 , size.height * .75 );
		
		// add the label as a child to this Layer
		[self addChild: label];
        [self addChild: label2];
		
		
		
		//
		// Menu Items
		//
		
		// Default font size will be 28 points.
		[CCMenuItemFont setFontSize:28];
		[CCMenuItemFont setFontName:@"TravelingTypewriter"];
		// to avoid a retain-cycle with the menuitem and blocks
		__block id copy_self = self;
		
        // Developer Level Menu Item using blocks
		CCMenuItem *itemDevLevel = [CCMenuItemFont itemWithString:@"Developer Level" block:^(id sender) {
			
			[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[DevLevel scene]]];
            
		}];
        
        // Inequalities Level Menu Item using blocks
		CCMenuItem *itemInequalityLevel = [CCMenuItemFont itemWithString:@"Inequalities" block:^(id sender) {
			
			[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[InequalityLevel scene]]];
            
		}];
        
		// Achievement Menu Item using blocks
		CCMenuItem *itemAchievement = [CCMenuItemFont itemWithString:@"Achievements" block:^(id sender) {
			
			
			GKAchievementViewController *achivementViewController = [[GKAchievementViewController alloc] init];
			achivementViewController.achievementDelegate = copy_self;
			
			AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
			
			[[app navController] presentModalViewController:achivementViewController animated:YES];
			
			[achivementViewController release];
		}];
		
		// Leaderboard Menu Item using blocks
		CCMenuItem *itemLeaderboard = [CCMenuItemFont itemWithString:@"Leaderboard" block:^(id sender) {
			
			
			GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
			leaderboardViewController.leaderboardDelegate = copy_self;
			
			AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
			
			[[app navController] presentModalViewController:leaderboardViewController animated:YES];
			
			[leaderboardViewController release];
		}];

		
		CCMenu *menu = [CCMenu menuWithItems:itemDevLevel, itemInequalityLevel, itemAchievement, itemLeaderboard, nil];
		
		[menu alignItemsVerticallyWithPadding:5];
		[menu setPosition:ccp( size.width/2, size.height/2)];
		
		// Add the menu to the layer
		[self addChild:menu];

        //[self schedule:@selector(tick:) interval:1];
	}
	return self;
}

-(void)tick:(ccTime)dt {
 
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
