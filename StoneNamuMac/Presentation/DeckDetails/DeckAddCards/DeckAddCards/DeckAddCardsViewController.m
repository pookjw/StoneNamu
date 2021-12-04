//
//  DeckAddCardsViewController.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/28/21.
//

#import "DeckAddCardsViewController.h"

@interface DeckAddCardsViewController ()

@end

@implementation DeckAddCardsViewController

- (instancetype)initWithLocalDeck:(LocalDeck *)localDeck {
    self = [self init];
    
    if (self) {
        
    }
    
    return self;
}

- (void)loadView {
    NSView *view = [NSView new];
    self.view = view;
    [view release];
}

@end
