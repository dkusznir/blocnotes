//
//  NoteDetailController.m
//  blocnotes
//
//  Created by Dorian Kusznir on 7/5/15.
//  Copyright (c) 2015 dkusznir. All rights reserved.
//

#import "NoteDetailController.h"

@interface NoteDetailController ()

@end

@implementation NoteDetailController

- (void)awakeWithContext:(id)context
{
    [super awakeWithContext:context];
    
    if (context)
    {
        [self.noteTitle setText:NSLocalizedString([context valueForKey:@"noteTitle"], @"Note title")];
        [self.noteContent setText:NSLocalizedString([context valueForKey:@"content"], @"Note content")];
        
        NSDate *date = [context valueForKey:@"timeStamp"];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateStyle:NSDateFormatterMediumStyle];
        [dateFormat setTimeStyle:NSDateFormatterShortStyle];
        NSString *dateToDisplay = NSLocalizedString([dateFormat stringFromDate:date], @"Date to display");
        [self.noteDate setText:[NSString stringWithFormat:@"Created: %@", dateToDisplay]];
    }
    
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

- (void)loadDetailData
{
    
}

@end



