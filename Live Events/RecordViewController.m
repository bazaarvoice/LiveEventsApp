//
//  RecordViewController.m
//  Live Events
//
//  Created by Alex Medearis on 7/30/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import "RecordViewController.h"
#import "PublishViewController.h"

#define CAPTURE_FRAMES_PER_SECOND		20

@interface RecordViewController ()

@property (weak, nonatomic) IBOutlet UIView *videoContainer;
@property (weak, nonatomic) IBOutlet UIButton *recordStopButton;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionText;
@property (weak, nonatomic) IBOutlet UIImageView *arrow;

@end

@implementation RecordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidLoad];
    self.arrow.hidden = YES;
    [self setLabel];
    [self setUpCaptureSession];
}

- (void)setLabel {
    const CGFloat fontSize = 17;
    UIFont *boldFont = [UIFont boldSystemFontOfSize:fontSize];
    UIFont *regularFont = [UIFont systemFontOfSize:fontSize];
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys: regularFont, NSFontAttributeName, nil];
    
    NSDictionary *boldAttrs = [NSDictionary dictionaryWithObjectsAndKeys:boldFont, NSFontAttributeName, nil];
    const NSRange boldRange = NSMakeRange(17,4);
    const NSRange boldRange2 = NSMakeRange(64,7);
    
    NSString * text = @"Hello my name is Mike and I gave Men+Care extra fresh deodorant 3 stars because....";
    
    // Create the attributed string (text + attributes)
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:attrs];
    [attributedText setAttributes:boldAttrs range:boldRange];
    [attributedText setAttributes:boldAttrs range:boldRange2];

    
    // Set it in our UILabel and we are done!
    self.descriptionText.attributedText = attributedText;
}


- (IBAction)backClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)chooseAProductClicked:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


// Taken from http://www.ios-developer.net/iphone-ipad-programmer/development/camera/record-video-with-avcapturesession-2
- (void)setUpCaptureSession {
    //---------------------------------
	//----- SETUP CAPTURE SESSION -----
	//---------------------------------
	NSLog(@"Setting up capture session");
	self.captureSession = [[AVCaptureSession alloc] init];
	
	//----- ADD INPUTS -----
	NSLog(@"Adding video input");
	
	//ADD VIDEO INPUT
	NSError *error;
    self.videoInputDevice = [[AVCaptureDeviceInput alloc] initWithDevice:[self CameraWithPosition:AVCaptureDevicePositionFront] error:&error];
    if (!error)
    {
        if ([self.captureSession canAddInput:self.videoInputDevice])
            [self.captureSession addInput:self.videoInputDevice];
        else
            NSLog(@"Couldn't add video input");
    }
    else
    {
        NSLog(@"Couldn't create video input");
    }
	
	//ADD AUDIO INPUT
	NSLog(@"Adding audio input");
	AVCaptureDevice *audioCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
	error = nil;
	AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioCaptureDevice error:&error];
	if (audioInput)
	{
		[self.captureSession addInput:audioInput];
	}
	
	
	//----- ADD OUTPUTS -----
	
	//ADD VIDEO PREVIEW LAYER
	NSLog(@"Adding video preview layer");
	self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
	[self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
	self.previewLayer.connection.videoOrientation = [self orientationForInterfaceOrientation:[[UIDevice currentDevice] orientation]];
	
	//ADD MOVIE FILE OUTPUT
	NSLog(@"Adding movie file output");
	self.movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
	
	Float64 TotalSeconds = 60;			//Total seconds
	int32_t preferredTimeScale = 30;	//Frames per second
	CMTime maxDuration = CMTimeMakeWithSeconds(TotalSeconds, preferredTimeScale);	//<<SET MAX DURATION
	self.movieFileOutput.maxRecordedDuration = maxDuration;
	
	self.movieFileOutput.minFreeDiskSpaceLimit = 1024 * 1024;						//<<SET MIN FREE SPACE IN BYTES FOR RECORDING TO CONTINUE ON A VOLUME
	
	if ([self.captureSession canAddOutput:self.movieFileOutput])
		[self.captureSession addOutput:self.movieFileOutput];
    
	//SET THE CONNECTION PROPERTIES (output properties)
	[self CameraSetOutputProperties];			//(We call a method as it also has to be done after changing camera)
    
    
	
	//----- SET THE IMAGE QUALITY / RESOLUTION -----
	//Options:
	//	AVCaptureSessionPresetHigh - Highest recording quality (varies per device)
	//	AVCaptureSessionPresetMedium - Suitable for WiFi sharing (actual values may change)
	//	AVCaptureSessionPresetLow - Suitable for 3G sharing (actual values may change)
	//	AVCaptureSessionPreset640x480 - 640x480 VGA (check its supported before setting it)
	//	AVCaptureSessionPreset1280x720 - 1280x720 720p HD (check its supported before setting it)
	//	AVCaptureSessionPresetPhoto - Full photo resolution (not supported for video output)
	NSLog(@"Setting image quality");
	[self.captureSession setSessionPreset:AVCaptureSessionPresetMedium];
	if ([self.captureSession canSetSessionPreset:AVCaptureSessionPreset640x480])		//Check size based configs are supported before setting them
		[self.captureSession setSessionPreset:AVCaptureSessionPreset640x480];
    
    
	
	//----- DISPLAY THE PREVIEW LAYER -----
	//Display it full screen under out view controller existing controls
	NSLog(@"Display the preview layer");
    CGRect previewLayerBounds = CGRectMake(0, 0, 480, 360);
    [self.previewLayer setBounds:previewLayerBounds];
	[self.previewLayer setPosition:CGPointMake(CGRectGetMidX(previewLayerBounds),
                                          CGRectGetMidY(previewLayerBounds))];
	//[[[self view] layer] addSublayer:[[self CaptureManager] previewLayer]];
	//We use this instead so it goes on a layer behind our UI controls (avoids us having to manually bring each control to the front):
	UIView *CameraView = [[UIView alloc] init];
    CameraView.translatesAutoresizingMaskIntoConstraints = NO;
	//[ addSubview:CameraView];
	//[self.view sendSubviewToBack:CameraView];
	
	//[[CameraView layer] addSublayer:self.previewLayer];
	[self.videoContainer.layer addSublayer:self.previewLayer];
	
	//----- START THE CAPTURE SESSION RUNNING -----
	[self.captureSession startRunning];
}

