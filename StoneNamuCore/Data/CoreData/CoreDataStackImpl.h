//
//  CoreDataStackImpl.h
//  CoreDataStackImpl
//
//  Created by Jinwoo Kim on 8/2/21.
//

#import "CoreDataStack.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoreDataStackImpl : NSObject <CoreDataStack>
- (instancetype)initWithModelName:(NSString *)modelName storeContainerClass:(Class)storeContainerClass;
@end

NS_ASSUME_NONNULL_END
