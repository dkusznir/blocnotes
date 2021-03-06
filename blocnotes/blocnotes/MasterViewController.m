//
//  MasterViewController.m
//  blocnotes
//
//  Created by Dorian Kusznir on 5/15/15.
//  Copyright (c) 2015 dkusznir. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "NoteDataManager.h"

@interface MasterViewController () <UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) BOOL isNew;
@property (nonatomic, strong) NSArray *filteredList;
@property (nonatomic, strong) NSFetchRequest *searchFetchRequest;
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    [self setUpSearchController];
    
    [[NoteDataManager sharedInstance] addObserver:self forKeyPath:@"iCloudConnectivityDidChange" options:0 context:nil];
    [[NoteDataManager sharedInstance] getNotes];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"iCloudConnectivityDidChange"])
    {
        NSLog(@"iCloud connectivity changed - reloading data.");
        [self reloadAllData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    self.isNew = YES;
    [self performSegueWithIdentifier:@"showDetail" sender:sender];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"])
    {
        if (self.isNew == YES)
        {
            NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
            NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
            NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
            
            DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
            [controller setDetailItem:newManagedObject];
            controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
            controller.navigationItem.leftItemsSupplementBackButton = YES;
        }
        
        else
        {
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            NSManagedObject *object = nil;
            
            if (self.searchController.active && self.filteredList != nil)
            {
                object = [self.filteredList objectAtIndex:indexPath.row];
            }
            
            else
            {
                object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
            }
            
            DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
            [controller setDetailItem:object];
            controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
            controller.navigationItem.leftItemsSupplementBackButton = YES;
            
        }

    }
    
    self.isNew = NO;
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchController.active && self.filteredList != nil)
    {
        return [self.filteredList count];
    }
    
    else
    {
        id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
        return [sectionInfo numberOfObjects];
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
            
        NSError *error = nil;
        if (![context save:&error])
        {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = nil;
    
    if (self.searchController.active && self.filteredList != nil)
    {
        object = [self.filteredList objectAtIndex:indexPath.row];
    }
    
    else
    {
        object = [self.fetchedResultsController objectAtIndexPath:indexPath];

    }
    
    if ([[object valueForKey:@"noteTitle"] description] == nil)
    {
        cell.textLabel.text = [[object valueForKey:@"content"] description];
    }
    
    else
    {
        cell.textLabel.text = [[object valueForKey:@"noteTitle"] description];
    }
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    _fetchedResultsController = [[NoteDataManager sharedInstance] fetchedResultsController];
    _fetchedResultsController.delegate = self;
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

#pragma mark - Set Up Search Controller

- (void)setUpSearchController
{
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    
    self.searchController.searchBar.delegate = self;
    //self.searchController.hidesNavigationBarDuringPresentation = NO;
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;
}

- (NSFetchRequest *)searchFetchRequest
{
    if (_searchFetchRequest != nil)
    {
        return _searchFetchRequest;
    }
    
    _searchFetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Body" inManagedObjectContext:self.fetchedResultsController.managedObjectContext];
    [_searchFetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"noteTitle" ascending:NO selector:@selector(caseInsensitiveCompare:)];
    NSArray *sortDescriptors = @[sortDescriptor];
    [_searchFetchRequest setSortDescriptors:sortDescriptors];
    return _searchFetchRequest;
    
}

- (void)searchForText:(NSString *)searchText
{
    if (self.fetchedResultsController.managedObjectContext)
    {
        NSString *predicateFormat = @"(%K CONTAINS[cd] %@) OR (%K CONTAINS[cd] %@)";

        NSString *searchAttributeTitle = @"noteTitle";
        NSString *searchAttributeContent = @"content";
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat, searchAttributeTitle, searchText, searchAttributeContent, searchText];
        
        NSError *error;
        
        if (searchText.length == 0)
        {
            [self.searchFetchRequest setPredicate:nil];
            self.filteredList = [self.fetchedResultsController.managedObjectContext executeFetchRequest:self.searchFetchRequest error:&error];
            
        }
        
        else
        {
            [self.searchFetchRequest setPredicate:predicate];
            self.filteredList = [self.fetchedResultsController.managedObjectContext executeFetchRequest:self.searchFetchRequest error:&error];
        }
        
        if (error)
        {
            NSLog(@"searchFetchRequest failed: %@", [error localizedDescription]);
        }
    }
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = searchController.searchBar.text;
    [self searchForText:searchString];
    [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self updateSearchResultsForSearchController:self.searchController];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchController.active = NO;
    
    [self reloadAllData];
}

- (void)reloadAllData
{
    self.fetchedResultsController = nil;

    NSError *error;
    [self.fetchedResultsController performFetch:&error];
    [self.tableView reloadData];
    
    if (error)
    {
        NSLog(@"searchFetchRequest failed: %@", [error localizedDescription]);
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    NSError *error;
    self.filteredList = [self.fetchedResultsController.managedObjectContext executeFetchRequest:self.searchFetchRequest error:&error];
    
    if (error)
    {
        NSLog(@"searchFetchRequest failed: %@", [error localizedDescription]);
    }
}

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

@end
