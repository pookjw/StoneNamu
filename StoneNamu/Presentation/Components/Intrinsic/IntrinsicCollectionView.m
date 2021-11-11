//
//  IntrinsicCollectionView.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 11/10/21.
//

#import "IntrinsicCollectionView.h"

@implementation IntrinsicCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    
    if (self) {
        [self bind];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    
    if (self) {
        [self bind];
    }
    
    return self;
}

- (CGSize)intrinsicContentSize {
    return self.contentSize;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([object isEqual:self] && [keyPath isEqualToString:@"contentSize"]) {
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [self layoutIfNeeded];
            [self.collectionViewLayout invalidateLayout];
            [self invalidateIntrinsicContentSize];
        }];
    } else {
        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)bind {
    [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
}

@end
