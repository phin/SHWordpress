//
//  SHPost.h
//  SHWordpress
//
//  Created by Seraphin Hochart on 2013-02-02.
//  Copyright (c) 2013 Seraphin Hochart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SHPost : NSManagedObject

@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) id categories;
@property (nonatomic, retain) NSString * excerpt;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * post_id;
@property (nonatomic, retain) NSString * permalink;
@property (nonatomic, retain) id tags;
@property (nonatomic, retain) NSString * title;

@end
