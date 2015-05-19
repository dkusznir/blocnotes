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

- (void)didUpdate:(DetailViewController *)sender withText:(NSString *)text;

@end

@interface DetailViewController : UIViewController

@property (nonatomic, weak) NSObject <DetailViewControllerDelegate> *delegate;
@property (strong, nonatomic) id detailItem;
@property (nonatomic, strong) NSString *text;

@end

