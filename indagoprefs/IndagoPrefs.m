#import "IndagoPrefs.h"

@interface IndagoPrefsListController: PSListController
- (void)respring;
- (void)followLogan;
@end

@implementation IndagoPrefsListController
- (id)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"IndagoPrefs" target:self] retain];
	}

	return _specifiers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *twitterButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/IndagoPrefs.bundle/IndagoTwitter.png"] style:UIBarButtonItemStyleDone target:self action:@selector(share:)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:twitterButton, nil];
}

- (void)viewDidAppear:(BOOL)animated {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/IndagoPrefs.bundle/IndagoPrefs.png"]];
    imageView.frame = CGRectMake(0.0, 0.0, 29.0, 29.0);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = imageView;

    [super viewDidAppear:animated];
}

- (void)respring {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Respring?" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    
    [alertView show];
}

- (void)followLogan {
	NSString *user = @"logandev22";

	if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:"]]) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetbot:///user_profile/" stringByAppendingString:user]]];
	}
	
	else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific:"]]) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitterrific:///profile?screen_name=" stringByAppendingString:user]]];
	}
	
	else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetings:"]]) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetings:///user?screen_name=" stringByAppendingString:user]]];
	}
	
	else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]]) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitter://user?screen_name=" stringByAppendingString:user]]];
	}
	
	else {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"https://mobile.twitter.com/" stringByAppendingString:user]]];
	}
}

- (void)share:(id)sender {
    TWTweetComposeViewController *tweetComposeViewController = [[TWTweetComposeViewController alloc] init];
    [tweetComposeViewController setInitialText:@"#Indago - The Internet, at your fingertips. Developed by @logandev22"];
    
    [self.navigationController presentViewController:tweetComposeViewController animated:YES completion:^{
    	
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1.0) {
        CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.TweaksByLogan.Indago/respring"), NULL, NULL, YES);
    }
}
@end

@interface IndagoSettingsController: PSListController
@end

@implementation IndagoSettingsController
- (id)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"IndagoSettings" target:self] retain];
	}

	return _specifiers;
}

- (void)viewDidAppear:(BOOL)animated {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/IndagoPrefs.bundle/IndagoSettings.png"]];
    imageView.frame = CGRectMake(0.0, 0.0, 29.0, 29.0);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = imageView;

    [super viewDidAppear:animated];
}
@end

@interface IndagoInstructionsController: PSListController
@end

@implementation IndagoInstructionsController
- (id)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"IndagoInstructions" target:self] retain];
	}

	return _specifiers;
}

- (void)viewDidAppear:(BOOL)animated {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/IndagoPrefs.bundle/IndagoInstructions.png"]];
    imageView.frame = CGRectMake(0.0, 0.0, 29.0, 29.0);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = imageView;

    [super viewDidAppear:animated];
}
@end

@interface IndagoSupportController : PSListController <MFMailComposeViewControllerDelegate> {
    MFMailComposeViewController *mailComposeViewController;
}
@end

@implementation IndagoSupportController
- (id)specifiers {
	if ([MFMailComposeViewController canSendMail]) {
		mailComposeViewController = [[MFMailComposeViewController alloc] init];
	    mailComposeViewController.mailComposeDelegate = self;
	    [mailComposeViewController setToRecipients:[NSArray arrayWithObjects:@"Logan O'Connell <logan.developeremail@gmail.com>", nil]];
	    [mailComposeViewController setSubject:[NSString stringWithFormat:@"Indago Support"]];
	    [mailComposeViewController setMessageBody:[NSString stringWithFormat:@"\n\n\nDevice: %@ on iOS %@", (NSString *)MGCopyAnswer(CFSTR("ProductType")), (NSString *)MGCopyAnswer(CFSTR("ProductVersion"))] isHTML:NO];

	    [self.navigationController presentViewController:mailComposeViewController animated:YES completion:^{

	    }];
	}

	else {
		[self.navigationController popViewControllerAnimated:YES];
	}

    return nil;
}

- (void)viewWillAppear:(BOOL)animated {
	[self.navigationItem setTitle:@""];

	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/IndagoPrefs.bundle/IndagoSupport.png"]];
    imageView.frame = CGRectMake(0.0, 0.0, 29.0, 29.0);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = imageView;

    [super viewDidAppear:animated];
}

- (void)mailComposeController:(MFMailComposeViewController *)viewController didFinishWithResult:(id)result error:(NSError *)error {
    [viewController dismissViewControllerAnimated:YES completion:^{

    }];

    [self.navigationController popViewControllerAnimated:YES];
}
@end

@interface IndagoPrefsCustomCell : PSTableCell <PreferencesTableCustomView> {
	IndagoShimmeringView *firstLabel;
	UILabel *secondLabel;
	UILabel *thirdLabel;
}
@end

