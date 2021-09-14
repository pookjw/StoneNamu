//
//  DeckImageRenderServiceSectionModel.h
//  DeckImageRenderServiceSectionModel
//
//  Created by Jinwoo Kim on 9/10/21.
//

#import <Foundation/Foundation.h>
#import "HSCardClass.h"
#import "HSDeckFormat.h"

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
