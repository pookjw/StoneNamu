//
//  CardDetailsChildrenContentConfigurationDelegate.h
//  CardDetailsChildrenContentConfigurationDelegate
//
//  Created by Jinwoo Kim on 8/9/21.
//

#import <UIKit/UIKit.h>
#import "HSCard.h"

@protocol CardDetailsChildrenContentConfigurationDelegate <NSObject>
- (void)cardDetailsChildrenContentConfigurationDidTapImageView:(UIImageView *)imageView hsCard:(HSCard *)hsCard;
@end