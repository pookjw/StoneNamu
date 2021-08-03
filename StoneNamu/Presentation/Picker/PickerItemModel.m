//
//  PickerItemModel.m
//  PickerItemModel
//
//  Created by Jinwoo Kim on 7/25/21.
//

#import "PickerItemModel.h"

@implementation PickerItemModel

- (instancetype)initWithImage:(UIImage * _Nullable)image title:(NSString *)title identity:(NSString *)identity {
    self = [self init];
    
    if (self) {
        _image = [image copy];
        _title = [title copy];
        _identity = [identity copy];
    }
    
    return self;
}

- (void)dealloc {
    [_image release];
    [_title release];
    [_identity release];
    [super dealloc];
}

@end