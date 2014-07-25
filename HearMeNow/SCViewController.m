//
//  SCViewController.m
//  HearMeNow
//
//  Created by Peter Lu on 7/24/14.
//  Copyright (c) 2014 Peter Lu. All rights reserved.
//

#import "SCViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface SCViewController ()

{
    BOOL hasRecording;  //Determines whether or not a recording has been made.
    AVAudioPlayer *soundPlayer; //Handles all audio playback.
    AVAudioRecorder *soundRecorder;  // Handles recording from the microphone.
    AVAudioSession *session; // Activates and deactivates the audio session.
    NSString *soundPath; // Holds the path for the recorded file.
}

@end

@implementation SCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    soundPath = [[NSString alloc] initWithFormat:@"%@%@", NSTemporaryDirectory(), @"hearmenow.wav"];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:soundPath];
    
    session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    
    NSError *error;
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error: & error];
    
    soundRecorder = [[AVAudioRecorder alloc] initWithURL:url
                                                settings:nil
                                                   error: & error];
    if (error)
    {
        NSLog(@"Error while initializing the recorder: %@", error);
    }
    
    soundRecorder.delegate = self;
    [soundRecorder prepareToRecord];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)recordPressed:(id)sender {
    
    if ([soundRecorder isRecording])
    {
        [soundRecorder stop];
        [self.recordButton setTitle:@"Record" forState:UIControlStateNormal];
    }
    else
    {
        [session requestRecordPermission:^(BOOL granted) {
            if(granted)
            {
                [soundRecorder record];
                [self.recordButton setTitle:@"Stop"
                                   forState:UIControlStateNormal];
            }
            else
            {
                NSLog(@"Unable to record");
            }
        }];
    }
    
}

- (IBAction)playPressed:(id)sender {
    if (soundPlayer.playing)
    {
        [soundPlayer pause];
        [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
    }
    else if (hasRecording)
    {
        NSURL *url = [[NSURL alloc] initFileURLWithPath:soundPath];
        NSError *error;
        soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        if (!error)
        {
            soundPlayer.delegate = self;
            [soundPlayer play];
        } else {
            NSLog(@"Error initializing player: %@", error);
        }
        [self.playButton setTitle:@"Pause" forState:UIControlStateNormal];
        hasRecording = NO;
    }
    else if (soundPlayer)
    {
        [soundPlayer play];
        [self.playButton setTitle:@"Pause" forState:UIControlStateNormal];
    }
    
}
@end
