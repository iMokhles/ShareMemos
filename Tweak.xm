
// Logos by Dustin Howett
// See http://iphonedevwiki.net/index.php/Logos

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>
#import "TTOpenInAppActivity.h"
#import "WHMailActivity.h"
#import "WHTextActivity.h"
//#import "ShareMemosWindow.h"

@interface RCSavedRecording : NSManagedObject
@property(copy, nonatomic) NSString *path;
@end

@interface RCRecordingDetailViewController : UIViewController
@property(readonly, assign, nonatomic) RCSavedRecording* recording;
@end

@interface RCRecordingDetailViewController (ShareMemos_Tweak) <UIPopoverPresentationControllerDelegate>
@end

@interface RCRecordingsTableViewController : UITableViewController
@property(retain, nonatomic) RCSavedRecording* selectedRecording;
@end

@interface RCRecordingsTableViewController (ShareMemos_Tweak) <UIPopoverPresentationControllerDelegate>
@end

@interface RCRecordingPlaybackTableViewCell : UITableViewCell
@property(retain, nonatomic) RCSavedRecording* recording;
@end

// @interface RCRecordingPlaybackTableViewCell (ShareMemos) <ShareMemosWindowDelegate>
// @property(strong, nonatomic) ShareMemosWindow *shareWindow;
// - (void)shareMemosWindow;
// @end

#define kPreferencesPath @"/User/Library/Preferences/com.iosdevt.sharememosprefs.plist"
#define kPreferencesChanged "com.iosdevt.sharememosprefs.preferences-changed"

//static NSMutableDictionary *plist = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.iosdevt.sharememosprefs.plist"];
static BOOL value = NO;
#define kEnableTweak @"enable"

static void ShareMemosInitPrefs() {
    NSDictionary *ShareMemosSettings = [NSDictionary dictionaryWithContentsOfFile:kPreferencesPath];

    NSNumber *ShareMemosEnableOptionKey = ShareMemosSettings[kEnableTweak];
    value = ShareMemosEnableOptionKey ? [ShareMemosEnableOptionKey boolValue] : 1;

}

%group iOS6
%hook RCRecordingDetailViewController

-(void)_shareMemo:(UIButton *)memo {
    %log; 
    //%orig;
    if (value) {
        NSURL *outURL = [NSURL fileURLWithPath:self.recording.path];
        
        NSArray *activitesApp;
        NSArray *activitesItem;
        
        NSString *htmlBody = @"<html><body><h1>Sent Through ShareMemos Tweak</h1></body></html>";
        
        TTOpenInAppActivity *EgyOpenIN = [[TTOpenInAppActivity alloc] initWithView:self.view andRect:memo.frame];
        WHMailActivity *mailActivity = [[WHMailActivity alloc] init];
        
        activitesApp = @[EgyOpenIN, mailActivity];
        activitesItem = @[outURL, [WHMailActivityItem mailActivityItemWithSelectionHandler:^
                                   (MFMailComposeViewController *mailController) {
                                       [mailController setSubject:@""];
                                       [mailController setMessageBody:htmlBody isHTML:YES];
                                       [mailController addAttachmentData:[NSData dataWithContentsOfURL:outURL] mimeType:@"audio/m4a" fileName:self.recording.path];
                                       mailController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                                   }], [WHTextActivityItem textActivityItemWithSelectionHandler:^(MFMessageComposeViewController *messageController) {
                                       if ([MFMessageComposeViewController canSendAttachments]) {
                                           [messageController setBody:@"Sent Through ShareMemos Tweak"];
                                           [messageController addAttachmentData:[NSData dataWithContentsOfURL:outURL] typeIdentifier:@"public.mpeg4" filename:self.recording.path];
                                           messageController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                                       }
                                   }]];
        
        UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activitesItem applicationActivities:activitesApp];
        
        activityController.excludedActivityTypes = (@[UIActivityTypeAssignToContact, UIActivityTypeMail, UIActivityTypeMessage, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll, UIActivityTypeCopyToPasteboard]);
        EgyOpenIN.superViewController = activityController;
        //[MMProgressHUD dismissWithSuccess:@"Success!"];
        
        [self presentViewController:activityController animated:YES completion:^{}];
    } else {
        %orig;
    }
}
%end
%end

