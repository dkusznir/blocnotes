//
//  MasterViewController.h
//  blocnotes
//
//  Created by Dorian Kusznir on 5/15/15.
//  Copyright (c) 2015 dkusznir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CreateNoteViewController.h"
#import "DetailViewController.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate, DetailViewControllerDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@end

