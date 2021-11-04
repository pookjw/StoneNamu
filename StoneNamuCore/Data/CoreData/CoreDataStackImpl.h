//
//  CoreDataStackImpl.h
//  CoreDataStackImpl
//
//  Created by Jinwoo Kim on 8/2/21.
//

#import <StoneNamuCore/CoreDataStack.h>

NS_ASSUME_NONNULL_BEGIN

@interface CoreDataStackImpl : NSObject <CoreDataStack>
- (instancetype)initWithModelName:(NSString *)modelName storeContainerClass:(Class)storeContainerClass models:(NSArray<NSString *> *)models;
@end

NS_ASSUME_NONNULL_END
