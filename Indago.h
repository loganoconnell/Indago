#import <libactivator/libactivator.h>
#import "IndagoWindow.h"
#import "IndagoBrowserViewController.h"
#import "IndagoSearchBarViewController.h"
#import "IndagoObfuscatedString.h"

static IndagoWindow *indagoBrowserWindow;
static IndagoBrowserViewController *browserViewController;
static IndagoWindow *indagoSearchWindow;
static IndagoSearchBarViewController *searchBarViewController;
static IndagoSearchBarViewController *homeScreenSearchBarViewController;
static UIView *statusBar;

@interface NSDistributedNotificationCenter : NSNotificationCenter
@end

@interface UIImage (Indago)
- (UIImage *)_flatImageWithColor:(UIColor *)color;
@end

@interface UISearchBar (Indago)
- (void)setInsertionPointColor:(UIColor *)color;
@end

@interface UIApplication (Indago)
- (UIView *)statusBar;
- (void)_relaunchSpringBoardNow;
@end

@interface SBApplication : NSObject
- (id)bundleIdentifier;
@end

@interface SpringBoard
- (void)applicationDidFinishLaunching:(id)launching;
- (void)_applicationOpenURL:(NSURL *)URL withApplication:(SBApplication *)application sender:(NSString *)sender publicURLsOnly:(BOOL)only animating:(BOOL)animating activationSettings:(id)settings withResult:(id)result;
- (void)showIndagoWithURL:(NSNotification *)notification;
@end

@interface SBIconContentView : UIView
@end

@interface SBUIController
- (BOOL)clickedMenuButton;
@end

@interface TabDocument : NSObject
- (NSString *)URLString;
@end

@interface TabController : NSObject
- (TabDocument *)activeTabDocument;
@end

@interface BrowserController : NSObject
+ (id)sharedBrowserController;
- (TabController *)tabController;
@end

@interface BrowserToolbar : UIToolbar
@end

int access(const char *, int);

static BOOL browserEnabled;
static BOOL searchEnabled;
static BOOL openLinksWithBrowser;
static BOOL useURLSharing;
static BOOL preloadGoogleEnabled;
static BOOL loadAfterClose;
static BOOL loadInMinimizedMode;
static BOOL browserShowStatusBar;
static BOOL addShadowToBrowser;
static BOOL browserUseLightMode;
static BOOL browserCloseWithHomeButton;
static float browserCornerRadius;
static BOOL homeScreenSearchBarEnabled;
static BOOL searchUseLightMode;
static BOOL searchCloseWithHomeButton;
static float searchPushDownPercent;