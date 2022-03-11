//
//  MainListInterfaceController.m
//  StoneNamuWatch WatchKit Extension
//
//  Created by Jinwoo Kim on 3/10/22.
//

#import "MainListInterfaceController.h"
#import "MainListItemModel.h"
#import "CardBacksController.h"
#import <StoneNamuResources/StoneNamuResources.h>

@interface MainListInterfaceController ()
@property (retain, nonatomic) IBOutlet WKInterfaceTable *table;
@end

@implementation MainListInterfaceController

- (void)dealloc {
    [_table release];
    [super dealloc];
}

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    [self setAttributes];
    [self configureItems];
}

- (void)setAttributes {
    [self setTitle:[ResourcesService localizationForKey:LocalizableKeyAppName]];
}

- (void)configureItems {
    [self.table setNumberOfRows:2 withRowType:@"MainListItemModel"];
    
    MainListItemModel *cardBacksItemModel = [self.table rowControllerAtIndex:0];
    [cardBacksItemModel configureWithType:MainListItemModelTypeCardBacks];
    
    MainListItemModel *preferencesItemModel = [self.table rowControllerAtIndex:1];
    [preferencesItemModel configureWithType:MainListItemModelTypePreferences];
}

- (void)presentCardBacks {
    CardBacksController *cardBacksController = [CardBacksController new];
    [cardBacksController push];
    [cardBacksController release];
}

- (void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex {
    if ([table isEqual:self.table]) {
        MainListItemModel *itemModel = [table rowControllerAtIndex:rowIndex];
        
        switch (itemModel.type) {
            case MainListItemModelTypeCardBacks:
                [self presentCardBacks];
                break;
            default:
                break;
        }
    }
}

@end
