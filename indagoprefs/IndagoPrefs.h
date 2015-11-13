#import "IndagoShimmeringView.h"

@interface PSViewController : UIViewController
@end

@interface PSListController : PSViewController {
	id _specifiers;
}
- (id)specifiers;
- (id)loadSpecifiersFromPlistName:(id)name target:(id)target;
@end

@interface TWTweetComposeViewController : UIViewController
+ (BOOL)canSendTweet;
- (void)setInitialText:(NSString *)text;
@end

@interface PSTableCell : UITableView
- (id)initWithStyle:(int)style reuseIdentifier:(id)arg2;
@end

@protocol PreferencesTableCustomView
- (id)initWithSpecifier:(id)specifier;
@optional
- (CGFloat)preferredHeightForWidth:(CGFloat)width;
@end

@interface PSSwitchTableCell : UITableViewCell
- (id)initWithStyle:(int)style reuseIdentifier:(id)identifier specifier:(id)specifier;
- (UISwitch *)control;
@end

@interface PSSpecifier : NSObject
- (id)propertyForKey:(NSString *)key;
- (NSString *)name;
@end

@interface PSRootController : UINavigationController
+ (id)readPreferenceValue:(id)specifier;
+ (void)setPreferenceValue:(id)value specifier:(id)specifier;
@end

@interface PSSliderTableCell : UITableViewCell
- (id)initWithStyle:(int)style reuseIdentifier:(id)identifier specifier:(id)specifier;
- (void)setValue:(id)value;
- (PSSpecifier *)specifier;
@end

@protocol MFMailComposeViewControllerDelegate
@optional
- (void)mailComposeController:(id)viewController didFinishWithResult:(id)result error:(NSError *)error;
@end

@interface MFMailComposeViewController : UIViewController
@property (nonatomic, assign) id <MFMailComposeViewControllerDelegate> mailComposeDelegate;
+ (BOOL)canSendMail;
- (void)setToRecipients:(NSArray *)toRecipients;
- (void)setSubject:(NSString *)subject;
- (void)setMessageBody:(NSString *)body isHTML:(BOOL)isHTML;
@end

CFPropertyListRef MGCopyAnswer(CFStringRef property);