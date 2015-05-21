//
//  DetailViewController.m
//  blocnotes
//
//  Created by Dorian Kusznir on 5/15/15.
//  Copyright (c) 2015 dkusznir. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

static NSString *placeholderText;
static NSString *titlePlaceholderText;

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem)
    {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}


- (void)configureView
{
    // Update the user interface for the detail item.
    /*
    if (self.detailItem)
    {
        [self createViews];
    }
     */
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //[self configureView];
    [self createViews];

}

- (void)createViews
{
    [self setUpNoteTitleField];
    [self setUpTextView];
    [self setUpSaveButton];
    [self setUpCreatedLabel];
    [self setUpAnimatedSavedLabel];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.textView.text isEqualToString:placeholderText])
    {
        self.textView.text = NSLocalizedString(@"", @"Remove Placeholder Text");
        self.textView.textColor = [UIColor blackColor];
    }

}

- (void)textViewDidEndEditing:(UITextView *)textView
{
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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.noteTitle.text isEqualToString:titlePlaceholderText])
    {
        self.noteTitle.text = NSLocalizedString(@"", @"Remove Title Placeholder Text");
        self.noteTitle.textColor = [UIColor blackColor];
    }

}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.noteTitleText = self.noteTitle.text;
    
    if ([self.noteTitle.text isEqualToString:@""])
    {
        self.noteTitle.text = titlePlaceholderText;
        self.noteTitle.textColor = [UIColor lightGrayColor];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didSave:(NSString *)text
{
    [self textViewDidEndEditing:self.textView];
    [self textFieldDidEndEditing:self.noteTitle];
    [self.delegate didUpdate:self withText:self.text andTitle:self.noteTitleText isNew:NO];
    [self displaySavedButton];
}

- (void)displaySavedButton
{
    [UIView animateWithDuration:2.0 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.savedLabel.alpha = 0.75;
    } completion:nil];
    
    [UIView animateWithDuration:2.0 delay:2.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.savedLabel.alpha = 0;
    } completion:nil];
}

#pragma mark - Set Up Buttons & Labels

- (void)setUpTextView
{
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.noteTitle.frame), self.view.bounds.size.width, (CGRectGetMaxY(self.view.frame) - 120))];
    self.textView.delegate = self;
    self.textView.textColor = [UIColor blackColor];
    self.textView.text  = [[self.detailItem valueForKey:@"content"] description];
    [self.textView setFont:[UIFont fontWithName:@"HelveticaNeue" size:20]];
    
    if (self.textView.text == nil)
    {
        placeholderText = NSLocalizedString(@"Write your note....", @"Placeholder Text");
        self.textView.text = placeholderText;
        self.textView.textColor = [UIColor lightGrayColor];
    }

    [self.view addSubview:self.textView];

}

- (void)setUpCreatedLabel
{
    self.createdDateAndTime = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.textView.frame), self.view.bounds.size.width, 20)];
    NSString *currentDateAndTime = [[self.detailItem valueForKey:@"timeStamp"] description];
    self.createdDateAndTime.text = [NSString stringWithFormat:@"Created At: %@", currentDateAndTime];
    self.createdDateAndTime.textColor = [UIColor whiteColor];
    self.createdDateAndTime.textAlignment = NSTextAlignmentCenter;
    self.createdDateAndTime.backgroundColor = [UIColor colorWithRed:0 green:0 blue:153.0 alpha:1];
    [self.createdDateAndTime setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    
    [self.view addSubview:self.createdDateAndTime];

}

- (void)setUpAnimatedSavedLabel
{
    self.savedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (self.view.bounds.size.width / 2), 40)];
    self.savedLabel.backgroundColor = [UIColor colorWithRed:0.0f green:245.0f blue:0.0f alpha:1.0];
    self.savedLabel.layer.cornerRadius = 5.0f;
    self.savedLabel.clipsToBounds = YES;
    self.savedLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Saved!", @"Saved Label")];
    [self.savedLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:20]];
    self.savedLabel.textColor = [UIColor colorWithRed:10.0f green:10.0f blue:10.0f alpha:1.0];
    self.savedLabel.textAlignment = NSTextAlignmentCenter;
    self.savedLabel.alpha = 0;
    self.savedLabel.center = self.textView.center;
    
    [self.view addSubview:self.savedLabel];
}

- (void)setUpSaveButton
{
    self.saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(didSave:)];
    
    self.navigationItem.rightBarButtonItem = self.saveButton;
}

- (void)setUpNoteTitleField
{
    self.noteTitle = [[UITextField alloc] initWithFrame:CGRectMake(0, 70, self.view.bounds.size.width, 30)];
    self.noteTitle.text = [[self.detailItem valueForKey:@"noteTitle"] description];
    self.noteTitle.textAlignment = NSTextAlignmentLeft;
    self.noteTitle.layer.cornerRadius = 5.0;
    self.noteTitle.clipsToBounds = YES;
    [self.noteTitle setBorderStyle:UITextBorderStyleLine];
    self.noteTitle.layer.borderWidth = 1.5f;
    self.noteTitle.layer.borderColor = [[UIColor blackColor] CGColor];
    
    if (self.noteTitle.text == nil)
    {
        titlePlaceholderText = NSLocalizedString(@"Add a title....", @"Title Placeholder Text");
        self.noteTitle.text = placeholderText;
        self.noteTitle.textColor = [UIColor lightGrayColor];
    }
    
    [self.view addSubview:self.noteTitle];
                                                                   
}

@end
