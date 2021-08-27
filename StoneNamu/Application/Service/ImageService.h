//
//  ImageService.h
//  ImageService
//
//  Created by Jinwoo Kim on 8/26/21.
//

#import <UIKit/UIKit.h>
#import "HSCardSet.h"
#import "HSCardClass.h"
#import "HSDeckFormat.h"

NS_ASSUME_NONNULL_BEGIN

@interface ImageService : NSObject
@property (class, readonly, nonatomic) ImageService *sharedInstance;
- (UIImage * _Nullable)imageOfCardSet:(HSCardSet)cardSet;
- (UIImage * _Nullable)imageOfDeckFormat:(HSDeckFormat)deckFormat;
- (UIImage * _Nullable)portraitImageOfClassId:(HSCardClass)classId;
@end

NS_ASSUME_NONNULL_END
