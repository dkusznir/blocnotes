//
//  ShareViewController.m
//  blocnotesShare
//
//  Created by Dorian Kusznir on 6/1/15.
//  Copyright (c) 2015 dkusznir. All rights reserved.
//

#import "ShareViewController.h"
#import "NoteDataManager.h"

@interface ShareViewController ()

@end

@implementation ShareViewController

- (BOOL)isContentValid {
    // Do validation of contentText and/or NSExtensionContext attachments here
    return YES;
}

- (void)didSelectPost {
    // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
    // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
    NSManagedObjectContext *context = [[NoteDataManager sharedInstance].fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[[NoteDataManager sharedInstance].fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    [newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
    [newManagedObject setValue:@"IMPORTED" forKey:@"noteTitle"];
    [newManagedObject setValue:self.contentText forKey:@"content"];
    
    NSError *error;
    [context save:&error];
    
    if ( error )
    {
        NSLog(@"We failed to save our note changes. Error: %@", [error description]);
    }
    
    [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
    
    [[NoteDataManager sharedInstance] deleteCache];

}

- (NSArray *)configurationItems {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    return @[];
}

@end
