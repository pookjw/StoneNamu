//
//  HSCardSetStore.h
//  HSCardSetStore
//
//  Created by Jinwoo Kim on 7/25/21.
//

#import <Foundation/Foundation.h>
#import "PickerItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HSCardSetStore : NSObject
@property (class, readonly, nonatomic) NSArray<PickerItemModel *> *pickerItemModels;
@end

NS_ASSUME_NONNULL_END
