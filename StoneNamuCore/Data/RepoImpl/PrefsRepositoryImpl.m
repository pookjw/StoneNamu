//
//  PrefsRepositoryImpl.m
//  PrefsRepositoryImpl
//
//  Created by Jinwoo Kim on 8/14/21.
//

#import "PrefsRepositoryImpl.h"
#import "CoreDataStackImpl.h"
#import "NSManagedObject+_fetchRequest.h"

@interface PrefsRepositoryImpl ()
@property (retain) id<CoreDataStack> coreDataStack;
@end

@implementation PrefsRepositoryImpl

- (instancetype)init {
    self = [super init];
    
    if (self) {
        CoreDataStackImpl *coreDataStack = [[CoreDataStackImpl alloc] initWithModelName:@"PrefsModel" storeContainerClass:[NSPersistentContainer class]];
        self.coreDataStack = coreDataStack;
        [coreDataStack release];
        
        [self startObserving];
    }
    
    return self;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
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
                    Prefs *prefs = [self makeNewPrefs];
                    completion(prefs, error);
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

- (Prefs *)makeNewPrefs {
    Prefs *prefs = [[Prefs alloc] initWithContext:self.coreDataStack.context];
    [self saveChanges];
    return [prefs autorelease];
}

@end
