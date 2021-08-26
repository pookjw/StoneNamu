//
//  DeckBaseContentViewModel.h
//  DeckBaseContentViewModel
//
//  Created by Jinwoo Kim on 8/26/21.
//

#import <UIKit/UIKit.h>
#import "HSCard.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeckBaseContentViewModel : NSObject
- (UIImage * _Nullable)portraitImageOfClassId:(HSCardClass)classId;
@end

NS_ASSUME_NONNULL_END
