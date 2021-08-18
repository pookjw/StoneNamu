//
//  DecksItemModel.h
//  DecksItemModel
//
//  Created by Jinwoo Kim on 8/19/21.
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DecksItemModelType) {
    DecksItemModelTypeDeck
};

@interface DecksItemModel : NSObject
@property (readonly) DecksItemModelType type;
@property (readonly, copy) NSManagedObjectID *objectId;
- (instancetype)initWithType:(DecksItemModelType)type objectId:(NSManagedObjectID *)objectId;
@end

NS_ASSUME_NONNULL_END
