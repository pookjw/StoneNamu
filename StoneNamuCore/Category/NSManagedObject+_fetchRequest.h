//
//  NSManagedObject+_fetchRequest.h
//  NSManagedObject+_fetchRequest
//
//  Created by Jinwoo Kim on 8/10/21.
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSManagedObject (_fetchRequest)
+ (NSFetchRequest *)_fetchRequest;
@end

NS_ASSUME_NONNULL_END
