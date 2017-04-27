//
//  AppDelegate.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/4/14.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "AppDelegate.h"

#import "CommonsDefines.h"
#import "ViewController.h"
#import "LoginViewController.h"
#import "SlideNavigationController.h"
#import "MenuViewController.h"
#import <IQKeyboardManager.h>
#import <UIImage-Helpers.h>

#define ROOTCONTROLLER [UIApplication sharedApplication].keyWindow.rootViewController

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enable = YES;
    keyboardManager.enableAutoToolbar = NO;
    keyboardManager.shouldResignOnTouchOutside = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkUserState:) name:@"LoginStateDidChanged" object:nil];
    ViewController *mainController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MainView"];
    SlideNavigationController *navigationController = [[SlideNavigationController alloc] initWithRootViewController:mainController];
    MenuViewController *leftViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Menu"];
    [SlideNavigationController sharedInstance].leftMenu = leftViewController;
    [SlideNavigationController sharedInstance].menuRevealAnimationDuration = 0.25;
    [SlideNavigationController sharedInstance].enableShadow = YES;
    [SlideNavigationController sharedInstance].enableSwipeGesture = YES;
    [SlideNavigationController sharedInstance].avoidSwitchingToSameClassViewController = YES;
    [SlideNavigationController sharedInstance].portraitSlideOffset = CGRectGetWidth([UIScreen mainScreen].bounds) * 0.3;
    self.window.rootViewController = navigationController;
    
    [self.window makeKeyAndVisible];
    
    [self checkUserState:nil];
    [self initAppearance];
    
    return YES;
    
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LoginStateDidChanged" object:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)checkUserState:(NSNotification *)notification {
    if (![[NSUserDefaults standardUserDefaults] objectForKey:USERTOKEN]) {
        LoginViewController *loginViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Login"];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
        [ROOTCONTROLLER presentViewController:navigationController animated:NO completion:nil];
    }
    
}
- (void)initAppearance {
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : TABBAR_TITLE_COLOR} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : NAVIGATIONBAR_COLOR} forState:UIControlStateSelected];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                           NSFontAttributeName : kBoldSystemFont(18)}];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:NAVIGATIONBAR_COLOR] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
}



@end
