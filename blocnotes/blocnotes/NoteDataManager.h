//
//  NoteDataManager.h
//  blocnotes
//
//  Created by Dorian Kusznir on 5/28/15.
//  Copyright (c) 2015 dkusznir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NoteDataManager : NSObject <NSFetchedResultsControllerDelegate>

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (assign, nonatomic) BOOL iCloudConnectivityDidChange;

+ (instancetype)sharedInstance;

- (NSURL *)applicationDocumentsDirectory;
- (void)saveContext;
- (void)deleteCache;
- (NSArray *)getNotes;
- (NSPersistentStoreCoordinator *)setPersistentStore;

@end
