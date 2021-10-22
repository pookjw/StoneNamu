//
//  SheetNavigationController.h
//  SheetNavigationController
//
//  Created by Jinwoo Kim on 7/25/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SheetNavigationController : UINavigationController
@property (copy) NSArray<UISheetPresentationControllerDetent *> *detents;
@end

NS_ASSUME_NONNULL_END
