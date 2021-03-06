//
//  AppDelegate.m
//  blocnotes
//
//  Created by Dorian Kusznir on 5/15/15.
//  Copyright (c) 2015 dkusznir. All rights reserved.
//

#import "AppDelegate.h"
#import "DetailViewController.h"
#import "MasterViewController.h"
#import "NoteDataManager.h"

@interface AppDelegate () <UISplitViewControllerDelegate>

@property (strong, nonatomic) id currentiCloudToken;
@property (strong, nonatomic) MasterViewController *controller;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
    navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
    splitViewController.delegate = self;

    UINavigationController *masterNavigationController = splitViewController.viewControllers[0];
    self.controller = (MasterViewController *)masterNavigationController.topViewController;

    NSFileManager *fileManager = [NSFileManager defaultManager];
    self.currentiCloudToken = fileManager.ubiquityIdentityToken;
    
    NSLog(@"iCloud Token: %@", self.currentiCloudToken);
    
    if (self.currentiCloudToken)
    {
        NSData *newTokenData = [NSKeyedArchiver archivedDataWithRootObject:self.currentiCloudToken];
        [[NSUserDefaults standardUserDefaults] setObject:newTokenData forKey:@"com.apple.blocnotes.UbiquityIdentityToken"];
    }
    
    else
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"com.apple.blocnotes.UbiquityIdentityToken"];
    }
    

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
    [[NoteDataManager sharedInstance] saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"hasLaunchedOnce"])
    {
        NSLog(@"Existing user");
    }
    
    else
    {
        if (self.currentiCloudToken)
        {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasLaunchedOnce"];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Choose Storage Option", @"Storage Option Title") message:NSLocalizedString(@"Should notes be stored in iCloud and available on all of your devices?", @"Storage Option Message") preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *iCloudEnabled = [UIAlertAction actionWithTitle:NSLocalizedString(@"Yes", @"Yes Option") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSLog(@"YES CLICKED");
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"iCloudSetting"];
                [[NoteDataManager sharedInstance] setPersistentStore];
            }];
            
            UIAlertAction *iCloudDisabled = [UIAlertAction actionWithTitle:NSLocalizedString(@"No", @"No Option") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSLog(@"NO CLICKED");
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"iCloudSetting"];
            }];
                        
            [alert addAction:iCloudEnabled];
            [alert addAction:iCloudDisabled];
            [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
        }
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [[NoteDataManager sharedInstance] saveContext];
}

#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController
{
    if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[DetailViewController class]] && ([(DetailViewController *)[(UINavigationController *)secondaryViewController topViewController] detailItem] == nil))
    {
        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        return YES;
    }
    
    else
    {
        return NO;
    }
}

#pragma mark - iCloud Set-Up


@end
