//
//  InterfaceController.m
//  blocnotes WatchKit Extension
//
//  Created by Dorian Kusznir on 7/3/15.
//  Copyright (c) 2015 dkusznir. All rights reserved.
//

#import "InterfaceController.h"
#import "NoteDataManager.h"
#import "NoteRowController.h"

@interface InterfaceController()

@property (nonatomic, weak) IBOutlet WKInterfaceTable *tableView;
@property (nonatomic, strong) NSArray *notesData;

@end

@implementation InterfaceController

- (void)awakeWithContext:(id)context
{
    [super awakeWithContext:context];
    [self setUpTable];

    // Configure interface objects here.
}

- (void)willActivate
{
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
}

- (void)didDeactivate
{
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void)setUpTable
{
    self.notesData = [[NoteDataManager sharedInstance] getNotes];
    [self.tableView setNumberOfRows:self.notesData.count withRowType:@"NoteRowController"];
    
    NSLog(@"%lu", (long)self.tableView.numberOfRows);

    for (int i = 0; i < self.notesData.count; i++)
    {
        NSString *title = NSLocalizedString([self.notesData[i] valueForKey:@"noteTitle"], @"Note title - Table View");
        
        if ([title isEqualToString:@""])
        {
            title = NSLocalizedString([self.notesData[i] valueForKey:@"content"], @"Note title (content) - Table View");
        }
        
        NoteRowController *row = [self.tableView rowControllerAtIndex:i];
        [row.noteTitle setText:title];
        
    }
    
}

- (void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex
{
    NSLog(@"Data for row: %@", [self.notesData objectAtIndex:rowIndex]);
    id notesData = [self.notesData objectAtIndex:rowIndex];
    [self pushControllerWithName:@"NoteDetailController" context:notesData];

}


@end



