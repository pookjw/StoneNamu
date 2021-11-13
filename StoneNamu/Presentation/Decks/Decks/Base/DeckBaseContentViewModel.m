//
//  DeckBaseContentViewModel.m
//  DeckBaseContentViewModel
//
//  Created by Jinwoo Kim on 8/26/21.
//

#import "DeckBaseContentViewModel.h"
#import <StoneNamuCore/StoneNamuCore.h>
#import <StoneNamuResources/StoneNamuResources.h>

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
        return [ResourcesService imageForKey:ImageKeyPnamuEasteregg1];
    } else {
        return [ResourcesService portraitImageForClassId:localDeck.classId.unsignedIntegerValue];;
    }
}

@end
