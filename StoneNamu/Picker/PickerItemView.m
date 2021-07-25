//
//  PickerItemView.m
//  PickerItemView
//
//  Created by Jinwoo Kim on 7/26/21.
//

#import "PickerItemView.h"

@interface PickerItemView ()
@property (retain, nonatomic) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *imageViewAspectLayout;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *imageViewWidthLayout;
@property (retain, nonatomic) IBOutlet UILabel *primaryLabel;
@property (retain, nonatomic) IBOutlet UILabel *secondaryLabel;
@end

@implementation PickerItemView

- (void)dealloc {
    [_imageView release];
    [_primaryLabel release];
    [_secondaryLabel release];
    [_imageViewAspectLayout release];
    [_imageViewWidthLayout release];
    [super dealloc];
}

- (void)configureWithImage:(UIImage * _Nullable)image primaryText:(NSString *)primaryText secondaryText:(NSString *)secondaryText {
    self.imageView.image = image;
    self.primaryLabel.text = primaryText;
    self.secondaryLabel.text = secondaryText;
    
    if (image) {
        [self.imageViewAspectLayout setActive:YES];
        [self.imageViewWidthLayout setActive:NO];
    } else {
        [self.imageViewAspectLayout setActive:NO];
        [self.imageViewWidthLayout setActive:YES];
    }
}

@end
