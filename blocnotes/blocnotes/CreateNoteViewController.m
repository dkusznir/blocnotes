//
//  CreateNoteViewController.m
//  blocnotes
//
//  Created by Dorian Kusznir on 5/17/15.
//  Copyright (c) 2015 dkusznir. All rights reserved.
//

#import "CreateNoteViewController.h"

@interface CreateNoteViewController () <UITextViewDelegate, UIAlertViewDelegate>

@end

static NSString *placeholderText;

@implementation CreateNoteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createViews];
}

- (void)createViews
{
    [super createViews];
    self.textView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    placeholderText = NSLocalizedString(@"Write your note....", @"Placeholder Text");
    self.textView.text = placeholderText;
    self.textView.textColor = [UIColor lightGrayColor];
    self.text = self.textView.text;
    [self.textView setFont:[UIFont fontWithName:@"HelveticaNeue" size:20]];
    
    self.createdDateAndTime.hidden = YES;
    
}

- (void)setText:(NSString *)text
{
    [super setText:text];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.isWritingNote = YES;
    
    if ([self.textView.text isEqualToString:placeholderText])
    {
        self.textView.text = NSLocalizedString(@"", @"Remove Placeholder Text");
        self.textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
    self.isWritingNote = NO;
    
    if ([self.textView.text isEqualToString:@""])
    {
        self.textView.text = placeholderText;
        self.textView.textColor = [UIColor lightGrayColor];
    }
    
    else
    {
        [self setText:self.textView.text];
    }
}

- (void)didSave:(UIBarButtonItem *)sender
{
    [self textViewDidEndEditing:self.textView];
    [self.delegate didUpdate:self withText:self.text isNew:YES];
    [self displaySavedButton];

}


@end
