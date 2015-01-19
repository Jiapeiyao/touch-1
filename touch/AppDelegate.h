//
//  AppDelegate.h
//  touch
//
//  Created by Ariel Xin on 1/10/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTabBar.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CustomTabBar *tabBarController;

+ (AppDelegate *)delegate;

- (void)goToIntro;
- (void)createTabBar;
- (void)showTabBar;

@end

