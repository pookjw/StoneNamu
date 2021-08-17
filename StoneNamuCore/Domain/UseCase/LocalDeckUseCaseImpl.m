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

- (void)deleteLocalDeck:(nonnull LocalDeck *)localDeck {
    [self.localDeckRepository deleteLocalDeck:localDeck];
}

- (void)fetchWithCompletion:(nonnull LocalDeckUseCaseFetchWithCompletion)completion {
    [self.localDeckRepository fetchWithCompletion:completion];
}

- (nonnull LocalDeck *)makeLocalDeck {
    return [self.localDeckRepository makeLocalDeck];
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
    NSArray<LocalDeck *> * _Nullable decks = notification.userInfo[LocalDeckRepositoryLocalDeckNotificationItemKey];
    
    if (decks) {
        [NSNotificationCenter.defaultCenter postNotificationName:LocalDeckUseCaseObserveDataNotificationName
                                                          object:self
                                                        userInfo:@{LocalDeckUseCaseLocalDeckNotificationItemKey: decks}];
    }
}

@end
