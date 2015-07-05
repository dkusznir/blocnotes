//
//  NoteRowController.h
//  blocnotes
//
//  Created by Dorian Kusznir on 7/4/15.
//  Copyright (c) 2015 dkusznir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WatchKit/WatchKit.h>

@interface NoteRowController : NSObject

@property (nonatomic, weak) IBOutlet WKInterfaceLabel *noteTitle;

@end
