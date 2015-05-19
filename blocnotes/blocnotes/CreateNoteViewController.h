//
//  CreateNoteViewController.h
//  blocnotes
//
//  Created by Dorian Kusznir on 5/17/15.
//  Copyright (c) 2015 dkusznir. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CreateNoteViewController;

@protocol CreateNoteViewDelegate <NSObject>

- (void)noteController:(CreateNoteViewController *)sender didSaveWithText:(NSString *)text;

@end

@interface CreateNoteViewController : UIViewController

@property (nonatomic, weak) NSObject <CreateNoteViewDelegate> *delegate;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) BOOL isWritingNote;

@end
