//
//  AppDelegate.m
//  touch
//
//  Created by Ariel Xin on 1/10/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

#import "AppDelegate.h"
#import "IntroViewController.h"
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import "CustomTabBar.h"
#import "LoginViewController.h"
#import "User.h"
#import "ActivityViewController.h"
#import "MineInfoViewController.h"
#import "NewInfoViewController.h"
#import "chatViewController.h"

@interface AppDelegate () <ICETutorialControllerDelegate>
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [Parse enableLocalDatastore];
    
    // Initialize Parse.
    [Parse setApplicationId:@"8428ZqzEOt8YKpxnyfUtNJIF7wjWoGmGSBzDTGyV"
                  clientKey:@"zOgywuFz7u9YAXWgpkPJsPlhKbBvGDYwyg5YuKSe"];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
 
    self.window.backgroundColor = [UIColor whiteColor];
    NSLog(@" window frame  %@",NSStringFromCGRect([[UIScreen mainScreen]bounds]));
    
   [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:247/255.0f green:240/255.0f blue:225/255.0f alpha:1.0f]];
    
    //If user haven't logged in, open the app with intro pages
    if(![[User currentUser] isLogined])
        [self goToIntro];
    //If user already logged in, go to the main page directly
    else
        [self createTabBar];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


-(void)createTabBar{
    //Navigate to news feed
    ActivityViewController *activity = [[ActivityViewController alloc] initWithNibName:@"ActivityViewController" bundle:nil];
    UINavigationController *activityNav=[[UINavigationController alloc] initWithRootViewController:activity];
    
    //Navigate to notification center
    NewInfoViewController *newInfo = [[NewInfoViewController alloc] initWithNibName:@"NewInfoViewController" bundle:nil];    UINavigationController *newInfoNav=[[UINavigationController alloc] initWithRootViewController:newInfo];
    
    //Navigate to chatting list, we don't plan to implement this part this quarter
    chatViewController *chatController = [[chatViewController alloc] init];
    UINavigationController *chatNav = [[UINavigationController alloc] initWithRootViewController:chatController];

    //Navigate to personal homepage
    MineInfoViewController *mineInfo = [[MineInfoViewController alloc] initWithNibName:@"MineInfoViewController" bundle:nil];
    UINavigationController *mineInfoNav=[[UINavigationController alloc] initWithRootViewController:mineInfo];

    NSArray *tabbarArray = [[NSArray alloc] initWithObjects:activityNav, newInfoNav, chatNav, mineInfoNav, nil];
    
    self.tabBarController = [[CustomTabBar alloc] init];
    self.tabBarController.viewControllers = tabbarArray;
    [self.tabBarController setSelectedTag:0];
    self.window.rootViewController = self.tabBarController;
    
}

+ (AppDelegate *)delegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}


- (void)goToIntro{
    IntroViewController *introView = [[IntroViewController alloc] init];
    self.window.rootViewController = introView;
    [self.window makeKeyAndVisible];

}

-(void) goToLogin{
    LoginViewController *loginView = [[LoginViewController alloc] init];
    self.window.rootViewController = loginView;
    [self.window makeKeyAndVisible];
}

- (void)showTabBar{
    if (self.tabBarController) {
        [self.tabBarController showCustomTabBar];
    }
}

- (void)selectTab:(NSInteger)tab {
    [self.tabBarController setSelectedTag:tab];
}

- (void)hideTabBar{
    //if (self.tabBarController)
        [self.tabBarController hideCustomTabBar];
        [self.tabBarController hideRealTabBar];
}

@end


