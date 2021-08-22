//
//  DragItemService.h
//  DragItemService
//
//  Created by Jinwoo Kim on 8/23/21.
//

#import <UIKit/UIKit.h>
#import "HSCard.h"

NS_ASSUME_NONNULL_BEGIN

@interface DragItemService : NSObject
@property (class, readonly, nonatomic) DragItemService *sharedInstance;
- (UIDragItem *)makeDragItemsFromHSCard:(HSCard *)hsCard image:(UIImage * _Nullable)image;
@end

NS_ASSUME_NONNULL_END
