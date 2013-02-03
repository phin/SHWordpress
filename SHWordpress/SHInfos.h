//
//  SHInfos.h
//  SHWordpress
//
//  Created by Seraphin Hochart on 2013-02-02.
//  Copyright (c) 2013 Seraphin Hochart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SHInfos : NSManagedObject

@property (nonatomic, retain) NSString * about;
@property (nonatomic, retain) NSString * json_posts;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * base_url;

@end
