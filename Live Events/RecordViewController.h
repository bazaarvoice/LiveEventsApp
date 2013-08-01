//
//  RecordViewController.h
//  Live Events
//
//  Created by Alex Medearis on 7/30/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductReview.h"

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface RecordViewController : UIViewController<AVCaptureFileOutputRecordingDelegate> {

}

@property (strong) AVCaptureSession * captureSession;
@property (strong) AVCaptureMovieFileOutput * movieFileOutput;
@property (strong) AVCaptureDeviceInput * videoInputDevice;
@property (retain) AVCaptureVideoPreviewLayer *previewLayer;

@property (assign) BOOL isRecording;
@property (strong) ProductReview *productToReview;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

- (void) CameraSetOutputProperties;
- (AVCaptureDevice *) CameraWithPosition:(AVCaptureDevicePosition) Position;
- (IBAction)StartStopButtonPressed:(id)sender;

@end
