//
//  DeckAddCardsViewModel.m
//  DeckAddCardsViewModel
//
//  Created by Jinwoo Kim on 9/2/21.
//

#import "DeckAddCardsViewModel.h"
#import "LocalDeckUseCaseImpl.h"
#import "BlizzardHSAPIKeys.h"

@interface DeckAddCardsViewModel ()
@property (retain) NSOperationQueue *queue;
@property (retain) id<LocalDeckUseCase> localDeckUseCase;
@end

@implementation DeckAddCardsViewModel

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.localDeck = nil;
        
        NSOperationQueue *queue = [NSOperationQueue new];
        self.queue = queue;
        queue.qualityOfService = NSQualityOfServiceUserInitiated;
        [queue release];
        
        LocalDeckUseCaseImpl *localDeckUseCase = [LocalDeckUseCaseImpl new];
        self.localDeckUseCase = localDeckUseCase;
        [localDeckUseCase release];
        
        [self startObserving];
    }
    
    return self;
}

- (void)dealloc {
    [_queue release];
    [_localDeckUseCase release];
    [super dealloc];
}

- (void)addHSCards:(NSArray<HSCard *> *)hsCards {
    [self.localDeckUseCase addHSCards:hsCards toLocalDeck:self.localDeck validation:^(NSError * _Nullable error) {
        if (error != nil) {
            [self postErrorOccurredEvent:error];
        }
    }];
}

- (NSDictionary<NSString *, NSString *> * _Nullable)optionsForLocalDeckClassId {
    if (self.localDeck == nil) return nil;
    
    NSMutableDictionary<NSString *, NSString *> *options = [BlizzardHSAPIDefaultOptions() mutableCopy];
    options[BlizzardHSAPIOptionTypeClass] = NSStringFromHSCardClass(self.localDeck.classId.unsignedIntegerValue);
    
    HSCardSet cardSet;
    if ([self.localDeck.format isEqualToString:HSDeckFormatStandard]) {
        cardSet = HSCardSetStandardCards;
    } else if ([self.localDeck.format isEqualToString:HSDeckFormatWild]) {
        cardSet = HSCardSetWildCards;
    } else if ([self.localDeck.format isEqualToString:HSDeckFormatClassic]) {
        cardSet = HSCardSetClassicCards;
    } else {
        cardSet = HSCardSetWildCards;
    }
    options[BlizzardHSAPIOptionTypeSet] = NSStringFromHSCardSet(cardSet);
    
    return [options autorelease];
}

- (void)startObserving {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(localDeckChangesReceived:)
                                               name:LocalDeckUseCaseObserveDataNotificationName
                                             object:self.localDeckUseCase];
}

- (void)localDeckChangesReceived:(NSNotification *)notification {
    if (self.localDeck != nil) {
        [self.localDeckUseCase fetchWithObjectId:self.localDeck.objectID completion:^(LocalDeck * _Nullable localDeck) {
            self.localDeck = localDeck;
        }];
    }
}

- (void)postErrorOccurredEvent:(NSError *)error {
    [NSNotificationCenter.defaultCenter postNotificationName:DeckAddCardsViewModelErrorOccurredNotificationKey
                                                      object:self
                                                    userInfo:@{DeckAddCardsViewModelErrorOccurredErrorItemKey: error}];
}

@end
