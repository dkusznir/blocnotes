//
//  CreateNoteViewController.m
//  blocnotes
//
//  Created by Dorian Kusznir on 5/17/15.
//  Copyright (c) 2015 dkusznir. All rights reserved.
//

#import "CreateNoteViewController.h"

@interface CreateNoteViewController ()

@end

@implementation CreateNoteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createViews];
}

- (void)createViews
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [super createViews];
    
    self.createdDateAndTime.hidden = YES;
    
}

- (void)setText:(NSString *)text
{
    [super setText:text];
}

- (void)didSave:(UIBarButtonItem *)sender
{
    [self textViewDidEndEditing:self.textView];
    [self textFieldDidEndEditing:self.noteTitle];
    [self.delegate didUpdate:self withText:self.text andTitle:self.noteTitleText isNew:YES];
    [self displaySavedButton];

}


@end
