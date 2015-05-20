//
//  DetailViewController.m
//  blocnotes
//
//  Created by Dorian Kusznir on 5/15/15.
//  Copyright (c) 2015 dkusznir. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController () <UITextViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIBarButtonItem *saveButton;
@property (weak, nonatomic) UILabel *detailDescriptionLabel;
@property (nonatomic, strong) UILabel *createdDateAndTime;
@property (nonatomic, strong) UILabel *savedLabel;

@end

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
    if (self.detailItem)
    {
        [self createViews];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];

}

- (void)createViews
{
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 60, self.view.bounds.size.width, (CGRectGetMaxY(self.view.frame) - 80))];
    self.textView.delegate = self;
    self.textView.textColor = [UIColor blackColor];
    self.textView.text  = [[self.detailItem valueForKey:@"content"] description];
    [self.textView setFont:[UIFont fontWithName:@"HelveticaNeue" size:20]];
    
    self.saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(didSave:)];
    
    self.createdDateAndTime = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.textView.frame), self.view.bounds.size.width, 20)];
    NSString *currentDateAndTime = [[self.detailItem valueForKey:@"timeStamp"] description];
    self.createdDateAndTime.text = [NSString stringWithFormat:@"Created At: %@", currentDateAndTime];
    self.createdDateAndTime.textColor = [UIColor whiteColor];
    self.createdDateAndTime.textAlignment = NSTextAlignmentCenter;
    self.createdDateAndTime.backgroundColor = [UIColor colorWithRed:0 green:0 blue:153.0 alpha:1];
    [self.createdDateAndTime setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    
    self.savedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (self.view.bounds.size.width / 2), 40)];
    self.savedLabel.backgroundColor = [UIColor colorWithRed:0.0 green:245.0 blue:0.0 alpha:1.0];
    self.savedLabel.layer.cornerRadius = 5.0;
    self.savedLabel.clipsToBounds = YES;
    self.savedLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Saved!", @"Saved Label")];
    self.savedLabel.textColor = [UIColor colorWithRed:12.0 green:12.0 blue:12.0 alpha:1.0];
    self.savedLabel.textAlignment = NSTextAlignmentCenter;
    self.savedLabel.alpha = 0;
    self.savedLabel.center = self.textView.center;
    
    [self.view addSubview:self.textView];
    [self.view addSubview:self.createdDateAndTime];
    [self.view addSubview:self.savedLabel];
    self.navigationItem.rightBarButtonItem = self.saveButton;
    
}


- (void)setText:(NSString *)text
{
    _text = text;
    self.textView.text = text;
    self.textView.userInteractionEnabled = YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{

}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self setText:self.textView.text];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didSave:(NSString *)text
{
    [self textViewDidEndEditing:self.textView];
    //[self.detailItem setValue:self.text forKey:@"content"];
    NSLog(@"%@", self.text);
    [self.delegate didUpdate:self withText:self.text];
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

@end
