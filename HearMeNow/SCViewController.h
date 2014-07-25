//
//  SCViewController.h
//  HearMeNow
//
//  Created by Peter Lu on 7/24/14.
//  Copyright (c) 2014 Peter Lu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface SCViewController : UIViewController <AVAudioPlayerDelegate, AVAudioRecorderDelegate>
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
- (IBAction)recordPressed:(id)sender;
- (IBAction)playPressed:(id)sender;

@end
