//
//  CoreDataStackImpl.h
//  CoreDataStackImpl
//
//  Created by Jinwoo Kim on 8/2/21.
//

#include <TargetConditionals.h>
#if TARGET_OS_OSX
#import <StoneNamuMacCore/CoreDataStack.h>
#else
#import <StoneNamuCore/CoreDataStack.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface CoreDataStackImpl : NSObject <CoreDataStack>
- (instancetype)initWithModelName:(NSString *)modelName storeContainerClass:(Class)storeContainerClass;
@end

NS_ASSUME_NONNULL_END
