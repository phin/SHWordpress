//
//  SHWordpress.h
//  SHWordpress
//
//  Created by Seraphin Hochart on 2013-02-02.
//  Copyright (c) 2013 Seraphin Hochart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SHPost.h"

@interface SHWordpress : NSObject

// This methods will help you retrieve SHPost objects and/or specific content from these objects.
// Features
//  - Caching, local CoreData DB
//  - No external libraries to download
//  - Retrieve posts (incl custom posts) & its content.


// General
+ (void) initWithBaseUrl:(NSString *)s_url;
+ (void) refreshContent;
+ (NSString *) getBaseURL;
+ (BOOL) isNewContentAvailable;

// v1 - Retrieve Posts.
+ (int) postsCount;
+ (NSArray *) getPosts;
+ (SHPost *)getPostFromID:(int)i_post;


// v2 - Retrieve Specific Posts
//- (NSArray *)  getCustomPosts:(NSString *)s_customPostName;
//- (NSArray *)  getPostsWithCategory:(NSString *)s_category;

// V2 - Get Specific content From Post
//- (UIImage *)  getFeaturedImageFromID:(int)i_post;
//- (NSString *) getTitleFromID:(int)i_post;
//- (NSString *) getDateFromID:(int)i_post;
//- (NSString *) getTextFromID:(int)i_post;
//- (NSArray *)  getImagesFromID:(int)i_post;
//- (NSString *) getHTMLFromPost:(int)i_post;




// DB STUFF

// For retrieval of objects
+(NSMutableArray *)getObjectsForEntity:(NSString*)entityName withSortKey:(NSString*)sortKey andSortAscending:(BOOL)sortAscending andContext:(NSManagedObjectContext *)managedObjectContext;
+(NSMutableArray *)searchObjectsForEntity:(NSString*)entityName withPredicate:(NSPredicate *)predicate andSortKey:(NSString*)sortKey andSortAscending:(BOOL)sortAscending andContext:(NSManagedObjectContext *)managedObjectContext;

// For deletion of objects
+(BOOL)deleteAllObjectsForEntity:(NSString*)entityName withPredicate:(NSPredicate*)predicate andContext:(NSManagedObjectContext *)managedObjectContext;
+(BOOL)deleteAllObjectsForEntity:(NSString*)entityName andContext:(NSManagedObjectContext *)managedObjectContext;

// For counting objects
+(NSUInteger)countForEntity:(NSString *)entityName andContext:(NSManagedObjectContext *)managedObjectContext;
+(NSUInteger)countForEntity:(NSString *)entityName withPredicate:(NSPredicate *)predicate andContext:(NSManagedObjectContext *)managedObjectContext;

@end