%group iOS7

%hook RCRecordingsTableViewController
-(void)playbackCellShareButtonTapped:(id)arg1 {
    if (value) {
        NSURL *outURL = [NSURL fileURLWithPath:self.selectedRecording.path];
        UIBarButtonItem *barButton = nil;
        NSArray *activitesApp;
        NSArray *activitesItem;
        
        NSString *htmlBody = @"<html><body><h1>Sent Through ShareMemos Tweak</h1></body></html>";
        
        TTOpenInAppActivity *EgyOpenIN = [[TTOpenInAppActivity alloc] initWithView:self.view andBarButtonItem:barButton];
        WHMailActivity *mailActivity = [[WHMailActivity alloc] init];
        WHTextActivity *textActivity = [[WHTextActivity alloc] init];
        
        activitesApp = @[EgyOpenIN, mailActivity, textActivity];
        activitesItem = @[outURL, [WHMailActivityItem mailActivityItemWithSelectionHandler:^
                                   (MFMailComposeViewController *mailController) {
                                       [mailController setSubject:@""];
                                       [mailController setMessageBody:htmlBody isHTML:YES];
                                       [mailController addAttachmentData:[NSData dataWithContentsOfURL:outURL] mimeType:@"audio/m4a" fileName:@"Memo.m4a"];
                                       mailController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                                   }], [WHTextActivityItem textActivityItemWithSelectionHandler:^(MFMessageComposeViewController *messageController) {
                                       if ([MFMessageComposeViewController canSendAttachments]) {
                                           [messageController setBody:@"Sent Through ShareMemos Tweak"];
                                           [messageController addAttachmentData:[NSData dataWithContentsOfURL:outURL] typeIdentifier:@"public.mpeg4" filename:@"Memo.m4a"];
                                           messageController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                                       }
                                   }]];
        
        UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activitesItem applicationActivities:activitesApp];
        
        activityController.excludedActivityTypes = (@[UIActivityTypeAssignToContact, UIActivityTypeMail, UIActivityTypeMessage, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll, UIActivityTypeCopyToPasteboard]);
//        EgyOpenIN.superViewController = activityController;
        //[MMProgressHUD dismissWithSuccess:@"Success!"];
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
	                    // Store reference to superview (UIActionSheet) to allow dismissal
	                    EgyOpenIN.superViewController = activityController;
	                    // Show UIActivityViewController
	                    [self presentViewController:activityController animated:YES completion:NULL];
	                } else {
	                    // Create pop up
	                    UIPopoverPresentationController *presentPOP = activityController.popoverPresentationController;
			            activityController.popoverPresentationController.sourceRect = CGRectMake(400,200,0,0);
			            activityController.popoverPresentationController.sourceView = self.view;
			            presentPOP.permittedArrowDirections = UIPopoverArrowDirectionRight;
			            presentPOP.delegate = self;
			            presentPOP.sourceRect = CGRectMake(700,80,0,0);
			            presentPOP.sourceView = self.view;
			            EgyOpenIN.superViewController = presentPOP;
			            [self presentViewController:activityController animated:YES completion:NULL];

	                    // activityPopoverController = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
	                    // // Store reference to superview (UIPopoverController) to allow dismissal
	                    // openInAppActivity.superViewController = activityPopoverController;
	                    // // Show UIActivityViewController in popup
	                    // [activityPopoverController presentPopoverFromRect:imgView.frame inView:imgView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	                }
//        [self presentViewController:activityController animated:YES completion:^{}];
    } else {
        %orig;
    }
}
%end
%end

%ctor
{
        
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) 
        %init(iOS6);
        else %init(iOS7);

    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)ShareMemosInitPrefs, CFSTR(kPreferencesChanged), NULL, CFNotificationSuspensionBehaviorCoalesce);
    ShareMemosInitPrefs();
}
