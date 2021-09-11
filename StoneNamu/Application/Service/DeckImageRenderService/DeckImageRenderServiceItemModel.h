//
//  DeckImageRenderServiceItemModel.h
//  DeckImageRenderServiceItemModel
//
//  Created by Jinwoo Kim on 9/10/21.
//

#import <UIKit/UIKit.h>
#import "HSCard.h"
#import "HSDeckFormat.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DeckImageRenderServiceItemModelType) {
    DeckImageRenderServiceItemModelTypeIntro,
    DeckImageRenderServiceItemModelTypeInfo,
    DeckImageRenderServiceItemModelTypeCard,
    DeckImageRenderServiceItemModelTypeAbout
};

@interface DeckImageRenderServiceItemModel : NSObject
@property (readonly) DeckImageRenderServiceItemModelType type;

#pragma mark - DeckImageRenderServiceItemModelTypeIntro
@property HSCardClass classId;
@property (copy) NSNumber * _Nullable totalArcaneDust;
@property (copy) NSString * _Nullable deckName;

#pragma mark - DeckImageRenderServiceItemModelTypeInfo
@property (copy) NSString * _Nullable hsYearCurrent;
@property (copy) HSDeckFormat _Nullable deckFormat;

#pragma mark - DeckImageRenderServiceItemModelTypeCard
@property (copy) HSCard * _Nullable hsCard;
@property (retain) UIImage * _Nullable hsCardImage;
@property NSUInteger hsCardCount;

- (instancetype)initWithType:(DeckImageRenderServiceItemModelType)type;
@end

NS_ASSUME_NONNULL_END
