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
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.textView.delegate = self;
    self.textView.textColor = [UIColor blackColor];
    self.textView.text  = [[self.detailItem valueForKey:@"content"] description];
    [self.textView setFont:[UIFont fontWithName:@"HelveticaNeue" size:20]];
    //NSLog(@"%@", [[self.detailItem valueForKey:@"content"] description]);
    
    self.saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(didSave:)];
    
    [self.view addSubview:self.textView];
    self.navigationItem.rightBarButtonItem = self.saveButton;
    
    self.detailDescriptionLabel.text = [[self.detailItem valueForKey:@"timeStamp"] description];
    
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
}

@end
