//
//  SAAppDelegate.m
//  dktravel
//
//  Created by Kenichi Nakamura on 4/24/13.
//  Copyright (c) 2013 sa. All rights reserved.
//

#import "SAAppDelegate.h"
#import "SAViewController.h"
#import "AGSGeotriggerAPIClient.h"
#import "MBProgressHUD.h"

@implementation SAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[SAViewController alloc] initWithNibName:@"SAViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    self.geotriggerManager = [[AGSGeotriggerManager alloc] initWithClientID:@"PUT SOMETHING HERRE"
                                                                andDelegate:self
                                                                 andProfile:AGSTrackingProfileAdaptive];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [self.geotriggerManager.device registerDeviceToken:deviceToken withMode:AGSPushNotificationEnvironmentSandbox];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Failed to register for push notifications: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"Received push notification: %@", userInfo);
    [[[UIAlertView alloc] initWithTitle:@"DKTravel Entry!"
                                message:[userInfo valueForKey:@"text"]
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
    
}

- (void)managerDidBecomeReady:(AGSGeotriggerManager *)manager
{
    [manager.device registerForPushNotifications:UIRemoteNotificationTypeAlert];
    
    AGSGeotriggerAPIClient *apic = [[AGSGeotriggerAPIClient alloc] initWithDevice:manager.device];
    
    NSDictionary *params = @{@"addTags": @"berlin"};
    
    [apic runPost:@"device/update" withParameters:params
          success:^(NSURLRequest *req, NSHTTPURLResponse *res, id JSON) {
              NSLog(@"w00t: %@", JSON);
          }
          failure:^(NSURLRequest *req, NSHTTPURLResponse *res, NSError *error, id JSON) {
              NSLog(@"shitballs: %@", error);
          }
     ];
}

@end
