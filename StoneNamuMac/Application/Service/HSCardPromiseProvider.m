//
//  HSCardPromiseProvider.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/23/21.
//

#import "HSCardPromiseProvider.h"
#import "NSImage+pngData.h"
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

@interface HSCardPromiseProvider () <NSFilePromiseProviderDelegate>
@property (copy) HSCard *hsCard;
@property (retain) NSImage *image;
@property (retain) NSData *imagePNGData;
@property (retain) NSURL *imageURL;
@property (retain) NSOperationQueue *queue;
@end

@implementation HSCardPromiseProvider

- (instancetype)initWithHSCard:(HSCard *)hsCard image:(NSImage *)image {
    UTType *type = [UTType typeWithFilenameExtension:@"png"];
    
    self = [self initWithFileType:type.identifier delegate:self];
    
    if (self) {
        self.hsCard = hsCard;
        self.image = image;
        
        NSOperationQueue *queue = [NSOperationQueue new];
        self.queue = queue;
        queue.qualityOfService = NSQualityOfServiceUserInteractive;
        [queue release];
        
        //
    
        NSURL *imageURL = [[NSFileManager.defaultManager temporaryDirectory] URLByAppendingPathComponent:[hsCard.name stringByAppendingString:@".png"]];
        self.imageURL = imageURL;
    
        NSData *imagePNGData = image.pngData;
        if ([NSFileManager.defaultManager fileExistsAtPath:imageURL.path]) {
            [NSFileManager.defaultManager removeItemAtURL:imageURL error:nil];
        }
        [imagePNGData writeToURL:imageURL options:NSDataWritingAtomic error:nil];
    }
    
    return self;
}

- (void)dealloc {
    [_hsCard release];
    [_image release];
    [_imagePNGData release];
    [_imageURL release];
    [_queue release];
    [super dealloc];
}

- (NSString *)imageFileName {
    return [self.hsCard.name stringByAppendingString:@".png"];
}

- (NSArray<NSPasteboardType> *)writableTypesForPasteboard:(NSPasteboard *)pasteboard {
    NSMutableArray<NSPasteboardName> *mutable = [[super writableTypesForPasteboard:pasteboard] mutableCopy];
    
    [mutable addObject:NSPasteboardTypeFileURL];
    [mutable addObject:NSPasteboardTypePNG];
    
    return [mutable autorelease];
}

- (id)pasteboardPropertyListForType:(NSPasteboardType)type {
    if ([type isEqualToString:NSPasteboardTypeFileURL]) {
        return [self.imageURL pasteboardPropertyListForType:type];
    } else if ([type isEqualToString:NSPasteboardTypePNG]) {
        return self.imagePNGData;
    } else {
        return [super pasteboardPropertyListForType:type];
    }
}

- (NSPasteboardWritingOptions)writingOptionsForType:(NSPasteboardType)type pasteboard:(NSPasteboard *)pasteboard {
    return [super writingOptionsForType:type pasteboard:pasteboard];
}

#pragma mark - NSFilePromiseProviderDelegate

- (nonnull NSString *)filePromiseProvider:(nonnull NSFilePromiseProvider *)filePromiseProvider fileNameForType:(nonnull NSString *)fileType {
    return self.imageFileName;
}

- (void)filePromiseProvider:(nonnull NSFilePromiseProvider *)filePromiseProvider writePromiseToURL:(nonnull NSURL *)url completionHandler:(nonnull void (^)(NSError * _Nullable))completionHandler {
    
    NSError * _Nullable error = nil;
    
    NSURL *newURL = url;
    NSUInteger index = 1;
    
    while ([NSFileManager.defaultManager fileExistsAtPath:newURL.path]) {
        NSString *newName = [url.lastPathComponent stringByAppendingString:[NSString stringWithFormat:@" (%lu)", index]];
        newURL = [[[newURL URLByDeletingLastPathComponent] URLByAppendingPathComponent:newName] URLByAppendingPathExtension:newURL.pathExtension];
        index += 1;
    }
    
    [NSFileManager.defaultManager copyItemAtURL:self.imageURL toURL:newURL error:&error];
    
    completionHandler(error);
}

- (NSOperationQueue *)operationQueueForFilePromiseProvider:(NSFilePromiseProvider *)filePromiseProvider {
    return self.queue;
}

@end
