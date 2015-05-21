//
//  DetailViewController.h
//  blocnotes
//
//  Created by Dorian Kusznir on 5/15/15.
//  Copyright (c) 2015 dkusznir. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@protocol DetailViewControllerDelegate <NSObject>

- (void)didUpdate:(DetailViewController *)sender withText:(NSString *)text andTitle:(NSString *)title isNew:(BOOL)newNote;

@end

@interface DetailViewController : UIViewController <UITextViewDelegate, UIAlertViewDelegate, UITextFieldDelegate>

@property (nonatomic, weak) NSObject <DetailViewControllerDelegate> *delegate;
@property (strong, nonatomic) id detailItem;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIBarButtonItem *saveButton;
@property (nonatomic, strong) UILabel *createdDateAndTime;
@property (nonatomic, strong) UILabel *savedLabel;
@property (weak, nonatomic) UILabel *detailDescriptionLabel;
@property (nonatomic, strong) UITextField *noteTitle;
@property (nonatomic, strong) NSString *noteTitleText;

- (void)createViews;
- (void)displaySavedButton;

@end

