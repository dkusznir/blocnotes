//
//  NoteDetailController.h
//  blocnotes
//
//  Created by Dorian Kusznir on 7/5/15.
//  Copyright (c) 2015 dkusznir. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface NoteDetailController : WKInterfaceController

@property (nonatomic, weak) IBOutlet WKInterfaceLabel *noteTitle;
@property (nonatomic, weak) IBOutlet WKInterfaceLabel *noteContent;
@property (nonatomic, weak) IBOutlet WKInterfaceLabel *noteDate;

@end
