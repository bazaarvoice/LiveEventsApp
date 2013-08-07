//
//  BVProductMediaPost.m
//  Live Events
//
//  Created by Alex Medearis on 8/6/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import "BVProductMediaPost.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface BVProductMediaPost ()

@property (atomic) BOOL hasData;

@end

@implementation BVProductMediaPost

-(id)initWithProductToPost:(ProductReview *)productToPost {
    self = [super initWithType:BVMediaPostTypeVideo];
    if(self){
        self.productToPost = productToPost;
        self.contentType = BVMediaPostContentTypeReview;
        NSURL *url = [NSURL URLWithString:productToPost.localVideoPath];
        ALAssetsLibrary *myAssetLib=[[ALAssetsLibrary alloc] init];
        [myAssetLib assetForURL:url
                    resultBlock:^(ALAsset *asset) {
                        ALAssetRepresentation *rep = [asset defaultRepresentation];
                        [self setVideo:[self getVideoDataFromRepresentation:rep] withFormat:BVVideoFormatTypeMOV];
                        NSLog(@"%@", self.delegate);
                        if(self.delegate){
                            [self send];
                        } else {
                            self.hasData = YES;
                        }
                    }
                   failureBlock:^(NSError *error){NSLog(@"test:Fail");}];
    }
    return self;
}

- (NSData *)getVideoDataFromRepresentation:(ALAssetRepresentation *)rep {
    Byte *buffer = (Byte*)malloc(rep.size);
    NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:rep.size error:nil];
    NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
    return data;
}

-(void)sendRequestWithDelegate:(id<BVDelegate>)delegate {
    [self setDelegate:delegate];
    if(self.hasData) {
        [self send];
    }
}

@end