@implementation IndagoPrefsCustomCell
- (id)initWithSpecifier:(id)specifier {
	if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"]) {
		firstLabel = [[IndagoShimmeringView alloc] initWithFrame:CGRectMake(0.0, -15.0, [[UIScreen mainScreen] bounds].size.width, 60.0)];
		[firstLabel setNumberOfLines:1.0];
		firstLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:36];
		[firstLabel setText:@"Indago"];
		[firstLabel setBackgroundColor:[UIColor clearColor]];
		firstLabel.textColor = [UIColor colorWithRed:0.0 green:122.0 / 255.0 blue:1.0 alpha:1.0];
		firstLabel.textAlignment = NSTextAlignmentCenter;
		[firstLabel startShimmering];
		[self addSubview:firstLabel];

		secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 20.0, [[UIScreen mainScreen] bounds].size.width, 60.0)];
		[secondLabel setNumberOfLines:1];
		secondLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
		[secondLabel setText:@"The Internet, at your fingertips."];
		[secondLabel setBackgroundColor:[UIColor clearColor]];
		secondLabel.textColor = [UIColor grayColor];
		secondLabel.textAlignment = NSTextAlignmentCenter;
		[self addSubview:secondLabel];

		thirdLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 40.0, [[UIScreen mainScreen] bounds].size.width, 60.0)];
		[thirdLabel setNumberOfLines:1];
		thirdLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
		[thirdLabel setText:@"Created by Logan O’Connell"];
		[thirdLabel setBackgroundColor:[UIColor clearColor]];
		thirdLabel.textColor = [UIColor grayColor];
		thirdLabel.textAlignment = NSTextAlignmentCenter;
		[self addSubview:thirdLabel];
	}
	
	return self;
}
 
- (CGFloat)preferredHeightForWidth:(CGFloat)arg1 {
	return 90.0;
}
@end

@interface IndagoSettingsCustomCell : PSTableCell <PreferencesTableCustomView> {
	IndagoShimmeringView *firstLabel;
}
@end

@implementation IndagoSettingsCustomCell
- (id)initWithSpecifier:(id)specifier {
	if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"]) {
		firstLabel = [[IndagoShimmeringView alloc] initWithFrame:CGRectMake(0.0, -15.0, [[UIScreen mainScreen] bounds].size.width, 60.0)];
		[firstLabel setNumberOfLines:1.0];
		firstLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:36];
		[firstLabel setText:@"Settings"];
		[firstLabel setBackgroundColor:[UIColor clearColor]];
		firstLabel.textColor = [UIColor colorWithRed:0.0 green:122.0 / 255.0 blue:1.0 alpha:1.0];
		firstLabel.textAlignment = NSTextAlignmentCenter;
		[firstLabel startShimmering];
		[self addSubview:firstLabel];
	}
	
	return self;
}
 
- (CGFloat)preferredHeightForWidth:(CGFloat)arg1 {
	return 60.0;
}
@end

@interface IndagoInstructionsCustomCell : PSTableCell <PreferencesTableCustomView> {
	IndagoShimmeringView *firstLabel;
}
@end

@implementation IndagoInstructionsCustomCell
- (id)initWithSpecifier:(id)specifier {
	if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"]) {
		firstLabel = [[IndagoShimmeringView alloc] initWithFrame:CGRectMake(0.0, -15.0, [[UIScreen mainScreen] bounds].size.width, 60.0)];
		[firstLabel setNumberOfLines:1.0];
		firstLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:36];
		[firstLabel setText:@"Instructions"];
		[firstLabel setBackgroundColor:[UIColor clearColor]];
		firstLabel.textColor = [UIColor colorWithRed:0.0 green:122.0 / 255.0 blue:1.0 alpha:1.0];
		firstLabel.textAlignment = NSTextAlignmentCenter;
		[firstLabel startShimmering];
		[self addSubview:firstLabel];
	}
	
	return self;
}
 
- (CGFloat)preferredHeightForWidth:(CGFloat)arg1 {
	return 60.0;
}
@end

@interface IndagoCustomSwitchCell : PSSwitchTableCell
@end

@implementation IndagoCustomSwitchCell
- (id)initWithStyle:(int)style reuseIdentifier:(id)identifier specifier:(id)specifier {
   	if (self = [super initWithStyle:style reuseIdentifier:identifier specifier:specifier]) {
        [[self control] setOnTintColor:[UIColor colorWithRed:0.0 green:122.0 / 255.0 blue:1.0 alpha:1.0]];
    }
    
    return self;
}
@end


@interface IndagoCustomSliderCell : PSSliderTableCell {
	UIButton *button;
	UIAlertView *alert;
    UIAlertView *errorAlert;
}
@end

@implementation IndagoCustomSliderCell
- (id)initWithStyle:(int)style reuseIdentifier:(id)identifier specifier:(id)specifier {
    if (self = [super initWithStyle:style reuseIdentifier:identifier specifier:specifier]) {
        button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(self.frame.size.width - 50.0, 0.0, 50.0, self.frame.size.height);
        button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [button setTitle:@"" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(presentAlert:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }

    return self;
}

- (void)presentAlert:(id)sender {
    alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Please enter a value between %.1f and %.1f.", [[[self specifier] propertyForKey:@"min"] floatValue], [[[self specifier] propertyForKey:@"max"] floatValue]] message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 20.0;

    [[alert textFieldAtIndex:0.0] setPlaceholder:[NSString stringWithFormat:@"%.1f", [[PSRootController readPreferenceValue:[self specifier]] floatValue]]];
    [[alert textFieldAtIndex:0.0] setKeyboardType:UIKeyboardTypeNumberPad];

    [alert show];

    [[alert textFieldAtIndex:0.0] becomeFirstResponder];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 20.0 && buttonIndex == 1.0) {
        CGFloat value = [[alertView textFieldAtIndex:0.0].text floatValue];

        [[alertView textFieldAtIndex:0.0] resignFirstResponder];

        if (value <= [[[self specifier] propertyForKey:@"max"] floatValue] && value >= [[[self specifier] propertyForKey:@"min"] floatValue]) {
            [PSRootController setPreferenceValue:[NSNumber numberWithInt:value] specifier:[self specifier]];

            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self setValue:[NSNumber numberWithInt:value]];
        }

        else {
            errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a valid value." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            errorAlert.tag = 50.0;

            [errorAlert show];
        }
    }

    else if (alertView.tag == 50.0) {
        [self presentAlert:nil];
    }
}
@end