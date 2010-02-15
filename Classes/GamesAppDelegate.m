//
//  GamesAppDelegate.m
//  Games
//
//  Created by Jason Perry on 2/12/10.
//  Copyright 2010 Ambethia. All rights reserved.
//

#import "GamesAppDelegate.h"
#import "BoardUIView.h"
#import "Game.h"
#import "Player.h"
#import "QuartzUtils.h"


@implementation GamesAppDelegate

@synthesize window = _window;
@synthesize view = _view;


- (void)applicationDidFinishLaunching:(UIApplication*)application
{
    srandom(time(NULL));
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    _window.layer.backgroundColor = GetCGPatternNamed(@"Background.png");
    
    self.view = [[[BoardUIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]] autorelease];
    [_window addSubview:_view];
    
    [self startGameNamed:@"MemoryGame"];
    
    [_window makeKeyAndVisible];
}


- (void)dealloc
{
    [_view release];
    [_window release];
    [super dealloc];
}


- (void)startGameNamed:(NSString*)gameClassName
{
    Game* game = _view.game;
    
    if (gameClassName == nil)
    {
        gameClassName = [[game class] description];
    }
    
    [_view startGameNamed:gameClassName];
}

@end
