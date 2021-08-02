//
//  CoreDataStack.h
//  CoreDataStack
//
//  Created by Jinwoo Kim on 8/2/21.
//

#import <CoreData/CoreData.h>

static NSString * const CoreDataStackDidChangeNotificationName = @"CoreDataStackDidChangeNotificationName";

@protocol CoreDataStack <NSObject>
@property (readonly, nonatomic, assign) NSManagedObjectContext *mainContext;
@property (readonly, assign) NSPersistentContainer *storeContainer;
- (void)saveChanges;
@end
