//
//  CoreDataStack.h
//  CoreDataStack
//
//  Created by Jinwoo Kim on 8/2/21.
//

#import <CoreData/CoreData.h>

static NSNotificationName const NSNotificationNameCoreDataStackDidChange = @"NSNotificationNameCoreDataStackDidChange";

@protocol CoreDataStack <NSObject>
@property (readonly, retain) NSManagedObjectContext *context;
@property (readonly, retain) NSPersistentContainer *storeContainer;
@property (readonly, retain) NSOperationQueue *queue;
- (void)saveChanges;
@end