//********** CAMERA SET OUTPUT PROPERTIES **********
- (void) CameraSetOutputProperties
{
	//SET THE CONNECTION PROPERTIES (output properties)
	self.captureConnection = [self.movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
    self.captureConnection.videoOrientation = [self orientationForInterfaceOrientation:[[UIDevice currentDevice] orientation]];;
	
	//Set frame rate (if requried)
	CMTimeShow(self.captureConnection.videoMinFrameDuration);
	CMTimeShow(self.captureConnection.videoMaxFrameDuration);
	
	if (self.captureConnection.supportsVideoMinFrameDuration)
		self.captureConnection.videoMinFrameDuration = CMTimeMake(1, CAPTURE_FRAMES_PER_SECOND);
	if (self.captureConnection.supportsVideoMaxFrameDuration)
		self.captureConnection.videoMaxFrameDuration = CMTimeMake(1, CAPTURE_FRAMES_PER_SECOND);
	
	CMTimeShow(self.captureConnection.videoMinFrameDuration);
	CMTimeShow(self.captureConnection.videoMaxFrameDuration);
}

//********** GET CAMERA IN SPECIFIED POSITION IF IT EXISTS **********
- (AVCaptureDevice *) CameraWithPosition:(AVCaptureDevicePosition) Position
{
	NSArray *Devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
	for (AVCaptureDevice *Device in Devices)
	{
		if ([Device position] == Position)
		{
			return Device;
		}
	}
	return nil;
}

//********** START STOP RECORDING BUTTON **********
- (IBAction)StartStopButtonPressed:(id)sender
{
	
	if (!self.isRecording)
	{
		//----- START RECORDING -----
		NSLog(@"START RECORDING");
		self.isRecording = YES;
        self.topLabel.text = @"Look at the camera";
        self.arrow.hidden = NO;
        [self.recordStopButton setBackgroundImage:[UIImage imageNamed:@"a_vid_Stop-Button"] forState:UIControlStateNormal];
		
		//Create temporary URL to record to
		NSString *outputPath = [[NSString alloc] initWithFormat:@"%@%@", NSTemporaryDirectory(), @"output.mov"];
		NSURL *outputURL = [[NSURL alloc] initFileURLWithPath:outputPath];
		NSFileManager *fileManager = [NSFileManager defaultManager];
		if ([fileManager fileExistsAtPath:outputPath])
		{
			NSError *error;
			if ([fileManager removeItemAtPath:outputPath error:&error] == NO)
			{
				//Error - handle if requried
			}
		}
		//Start recording
        @try {
            [self.movieFileOutput startRecordingToOutputFileURL:outputURL recordingDelegate:self];
        } @catch (NSException * error){
            NSLog(@"%@", error);
        }
	}
	else
	{
		//----- STOP RECORDING -----
		NSLog(@"STOP RECORDING");
		self.isRecording = NO;
        [self.recordStopButton setBackgroundImage:[UIImage imageNamed:@"a_vid_Record-Button"] forState:UIControlStateNormal];
		[self.movieFileOutput stopRecording];
	}
}


//********** DID FINISH RECORDING TO OUTPUT FILE AT URL **********
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput
didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL
	  fromConnections:(NSArray *)connections
				error:(NSError *)error
{
    
	NSLog(@"didFinishRecordingToOutputFileAtURL - enter");
	
    BOOL RecordedSuccessfully = YES;
    if ([error code] != noErr)
	{
        // A problem occurred: Find out if the recording was successful.
        id value = [[error userInfo] objectForKey:AVErrorRecordingSuccessfullyFinishedKey];
        if (value)
		{
            RecordedSuccessfully = [value boolValue];
        }
    }
	if (RecordedSuccessfully)
	{
		//----- RECORDED SUCESSFULLY -----
        NSLog(@"didFinishRecordingToOutputFileAtURL - success");
		ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
		if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputFileURL])
		{
			[library writeVideoAtPathToSavedPhotosAlbum:outputFileURL
										completionBlock:^(NSURL *assetURL, NSError *error)
             {
                 if (error)
                 {
                     
                 } else {
                     self.productToReview.localVideoPath = assetURL.absoluteString;
                     [self performSegueWithIdentifier:@"publish" sender:nil];
                 }
             }];
		}

	}
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"publish"])
    {
        // Get reference to the destination view controller
        PublishViewController *pubVC = [segue destinationViewController];
        pubVC.productToReview = (ProductReview *)self.productToReview;
        pubVC.managedObjectContext = self.managedObjectContext;
    }
}

-(AVCaptureVideoOrientation)orientationForInterfaceOrientation:(UIInterfaceOrientation)orientation {
    if(orientation == UIInterfaceOrientationLandscapeLeft) {
        return AVCaptureVideoOrientationLandscapeLeft;
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        return AVCaptureVideoOrientationLandscapeRight;
    }
    return AVCaptureVideoOrientationLandscapeLeft;
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if(!self.isRecording){
        self.captureConnection.videoOrientation = [self orientationForInterfaceOrientation:toInterfaceOrientation];
        self.previewLayer.connection.videoOrientation = [self orientationForInterfaceOrientation:toInterfaceOrientation];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
