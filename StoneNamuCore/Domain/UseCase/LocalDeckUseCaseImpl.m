//
//  LocalDeckUseCaseImpl.m
//  LocalDeckUseCaseImpl
//
//  Created by Jinwoo Kim on 8/17/21.
//

#import "LocalDeckUseCaseImpl.h"
#import "LocalDeckRepositoryImpl.h"

@interface LocalDeckUseCaseImpl ()
@property (retain) id<LocalDeckRepository> localDeckRepository;
@end

@implementation LocalDeckUseCaseImpl

- (instancetype)init {
    self = [super init];
    
    if (self) {
        LocalDeckRepositoryImpl *localDeckRepository = [LocalDeckRepositoryImpl new];
        self.localDeckRepository = localDeckRepository;
        [localDeckRepository release];
        
        [self startObserving];
    }
    
    return self;
}

- (void)dealloc {
    [_localDeckRepository release];
    [super dealloc];
}

- (void)deleteLocalDeck:(nonnull LocalDeck *)localDeck {
    [self.localDeckRepository deleteLocalDeck:localDeck];
}

- (void)fetchWithCompletion:(nonnull LocalDeckUseCaseFetchWithCompletion)completion {
    [self.localDeckRepository fetchWithCompletion:completion];
}

- (void)fetchWithObjectId:(NSManagedObjectID *)objectId completion:(LocalDeckUseCaseFetchWithObjectIdCompletion)completion {
    [self.localDeckRepository fetchWithObjectId:objectId completion:completion];
}

- (nonnull LocalDeck *)makeLocalDeck {
    return [self.localDeckRepository makeLocalDeck];
}

- (LocalDeck *)makeLocalDeckFromHSDeck:(HSDeck *)hsDeck {
    LocalDeck *localDeck = [self makeLocalDeck];
    
    NSMutableArray<NSNumber *> *cards = [@[] mutableCopy];
    [hsDeck.cards enumerateObjectsUsingBlock:^(HSCard * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [cards addObject:[NSNumber numberWithUnsignedInteger:obj.cardId]];
    }];
    localDeck.cards = cards;
    [cards release];
    
    localDeck.isWild = [NSNumber numberWithBool:[hsDeck.format isEqualToString:HSDeckFormatWild]];
    localDeck.classId = [NSNumber numberWithUnsignedInteger:hsDeck.classId];
    localDeck.deckCode = [[hsDeck.deckCode copy] autorelease];
    localDeck.name = nil;
    
    return localDeck;
}

- (void)saveChanges {
    [self.localDeckRepository saveChanges];
}

- (void)startObserving {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(changesReceived:)
                                               name:LocalDeckRepositoryObserveDataNotificationName
                                             object:self.localDeckRepository];
}

- (void)changesReceived:(NSNotification *)notification {
    [NSNotificationCenter.defaultCenter postNotificationName:LocalDeckUseCaseObserveDataNotificationName
                                                      object:self
                                                    userInfo:nil];
}

@end
