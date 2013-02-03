//
//  SHWordpress.m
//  SHWordpress
//
//  Created by Seraphin Hochart on 2013-02-02.
//  Copyright (c) 2013 Seraphin Hochart. All rights reserved.
//

#import "SHWordpress.h"
#import "SHInfos.h"
#import "SHPost.h"

#import "SHAppDelegate.h"
#define DELEGATE_CONTEXT [(SHAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]


@implementation SHWordpress


#pragma mark - Init Functions

+ (void) initWithBaseUrl:(NSString *)s_url; {
    
    
    // Set the base URL in the DB
    [self deleteAllObjectsForEntity:@"SHInfos" andContext:DELEGATE_CONTEXT];

    SHInfos *sh_infos = (SHInfos *)[NSEntityDescription insertNewObjectForEntityForName:@"SHInfos" inManagedObjectContext:DELEGATE_CONTEXT];
    // Set the values
    sh_infos.base_url = s_url;
    // Save into DB
    NSError *error;
    if (![DELEGATE_CONTEXT save:&error]) {
        NSLog(@"Problem saving: %@", [error localizedDescription]);
    }
        
    // Check if there is new content, if yes, update the DB.
    if ([self isNewContentAvailable]) {
        [self refreshContent];
    }
}

+ (NSString *) getBaseURL {
    NSString *s_base;
    // Retrieve base url from DB.
    NSArray *a_infos = [self getObjectsForEntity:@"SHInfos" withSortKey:nil andSortAscending:YES andContext:DELEGATE_CONTEXT];
    SHInfos *sh_infos = [a_infos lastObject];
    s_base = sh_infos.base_url;
    return s_base;
}

+ (void) refreshContent {
    
    // Refresh the Content from the DB.
    // Basically empty it, and reload it (v1).
    [self deleteAllObjectsForEntity:@"SHPost" andContext:DELEGATE_CONTEXT];
    
    // Refresh the posts in the DB.
    NSArray *a_infos = [self getObjectsForEntity:@"SHInfos" withSortKey:nil andSortAscending:YES andContext:DELEGATE_CONTEXT];
    SHInfos *sh_infos = [a_infos lastObject];
    NSError *jsonError = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:[sh_infos.json_posts dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&jsonError];
    
    if ([jsonObject isKindOfClass:[NSArray class]]) {
        NSLog(@"JSON Recieved is an array");
        NSArray *jsonArray = (NSArray *)jsonObject;

        // Loop into the Array
        for (int i = 0; i < [jsonArray count]; i++) {
            NSDictionary *d_post = [jsonArray objectAtIndex:i];
            //categories,id,tags,content,author,date,excerpt,permalink,title
            SHPost *sh_post = (SHPost *)[NSEntityDescription insertNewObjectForEntityForName:@"SHPost" inManagedObjectContext:DELEGATE_CONTEXT];
            // Set the values
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            NSDate *date_post = [df dateFromString:[NSString stringWithFormat:@"%@", [d_post objectForKey:@"date"]]];
            sh_post.post_id    = [NSNumber numberWithInt:[[d_post objectForKey:@"id"] intValue]];
            sh_post.title      = [NSString stringWithFormat:@"%@", [d_post objectForKey:@"title"]];
            sh_post.author     = [NSString stringWithFormat:@"%@", [d_post objectForKey:@"author"]];
            sh_post.content    = [NSString stringWithFormat:@"%@", [d_post objectForKey:@"content"]];
            sh_post.excerpt    = [NSString stringWithFormat:@"%@", [d_post objectForKey:@"excerpt"]];
            sh_post.permalink  = [NSString stringWithFormat:@"%@", [d_post objectForKey:@"permalink"]];
            sh_post.tags       = (NSArray *)[d_post objectForKey:@"tags"];
            sh_post.categories = (NSArray *)[d_post objectForKey:@"categories"];
            sh_post.date       = date_post;
            
            NSLog(@"Saving Post:%@", [NSString stringWithFormat:@"%@", [d_post objectForKey:@"title"]]);
            // Save into DB
            NSError *error;
            if (![DELEGATE_CONTEXT save:&error]) {
                NSLog(@"Problem saving: %@", [error localizedDescription]);
            }
        }
    } else {
        NSLog(@"JSON Recieved is dictionary");
        NSDictionary *jsonDictionary = (NSDictionary *)jsonObject;
        NSLog(@"jsonDictionary - %@",jsonDictionary);
        // TODO Needs to be handled
    }
    
}

