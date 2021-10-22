//
//  DeckBaseContentViewModel.m
//  DeckBaseContentViewModel
//
//  Created by Jinwoo Kim on 8/26/21.
//

#import "DeckBaseContentViewModel.h"
#import "ImageService.h"
#import "LocalDeckUseCaseImpl.h"

@interface DeckBaseContentViewModel ()
@property (retain) id<LocalDeckUseCase> localDeckUseCase;
@end

@implementation DeckBaseContentViewModel

- (instancetype)init {
    self = [super init];
    
    if (self) {
        LocalDeckUseCaseImpl *localDeckUseCase = [LocalDeckUseCaseImpl new];
        self.localDeckUseCase = localDeckUseCase;
        [localDeckUseCase release];
    }
    
    return self;
}

- (void)dealloc {
    [_localDeckUseCase release];
    [super dealloc];
}

- (UIImage *)portraitImageOfLocalDeck:(LocalDeck *)localDeck {
    if ([self.localDeckUseCase isEasterEggDeckFromLocalDeck:localDeck]) {
        return [ImageService.sharedInstance portraitOfPnamu];;
    } else {
        return [ImageService.sharedInstance portraitImageOfClassId:localDeck.classId.unsignedIntegerValue];;
    }
}

@end
