//
//  PrefsRepositoryImpl.m
//  PrefsRepositoryImpl
//
//  Created by Jinwoo Kim on 8/14/21.
//

#import "PrefsRepositoryImpl.h"
#import "CoreDataStackImpl.h"
#import "NSManagedObject+_fetchRequest.h"
#import "BlizzardAPIRegionHost.h"
#import "BlizzardHSAPILocale.h"

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
    [_coreDataStack release];
    [super dealloc];
}

- (void)fetchWithCompletion:(PrefsRepositoryFetchWithCompletion)completion {
    [self.coreDataStack.queue addBarrierBlock:^{
        NSManagedObjectContext *context = self.coreDataStack.context;
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
    }];
}

- (void)saveChanges {
    [self.coreDataStack saveChanges];
}

- (void)startObserving {
    [self postNotification];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(changesReceived:)
                                               name:NSManagedObjectContextDidSaveNotification
                                             object:self.coreDataStack.context];
}

- (void)changesReceived:(NSNotification *)notification {
    [self postNotification];
}

- (void)postNotification {
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
    
    NSLocale *locale = NSLocale.currentLocale;
    NSString * _Nullable countryCode = locale.countryCode;
    NSString *language = locale.languageCode;
    NSString *localeIdentifier = locale.localeIdentifier;
    
    if ([countryCode isEqualToString:@"US"]) {
        prefs.apiRegionHost = NSStringForAPIFromRegionHost(BlizzardAPIRegionHostUS);
    } else if ([countryCode isEqualToString:@"EU"]) {
        prefs.apiRegionHost = NSStringForAPIFromRegionHost(BlizzardAPIRegionHostEU);
    } else if ([countryCode isEqualToString:@"KR"]) {
        prefs.apiRegionHost = NSStringForAPIFromRegionHost(BlizzardAPIRegionHostKR);
    } else if ([countryCode isEqualToString:@"TW"]) {
        prefs.apiRegionHost = NSStringForAPIFromRegionHost(BlizzardAPIRegionHostTW);
    } else if ([countryCode isEqualToString:@"CN"]) {
        prefs.apiRegionHost = NSStringForAPIFromRegionHost(BlizzardAPIRegionHostCN);
    } else {
        prefs.apiRegionHost = NSStringForAPIFromRegionHost(BlizzardAPIRegionHostUS);
    }
    
    if ([language isEqualToString:@"en"]) {
        prefs.locale = BlizzardHSAPILocaleEnUS;
    } else if ([language isEqualToString:@"fr"]) {
        prefs.locale = BlizzardHSAPILocaleFrFR;
    } else if ([language isEqualToString:@"de"]) {
        prefs.locale = BlizzardHSAPILocaleDeDE;
    } else if ([language isEqualToString:@"it"]) {
        prefs.locale = BlizzardHSAPILocaleItIT;
    } else if ([language isEqualToString:@"ja"]) {
        prefs.locale = BlizzardHSAPILocaleJaJP;
    } else if ([language isEqualToString:@"ko"]) {
        prefs.locale = BlizzardHSAPILocaleKoKR;
    } else if ([language isEqualToString:@"pl"]) {
        prefs.locale = BlizzardHSAPILocalePlPL;
    } else if ([language isEqualToString:@"ru"]) {
        prefs.locale = BlizzardHSAPILocaleRuRU;
    } else if ([localeIdentifier isEqualToString:@"zh_CN"]) {
        prefs.locale = BlizzardHSAPILocaleZhCN;
    } else if ([language isEqualToString:@"es"]) {
        prefs.locale = BlizzardHSAPILocaleKoKR;
    } else if ([localeIdentifier isEqualToString:@"zh_TW"]) {
        prefs.locale = BlizzardHSAPILocaleZhTW;
    } else {
        prefs.locale = BlizzardHSAPILocaleEnUS;
    }
    
    return [prefs autorelease];
}

@end
