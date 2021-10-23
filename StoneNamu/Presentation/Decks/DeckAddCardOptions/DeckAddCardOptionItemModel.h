//
//  CardOptionItemModel.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import <Foundation/Foundation.h>
#import "PickerItemModel.h"
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DeckAddCardOptionItemModelType) {
    DeckAddCardOptionItemModelTypeSet,
    DeckAddCardOptionItemModelTypeClass,
    DeckAddCardOptionItemModelTypeManaCost,
    DeckAddCardOptionItemModelTypeAttack,
    DeckAddCardOptionItemModelTypeHealth,
    DeckAddCardOptionItemModelTypeCollectible,
    DeckAddCardOptionItemModelTypeRarity,
    DeckAddCardOptionItemModelTypeType,
    DeckAddCardOptionItemModelTypeMinionType,
    DeckAddCardOptionItemModelTypeKeyword,
    DeckAddCardOptionItemModelTypeTextFilter,
    DeckAddCardOptionItemModelTypeGameMode,
    DeckAddCardOptionItemModelTypeSort
};

typedef NS_ENUM(NSUInteger, DeckAddCardOptionItemModelValueSetType) {
    DeckAddCardOptionItemModelValueSetTypeTextField,
    DeckAddCardOptionItemModelValueSetTypePicker,
    DeckAddCardOptionItemModelValueSetTypePickerWithEmptyRow,
    DeckAddCardOptionItemModelValueSetTypeStepper
};

NSString * NSStringFromDeckAddCardOptionItemModelType(DeckAddCardOptionItemModelType);
DeckAddCardOptionItemModelType DeckAddCardOptionItemModelTypeFromNSString(NSString *);

@interface DeckAddCardOptionItemModel : NSObject
@property (readonly) DeckAddCardOptionItemModelType type;
@property (copy) HSDeckFormat deckFormat;
@property HSCardClass classId;
@property (copy) NSString * _Nullable value;
@property (readonly, nonatomic) DeckAddCardOptionItemModelValueSetType valueSetType;
@property (readonly, nonatomic) NSArray<PickerItemModel *> * _Nullable pickerDataSource;
@property (readonly, nonatomic) NSRange stepperRange;
@property (readonly, nonatomic) BOOL showPlusMarkWhenReachedToMaxOnStepper;
@property (readonly, nonatomic) NSString *text;
@property (readonly, nonatomic) NSString * _Nullable accessoryText;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(DeckAddCardOptionItemModelType)type deckFormat:(HSDeckFormat)deckFormat classId:(HSCardClass)classId;
@end

NS_ASSUME_NONNULL_END
