//
//  CreateNoteViewController.m
//  blocnotes
//
//  Created by Dorian Kusznir on 5/17/15.
//  Copyright (c) 2015 dkusznir. All rights reserved.
//

#import "CreateNoteViewController.h"

@interface CreateNoteViewController () <UITextViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIBarButtonItem *saveButton;

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
    placeholderText = NSLocalizedString(@"Write your note....", @"Placeholder Text");
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.textView.delegate = self;
    self.textView.text = placeholderText;
    self.textView.textColor = [UIColor lightGrayColor];
    self.text = self.textView.text;
    [self.textView setFont:[UIFont fontWithName:@"HelveticaNeue" size:20]];
    
    self.saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(didSave:)];
    
    [self.view addSubview:self.textView];
    self.navigationItem.rightBarButtonItem = self.saveButton;
    
}

- (void)setText:(NSString *)text
{
    _text = text;
    self.textView.text = text;
    self.textView.userInteractionEnabled = YES;
    self.isWritingNote = text.length > 0;
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
    //NSLog(@"%@", self.text);
    //[self didSaveWithText:self.text];
    [self.delegate noteController:self didSaveWithText:self.text];

}

@end
