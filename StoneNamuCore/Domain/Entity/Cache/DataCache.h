//
//  DataCache.h
//  DataCache
//
//  Created by Jinwoo Kim on 8/2/21.
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataCache : NSManagedObject
@property (assign) NSString * _Nullable identity;
@property (assign) NSData * _Nullable data;
+ (NSFetchRequest<DataCache *> *)_fetchRequest;
@end

NS_ASSUME_NONNULL_END
