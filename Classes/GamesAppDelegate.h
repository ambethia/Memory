//
//  GamesAppDelegate.h
//  Games
//
//  Created by Jason Perry on 2/12/10.
//  Copyright 2010 Ambethia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BoardUIView;


@interface GamesAppDelegate : NSObject <UIApplicationDelegate>
{
    UIWindow* _window;
    BoardUIView* _view;
}

@property (nonatomic, retain) IBOutlet UIWindow* window;
@property (nonatomic, retain) BoardUIView* view;

- (void)startGameNamed:(NSString*)gameClassName;

@end
