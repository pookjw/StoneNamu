//
//  MainListItemModel.m
//  StoneNamuWatch WatchKit Extension
//
//  Created by Jinwoo Kim on 3/10/22.
//

#import "MainListItemModel.h"
#import <StoneNamuResources/StoneNamuResources.h>

@interface MainListItemModel ()
@property (retain, nonatomic) IBOutlet WKInterfaceImage *imageView;
@property (retain, nonatomic) IBOutlet WKInterfaceLabel *titleLabel;
@property (readonly, nonatomic) UIImage *image;
@property (readonly, nonatomic) NSString *title;
@end

@implementation MainListItemModel

- (void)dealloc {
    [_imageView release];
    [_titleLabel release];
    [super dealloc];
}

- (void)configureWithType:(MainListItemModelType)type {
    self->_type = type;
    
    [self.imageView setImage:self.image];
    [self.titleLabel setText:self.title];
}

- (UIImage *)image {
    switch (self.type) {
        case MainListItemModelTypeCardBacks:
            return [UIImage systemImageNamed:@"text.book.closed" withConfiguration:nil];
        case MainListItemModelTypePreferences:
            return [UIImage systemImageNamed:@"gearshape" withConfiguration:nil];
        default:
            return nil;
    }
}

- (NSString *)title {
    switch (self.type) {
        case MainListItemModelTypeCardBacks:
            return @"Card Backs (DEMO)";
        case MainListItemModelTypePreferences:
            return [ResourcesService localizationForKey:LocalizableKeyPreferences];
        default:
            return nil;
    }
}

@end
