//
//  DeckImageRenderServiceItemModel.h
//  DeckImageRenderServiceItemModel
//
//  Created by Jinwoo Kim on 9/10/21.
//

#import <UIKit/UIKit.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DeckImageRenderServiceItemModelType) {
    DeckImageRenderServiceItemModelTypeIntro,
    DeckImageRenderServiceItemModelTypeCard,
    DeckImageRenderServiceItemModelTypeAbout,
    DeckImageRenderServiceItemModelTypeAppName
};

@interface DeckImageRenderServiceItemModel : NSObject
@property (readonly) DeckImageRenderServiceItemModelType type;

#pragma mark - DeckImageRenderServiceItemModelTypeIntro
@property HSCardClass classId;
@property (copy) NSString * _Nullable deckName;
@property (copy) HSDeckFormat _Nullable deckFormat;
@property BOOL isEasterEgg;

#pragma mark - DeckImageRenderServiceItemModelTypeCard
@property (copy) HSCard * _Nullable hsCard;
@property (retain) UIImage * _Nullable hsCardImage;
@property NSUInteger hsCardCount;

#pragma mark - DeckImageRenderServiceSectionModelTypeAppName
@property (copy) NSNumber * _Nullable totalArcaneDust;
@property (copy) NSString * _Nullable hsYearCurrentName;

- (instancetype)initWithType:(DeckImageRenderServiceItemModelType)type;
@end

NS_ASSUME_NONNULL_END
