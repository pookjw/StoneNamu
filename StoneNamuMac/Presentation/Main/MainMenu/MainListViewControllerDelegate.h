//
//  MainListViewControllerDelegate.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 11/17/21.
//

#import <Foundation/Foundation.h>
#import "MainListViewModel.h"

@class MainListViewController;

NS_ASSUME_NONNULL_BEGIN

@protocol MainListViewControllerDelegate <NSObject>
- (void)mainListViewController:(MainListViewController *)mainListViewController didChangeSelectedItemModelType:(MainListItemModelType)type;
@end

NS_ASSUME_NONNULL_END
