//
//  ClickableCollectionViewDelegate.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 12/21/21.
//

#import <Cocoa/Cocoa.h>

@class ClickableCollectionView;

@protocol ClickableCollectionViewDelegate <NSObject>
- (void)clickableCollectionView:(ClickableCollectionView *)clickableCollectionView didClick:(BOOL)didClick;
@end
