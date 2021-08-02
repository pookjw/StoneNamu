//
//  CoreDataStackImpl.m
//  CoreDataStackImpl
//
//  Created by Jinwoo Kim on 8/2/21.
//

#import "CoreDataStackImpl.h"

static NSMutableDictionary<NSString *, NSPersistentContainer *> * _Nullable kStoreContainers = nil;

@interface CoreDataStackImpl () {
    NSPersistentContainer *_storeContainer;
}

@end

@implementation CoreDataStackImpl

@synthesize storeContainer = _storeContainer;

- (instancetype)initWithModelName:(NSString *)modelName storeContainerClass:(Class)storeContainerClass {
    self = [self init];
    
    if (self) {
        [self configureStoreContainerWithModelName:modelName class:storeContainerClass];
        [self bind];
    }
    
    return self;
}

- (NSManagedObjectContext *)mainContext {
    return self.storeContainer.viewContext;
}

- (void)saveChanges {
    if (!self.mainContext.hasChanges) {
        return;
    }
    
    [self.mainContext save:nil];
}

- (void)configureStoreContainerWithModelName:(NSString *)modelName class:(Class)class {
    if (kStoreContainers == nil) {
        kStoreContainers = [@{} mutableCopy];
    }
    
    if (kStoreContainers[modelName]) {
        _storeContainer = kStoreContainers[modelName];
        return;
    }
    
    NSBundle *bundle = [NSBundle bundleWithIdentifier:@"com.pookjw.StoneNamuCore"];
    NSURL *modelURL = [bundle URLForResource:modelName withExtension:@"momd"];
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSPersistentContainer *container = [class persistentContainerWithName:modelName managedObjectModel:model];
    [model release];
    
    [container loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription * _Nonnull description, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    kStoreContainers[modelName] = container;
    _storeContainer = container;
}

- (void)bind {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(didReceiveChangeEvent:)
                                               name:NSManagedObjectContextDidSaveNotification
                                             object:self.mainContext];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(didReceiveChangeEvent:)
                                               name:NSPersistentCloudKitContainerEventChangedNotification
                                             object:self.storeContainer];
}

- (void)didReceiveChangeEvent:(NSNotification *)notification {
    [NSNotificationCenter.defaultCenter postNotificationName:CoreDataStackDidChangeNotificationName
                                                      object:self
                                                    userInfo:nil];
}

@end