+ (BOOL) isNewContentAvailable {
    // We can first check if an internet connection is accessible
    
    // Check if the current link is still the same as the old one.
    
    // Compare the Recieved JSON to the one we have in DB, to check if there is differences. If there is, update DB, if not, keep going.
    NSError *error = nil;
    NSString *s_json = [NSString stringWithContentsOfURL:[NSURL URLWithString:[self getBaseURL]] encoding:NSUTF8StringEncoding error:&error];
    NSArray *a_infos = [self getObjectsForEntity:@"SHInfos" withSortKey:nil andSortAscending:YES andContext:DELEGATE_CONTEXT];
    SHInfos *sh_infos = [a_infos lastObject];
    
    BOOL shouldUpdateAnyway = YES; /* DEBUG */
    if ([s_json isEqualToString:sh_infos.json_posts] || !shouldUpdateAnyway) {
        // We have the same content, do not update
        return NO;
    } else {
        // We don't have the same content
        // Refresh the JSON in the SHInfos

        NSFetchRequest * frequest = [[NSFetchRequest alloc] init];
        [frequest setEntity:[NSEntityDescription entityForName:@"SHInfos" inManagedObjectContext:DELEGATE_CONTEXT]];
        sh_infos = [[DELEGATE_CONTEXT executeFetchRequest:frequest error:&error] lastObject];
        if (error) {}

        sh_infos.json_posts = s_json;
        
        if (![DELEGATE_CONTEXT save:&error])
        {
            NSLog(@"Problem saving: %@", [error localizedDescription]);
        }
        return YES;
    }
    
}



#pragma mark - Retrieve Posts

+ (int) postsCount {
    return [self countForEntity:@"SHPost" andContext:DELEGATE_CONTEXT];
}
+ (NSArray *) getPosts {
    // Create an array of SHPost objects.
    return [self getObjectsForEntity:@"SHPost" withSortKey:@"date" andSortAscending:YES andContext:DELEGATE_CONTEXT];
}

// Retrieve Dictionanry with all available content from Post
+ (SHPost *)getPostFromID:(int)i_post {
    SHPost *sh_post = [[SHPost alloc] init];
    
    // Fetch req with predicate
    
    return sh_post;
}
 

#pragma mark - DB Actions

#pragma mark Retrieve objects

// Fetch objects with a predicate
+ (NSMutableArray *)searchObjectsForEntity:(NSString*)entityName withPredicate:(NSPredicate *)predicate andSortKey:(NSString*)sortKey andSortAscending:(BOOL)sortAscending andContext:(NSManagedObjectContext *)managedObjectContext
{
	// Create fetch request
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
    
	// If a predicate was specified then use it in the request
	if (predicate != nil)
		[request setPredicate:predicate];
    
	// If a sort key was passed then use it in the request
	if (sortKey != nil) {
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:sortAscending];
		NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
		[request setSortDescriptors:sortDescriptors];
	}
    
	// Execute the fetch request
	NSError *error = nil;
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
	// If the returned array was nil then there was an error
	if (mutableFetchResults == nil)
		NSLog(@"Couldn't get objects for entity %@", entityName);
    
	// Return the results
	return mutableFetchResults;
}

// Fetch objects without a predicate
+ (NSMutableArray *)getObjectsForEntity:(NSString*)entityName withSortKey:(NSString*)sortKey andSortAscending:(BOOL)sortAscending andContext:(NSManagedObjectContext *)managedObjectContext
{
	return [self searchObjectsForEntity:entityName withPredicate:nil andSortKey:sortKey andSortAscending:sortAscending andContext:managedObjectContext];
}


#pragma mark Count objects

// Get a count for an entity with a predicate
+ (NSUInteger)countForEntity:(NSString *)entityName withPredicate:(NSPredicate *)predicate andContext:(NSManagedObjectContext *)managedObjectContext
{
    NSLog(@"Entity name : %@", entityName);
	// Create fetch request
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
	[request setIncludesPropertyValues:NO];
    
	// If a predicate was specified then use it in the request
	if (predicate != nil)
		[request setPredicate:predicate];
    
	// Execute the count request
	NSError *error = nil;
	NSUInteger count = [managedObjectContext countForFetchRequest:request error:&error];
    
	// If the count returned NSNotFound there was an error
	if (count == NSNotFound)
		NSLog(@"Couldn't get count for entity %@", entityName);
    
	// Return the results
	return count;
}

// Get a count for an entity without a predicate
+ (NSUInteger)countForEntity:(NSString *)entityName andContext:(NSManagedObjectContext *)managedObjectContext
{
	return [self countForEntity:entityName withPredicate:nil andContext:managedObjectContext];
}

#pragma mark Delete Objects

// Delete all objects for a given entity
+ (BOOL)deleteAllObjectsForEntity:(NSString*)entityName withPredicate:(NSPredicate*)predicate andContext:(NSManagedObjectContext *)managedObjectContext
{
	// Create fetch request
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
    
	// Ignore property values for maximum performance
	[request setIncludesPropertyValues:NO];
    
	// If a predicate was specified then use it in the request
	if (predicate != nil)
		[request setPredicate:predicate];
    
	// Execute the count request
	NSError *error = nil;
	NSArray *fetchResults = [managedObjectContext executeFetchRequest:request error:&error];
    
	// Delete the objects returned if the results weren't nil
	if (fetchResults != nil) {
		for (NSManagedObject *manObj in fetchResults) {
			[managedObjectContext deleteObject:manObj];
		}
	} else {
		NSLog(@"Couldn't delete objects for entity %@", entityName);
		return NO;
	}
    
	return YES;
}

+ (BOOL)deleteAllObjectsForEntity:(NSString*)entityName andContext:(NSManagedObjectContext *)managedObjectContext
{
	return [self deleteAllObjectsForEntity:entityName withPredicate:nil andContext:managedObjectContext];
}



@end
