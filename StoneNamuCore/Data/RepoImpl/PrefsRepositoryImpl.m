//
//  PrefsRepositoryImpl.m
//  PrefsRepositoryImpl
//
//  Created by Jinwoo Kim on 8/14/21.
//

#import "PrefsRepositoryImpl.h"
#import <StoneNamuCore/CoreDataStackImpl.h>
#import <StoneNamuCore/NSManagedObject+_fetchRequest.h>

typedef void (^PrefsRepositoryImplMakeWithCompletion)(Prefs *);

@interface PrefsRepositoryImpl ()
@property (retain) id<CoreDataStack> coreDataStack;
@end

@implementation PrefsRepositoryImpl

- (instancetype)init {
    self = [super init];
    
    if (self) {
        CoreDataStackImpl *coreDataStack = [[CoreDataStackImpl alloc] initWithModelName:@"PrefsModel" storeContainerClass:[NSPersistentContainer class] models:@[@"PrefsModel"]];
        self.coreDataStack = coreDataStack;
        [coreDataStack release];
        
        [self startObserving];
    }
    
    return self;
}

- (void)dealloc {
    [_coreDataStack release];
    [super dealloc];
}

- (void)fetchWithCompletion:(PrefsRepositoryFetchWithCompletion)completion {
    [self.coreDataStack.queue addBarrierBlock:^{
        NSManagedObjectContext *context = self.coreDataStack.context;
        
        [context performBlockAndWait:^{
            @autoreleasepool {
                NSFetchRequest *fetchRequest = Prefs._fetchRequest;
                
                NSError * _Nullable error = nil;
                NSArray<Prefs *> *results = [context executeFetchRequest:fetchRequest error:&error];
                
                if (error) {
                    completion(nil, error);
                    return;
                }
                
                if (results.count == 0) {
                    [self makeNewPrefsWithCompletion:^(Prefs * prefs) {
                        [self saveChanges];
                        completion(prefs, error);
                    }];
                } else {
                    completion(results.lastObject, error);
                }
            }
        }];
    }];
}

- (void)saveChanges {
    [self.coreDataStack saveChanges];
}

- (void)startObserving {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(changesReceived:)
                                               name:CoreDataStackDidChangeNotificationName
                                             object:self.coreDataStack];
}

- (void)changesReceived:(NSNotification *)notification {
    [self fetchWithCompletion:^(Prefs * _Nullable prefs, NSError * _Nullable error) {
        if (prefs) {
            [NSNotificationCenter.defaultCenter postNotificationName:PrefsRepositoryObserveDataNotificationName
                                                              object:self
                                                            userInfo:@{PrefsRepositoryPrefsNotificationItemKey: prefs}];
        }
    }];
}

- (void)makeNewPrefsWithCompletion:(PrefsRepositoryImplMakeWithCompletion)completion {
    [self.coreDataStack.queue addBarrierBlock:^{
        Prefs *prefs = [[Prefs alloc] initWithContext:self.coreDataStack.context];
        completion(prefs);
    }];
}

@end
