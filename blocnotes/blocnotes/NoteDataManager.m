//
//  NoteDataManager.m
//  blocnotes
//
//  Created by Dorian Kusznir on 5/28/15.
//  Copyright (c) 2015 dkusznir. All rights reserved.
//

#import "NoteDataManager.h"

@interface NoteDataManager()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) id currentiCloudToken;

@end

@implementation NoteDataManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil)
    {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Body" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error])
    {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}


#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory
{
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.dkusznir.blocnotes" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel
{
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"blocnotes" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    //NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"blocnotes.sqlite"];
    _persistentStoreCoordinator = [self setPersistentStore];
    
    return _persistentStoreCoordinator;
}

- (NSPersistentStoreCoordinator *)setPersistentStore
{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
                             nil];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"iCloudSetting"] == YES)
    {
        NSMutableDictionary *addiCloud = [NSMutableDictionary dictionaryWithDictionary:options];
        [addiCloud setObject:[NSString stringWithFormat:@"MyAppCloudStore"] forKey:NSPersistentStoreUbiquitousContentNameKey];
        options = addiCloud;
    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.dkusznir.blocnotes"];
    storeURL = [storeURL URLByAppendingPathComponent:@"blocnotes.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])
    {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    NSLog(@"PS: %@", _persistentStoreCoordinator);
    return _persistentStoreCoordinator;

}

- (NSManagedObjectContext *)managedObjectContext
{
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator)
    {
        return nil;
    }
    
    else
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
        [self observeCloudActions:coordinator];
    }

    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext
{
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }

    }
}

- (void)deleteCache
{
    [NSFetchedResultsController deleteCacheWithName:@"Master"];
}

- (NSArray *)getNotes
{
    NSArray *noteTitles = [NSArray array];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Body" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:entity];
    [request setResultType:NSDictionaryResultType];
    
    NSError *error;
    noteTitles = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    for (int i = 0; i < noteTitles.count; i++)
    {
        NSLog(@"%@", noteTitles[i]);
    }
    
    return noteTitles;
    
}
#pragma mark - iCloud Core Data Notification Methods

- (void)observeCloudActions:(NSPersistentStoreCoordinator *)coordinator
{
    NSNotificationCenter *notifications = [NSNotificationCenter defaultCenter];
    
    [notifications addObserver:self
                      selector:@selector(storesDidChange:)
                          name:NSPersistentStoreCoordinatorStoresDidChangeNotification
                        object:coordinator];
    
    [notifications addObserver:self
                      selector:@selector(storesWillChange:)
                          name:NSPersistentStoreCoordinatorStoresWillChangeNotification
                        object:coordinator];
    
    [notifications addObserver:self
                      selector:@selector(storesDidImportContent:)
                          name:NSPersistentStoreDidImportUbiquitousContentChangesNotification
                        object:coordinator];
}

- (void)storesWillChange:(NSNotification *)notification
{
    NSManagedObjectContext *context = self.managedObjectContext;
    
    [context performBlockAndWait:^{
        if ([context hasChanges])
        {
            [self saveContext];
        }
        
        [context reset];
    }];
    
    self.iCloudConnectivityDidChange = YES;
    
}

- (void)storesDidChange:(NSNotification *)notification
{
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    self.iCloudConnectivityDidChange = YES;
    
}

- (void)storesDidImportContent:(NSNotification *)notification
{
    NSManagedObjectContext *context = self.managedObjectContext;
    
    [context performBlock:^{
        NSLog(@"Importing content");
        
        [context mergeChangesFromContextDidSaveNotification:notification];
    }];
    
    self.iCloudConnectivityDidChange = NO;
}

@end
