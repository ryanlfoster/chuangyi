//
//  AppDelegate.m
//  magzine2
//
//  Created by hongquan on 1/24/13.
//  Copyright (c) 2013 hongquan. All rights reserved.
//

#import "AppDelegate.h"
#import "Publisher.h"
#import <UAirship.h>
#import <UAPush.h>
#import "MagazineObject.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSMutableDictionary *airshipConfigOptions = [[NSMutableDictionary alloc] init] ;
    [airshipConfigOptions setValue:@"iURU4alcSGaP-fAxOkJFHQ" forKey:@"DEVELOPMENT_APP_KEY"];
    [airshipConfigOptions setValue:@"HakiEbkPSte4ptnTNywpsw" forKey:@"DEVELOPMENT_APP_SECRET"];
    [airshipConfigOptions setValue:@"aq9jLwIFTACGtQICgcVauQ" forKey:@"PRODUCTION_APP_KEY"];
    [airshipConfigOptions setValue:@"-e_K17WjR3iQMSiToYjIFA" forKey:@"PRODUCTION_APP_SECRET"];
    
#ifdef DEBUG
    [[NSUserDefaults standardUserDefaults]setBool: YES forKey:@"NKDontThrottleNewsstandContentNotifications"];
    [airshipConfigOptions setValue:@"NO" forKey:@"APP_STORE_OR_AD_HOC_BUILD"];
#else
    [airshipConfigOptions setValue:@"YES" forKey:@"APP_STORE_OR_AD_HOC_BUILD"];
#endif
    //Create Airship options dictionary and add the required UIApplication launchOptions
    NSMutableDictionary *takeOffOptions = [NSMutableDictionary dictionary];
    [takeOffOptions setValue:launchOptions forKey:UAirshipTakeOffOptionsLaunchOptionsKey];
    [takeOffOptions setValue:airshipConfigOptions forKey:UAirshipTakeOffOptionsAirshipConfigKey];

    // Call takeOff (which creates the UAirship singleton), passing in the launch options so the
    // library can properly record when the app is launched from a push notification. This call is
    // required.
    //
    // Populate AirshipConfig.plist with your app's info from https://go.urbanairship.com
    [UAirship takeOff:takeOffOptions];
    
    // Set the icon badge to zero on startup (optional)
    [[UAPush shared] resetBadge];
    
    // Register for remote notfications with the UA Library. This call is required.
    [[UAPush shared] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                         UIRemoteNotificationTypeSound |
                                                         UIRemoteNotificationTypeAlert |
                                                         UIRemoteNotificationTypeNewsstandContentAvailability)];
    
    // Handle any incoming incoming push notifications.
    // This will invoke `handleBackgroundNotification` on your UAPushNotificationDelegate.
    [[UAPush shared] handleNotification:[launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey] applicationState:application.applicationState];
    NSLog(@"launch");
    NSDictionary *payload = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    [self handlePayload:payload];
    // Override point for customization after application launch.
    return YES;
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Updates the device token and registers the token with UA.
    [[UAPush shared] registerDeviceToken:deviceToken];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[UAPush shared] handleNotification:userInfo applicationState:application.applicationState];
    [[UAPush shared] resetBadge]; // zero badge after push received
     
    
    // Now check if it is new content; if so we show an alert
    [self handlePayload:userInfo];
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
    [UAirship land];

    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)handlePayload:(NSDictionary *)payload
{
    NSLog(@"%@",payload);
    NSDictionary *issue = [payload objectForKey:@"issue"];
    [Publisher sharedPublisher].content_available = [issue objectForKey:@"name"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"content-available" object:nil userInfo:issue];
}

@end
