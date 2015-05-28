//
//  Body.h
//  blocnotes
//
//  Created by Dorian Kusznir on 5/28/15.
//  Copyright (c) 2015 dkusznir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Body : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * noteTitle;
@property (nonatomic, retain) NSDate * timeStamp;

@end
