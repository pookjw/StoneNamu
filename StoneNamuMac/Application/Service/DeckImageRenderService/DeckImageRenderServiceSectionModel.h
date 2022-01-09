//
//  DeckImageRenderServiceSectionModel.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 1/3/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DeckImageRenderServiceSectionModelType) {
    DeckImageRenderServiceSectionModelTypeIntro,
    DeckImageRenderServiceSectionModelTypeCards,
    DeckImageRenderServiceSectionModelTypeAbout,
    DeckImageRenderServiceSectionModelTypeAppName
};

@interface DeckImageRenderServiceSectionModel : NSObject
@property (readonly) DeckImageRenderServiceSectionModelType type;
- (instancetype)initWithType:(DeckImageRenderServiceSectionModelType)type;
@end

NS_ASSUME_NONNULL_END
