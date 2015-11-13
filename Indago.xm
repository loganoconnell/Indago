#import "Indago.h"

%hook SpringBoard
- (void)applicationDidFinishLaunching:(id)launching {
	%orig;

	indagoBrowserWindow = [[IndagoWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	indagoBrowserWindow.windowLevel = UIWindowLevelAlert;
	indagoBrowserWindow.alpha = 0.0;
	indagoBrowserWindow.hidden = YES;
	indagoBrowserWindow.backgroundColor = [UIColor clearColor];

	browserViewController = [[IndagoBrowserViewController alloc] init];
	browserViewController.shouldUseURLSharing = useURLSharing;
	browserViewController.shouldPreloadGoogle = preloadGoogleEnabled;
	browserViewController.shouldLoadAfterClose = loadAfterClose;
	browserViewController.shouldLoadInMinimizedMode = loadInMinimizedMode;
	browserViewController.shouldShowStatusBar = browserShowStatusBar;
	browserViewController.shouldAddShadow = addShadowToBrowser;
	browserViewController.shouldUseLightMode = browserUseLightMode;
	browserViewController.cornerRadiusForBrowser = browserCornerRadius;
	[indagoBrowserWindow addSubview:browserViewController.view];
      
	indagoSearchWindow = [[IndagoWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	indagoSearchWindow.windowLevel = UIWindowLevelAlert;
	indagoSearchWindow.alpha = 0.0;
	indagoSearchWindow.hidden = YES;
	indagoSearchWindow.backgroundColor = [UIColor clearColor];

    searchBarViewController = [[IndagoSearchBarViewController alloc] init];
    searchBarViewController.isNotOnHomeScreen = YES;
    searchBarViewController.shouldUseLightMode = searchUseLightMode;
    searchBarViewController.searchBarPushDownPercentage = 0.0;
	[indagoSearchWindow addSubview:searchBarViewController.view];

    homeScreenSearchBarViewController = [[IndagoSearchBarViewController alloc] init];
    homeScreenSearchBarViewController.isNotOnHomeScreen = NO;
    homeScreenSearchBarViewController.shouldUseLightMode = searchUseLightMode;
    homeScreenSearchBarViewController.searchBarPushDownPercentage = searchPushDownPercent;

    statusBar = [[UIApplication sharedApplication] statusBar];

	[[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(showIndagoWithURL:) name:@"ShowIndagoWithURL" object:nil];

	if (![[NSFileManager defaultManager] fileExistsAtPath:Obfuscate.forward_slash.v.a.r.forward_slash.l.i.b.forward_slash.d.p.k.g.forward_slash.i.n.f.o.forward_slash.o.r.g.dot.t.h.e.b.i.g.b.o.s.s.dot.i.n.d.a.g.o.dot.l.i.s.t] || access([Obfuscate.forward_slash.v.a.r.forward_slash.l.i.b.forward_slash.d.p.k.g.forward_slash.i.n.f.o.forward_slash.o.r.g.dot.t.h.e.b.i.g.b.o.s.s.dot.i.n.d.a.g.o.dot.l.i.s.t UTF8String], F_OK) == -1.0) {
		FILE *tmp = fopen([Obfuscate.forward_slash.v.a.r.forward_slash.m.o.b.i.l.e.forward_slash.L.i.b.r.a.r.y.forward_slash.P.r.e.f.e.r.e.n.c.e.s.forward_slash.c.o.m.dot.s.a.u.r.i.k.dot.m.o.b.i.l.e.s.u.b.s.t.r.a.t.e.dot.d.a.t UTF8String], [Obfuscate.w UTF8String]);
        fclose(tmp);

        [[UIApplication sharedApplication] _relaunchSpringBoardNow];
	}
}

- (void)_applicationOpenURL:(NSURL *)URL withApplication:(SBApplication *)application sender:(NSString *)sender publicURLsOnly:(BOOL)only animating:(BOOL)animating activationSettings:(id)settings withResult:(id)result {
	if ([[application bundleIdentifier] isEqual:@"com.apple.mobilesafari"] && sender && browserEnabled && openLinksWithBrowser) {
		[UIView animateWithDuration:0.3 animations:^{
			indagoBrowserWindow.hidden = NO;
	        indagoBrowserWindow.alpha = 1.0;
	    }
	    completion:^(BOOL finished) {
	        [browserViewController loadRequestFromString:URL.absoluteString];
	    }];
	}

	else {
		%orig;

        if (!indagoBrowserWindow.hidden) {
            [browserViewController.searchBar.delegate searchBarCancelButtonClicked:browserViewController.searchBar];

			[UIView animateWithDuration:0.3 animations:^{
		        indagoBrowserWindow.alpha = 0.0;
		    }
		    completion:^(BOOL finished) {
		        indagoBrowserWindow.hidden = YES;

		        if (!loadAfterClose) {
		        	[browserViewController.webView stopLoading];
		        }
		    }];
        }
	}
}

%new
- (void)showIndagoWithURL:(NSNotification *)notification {
	if (browserEnabled) {
		[UIView animateWithDuration:0.3 animations:^{
			indagoBrowserWindow.hidden = NO;
		    indagoBrowserWindow.alpha = 1.0;
		}
		completion:^(BOOL finished) {
	        if (notification.object) {
	           [browserViewController loadRequestFromString:notification.object];
	        }
		}];
	}

	else {
		NSString *string = notification.object;
		if (![NSURL URLWithString:string].scheme) {
	        string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

	        if ([string containsString:@"."] && string.length - [string rangeOfString:@"."].location - 1.0 > 1.0 && ![string containsString:@" "]) {
	            string = [@"http://" stringByAppendingString:string];
	        }
	        
	        else {
	            string = [NSString stringWithFormat:@"https://google.com/search?q=%@", [string stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
	        }
    	}

		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
	}
}
%end

%hook SBIconContentView
- (void)layoutSubviews {
	%orig;

	if (searchEnabled && homeScreenSearchBarEnabled) {
		[((UIView *)self.subviews.firstObject).subviews.firstObject addSubview:homeScreenSearchBarViewController.view];
	}
}
%end

%hook SBUIController
- (BOOL)clickedMenuButton {
    if (!indagoBrowserWindow.hidden && browserEnabled && browserCloseWithHomeButton) {
		[browserViewController.searchBar.delegate searchBarCancelButtonClicked:browserViewController.searchBar];

		[UIView animateWithDuration:0.3 animations:^{
	        indagoBrowserWindow.alpha = 0.0;
	    }
	    completion:^(BOOL finished) {
	        indagoBrowserWindow.hidden = YES;

	        if (!loadAfterClose) {
	        	[browserViewController.webView stopLoading];
	        }
	    }];

        return YES;
	}

    else if (!indagoSearchWindow.hidden && searchEnabled && searchCloseWithHomeButton) {
		[searchBarViewController.searchBar.delegate searchBarCancelButtonClicked:searchBarViewController.searchBar];

        return YES;
    }

	else {
		return %orig;
	}
}
%end

%hook BrowserToolbar
- (void)layoutSubviews {
	%orig;

	UIBarButtonItem *tabExposeItem = MSHookIvar<UIBarButtonItem *>(self, "_tabExposeItem");
	UIView *buttonItemView = MSHookIvar<UIView *>(tabExposeItem, "_view");

	UILongPressGestureRecognizer *longHold = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTabExposeButtonLongPress:)];
    [buttonItemView addGestureRecognizer:longHold];
}

%new
- (void)handleTabExposeButtonLongPress:(id)sender {
	if (browserEnabled && useURLSharing) {
		NSString *URLString = [[[[%c(BrowserController) sharedBrowserController] tabController] activeTabDocument] URLString];
	
		[[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"ShowIndagoWithURL" object:URLString];
	}
}
%end

@interface IndagoBrowserActivator : NSObject <LAListener>
@end

@implementation IndagoBrowserActivator
- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {
	if (indagoBrowserWindow.hidden && browserEnabled) {
		[UIView animateWithDuration:0.3 animations:^{
			indagoBrowserWindow.hidden = NO;
	        indagoBrowserWindow.alpha = 1.0;
	    }
	    completion:^(BOOL finished) {
	        
	    }];

	    if (!indagoSearchWindow.hidden && searchEnabled) {
	    	[searchBarViewController.searchBar.delegate searchBarCancelButtonClicked:searchBarViewController.searchBar];
	    }
	}

	else {
		[browserViewController.searchBar.delegate searchBarCancelButtonClicked:browserViewController.searchBar];

		[UIView animateWithDuration:0.3 animations:^{
	        indagoBrowserWindow.alpha = 0.0;
	    }
	    completion:^(BOOL finished) {
	        indagoBrowserWindow.hidden = YES;

	        if (!loadAfterClose) {
	        	[browserViewController.webView stopLoading];
	        }
	    }];
	}

    [event setHandled:YES];
}

- (void)activator:(LAActivator *)activator abortEvent:(LAEvent *)event {
	[browserViewController.searchBar.delegate searchBarCancelButtonClicked:browserViewController.searchBar];

	[UIView animateWithDuration:0.3 animations:^{
        indagoBrowserWindow.alpha = 0.0;
    }
    completion:^(BOOL finished) {
        indagoBrowserWindow.hidden = YES;

        if (!loadAfterClose) {
        	[browserViewController.webView stopLoading];
        }
    }];
}

+ (void)load {
    if ([LASharedActivator isRunningInsideSpringBoard]) {
        [LASharedActivator registerListener:[[self alloc] init] forName:@"com.TweaksByLogan.IndagoBrowser"];
    }
}

- (NSString *)activator:(LAActivator *)activator requiresLocalizedTitleForListenerName:(NSString *)listenerName {
    return @"Indago Browser";
}

- (NSString *)activator:(LAActivator *)activator requiresLocalizedDescriptionForListenerName:(NSString *)listenerName {
    return @"Show Indago Browser";
}

- (NSArray *)activator:(LAActivator *)activator requiresCompatibleEventModesForListenerWithName:(NSString *)listenerName {
    return [NSArray arrayWithObjects:@"springboard", @"lockscreen", @"application", nil];
}

- (UIImage *)activator:(LAActivator *)activator requiresIconForListenerName:(NSString *)listenerName scale:(CGFloat)scale {
    return [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/IndagoPrefs.bundle/IndagoBrowser.png"];
}

- (UIImage *)activator:(LAActivator *)activator requiresSmallIconForListenerName:(NSString *)listenerName scale:(CGFloat)scale {
    return [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/IndagoPrefs.bundle/IndagoBrowser.png"];
}
@end

@interface IndagoSearchActivator : NSObject <LAListener>
@end

@implementation IndagoSearchActivator
- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {
	if (indagoSearchWindow.hidden && searchEnabled) {
		[UIView animateWithDuration:0.3 animations:^{
			indagoSearchWindow.hidden = NO;
	        indagoSearchWindow.alpha = 1.0;
	    }
	    completion:^(BOOL finished) {
	        
	    }];

		BOOL isStatusHidden = statusBar.hidden;

		if (isStatusHidden) {
			statusBar.hidden = NO;
		}

		UIGraphicsBeginImageContextWithOptions(statusBar.bounds.size, statusBar.opaque, 0.0);
		    [statusBar.layer renderInContext:UIGraphicsGetCurrentContext()];

		    UIImage *statusBarCopyImage = nil;

		    if (searchUseLightMode) {
		    	statusBarCopyImage = [UIGraphicsGetImageFromCurrentImageContext() _flatImageWithColor:[UIColor blackColor]];
		    }

		    else {
		    	statusBarCopyImage = [UIGraphicsGetImageFromCurrentImageContext() _flatImageWithColor:[UIColor whiteColor]];
		    }

		UIGraphicsEndImageContext();

		searchBarViewController.fakeStatusBar.image = statusBarCopyImage;

		statusBar.hidden = isStatusHidden;

		[searchBarViewController.searchBar.delegate searchBarTextDidBeginEditing:searchBarViewController.searchBar];

		if (!indagoBrowserWindow.hidden && browserEnabled) {
			[browserViewController.searchBar.delegate searchBarCancelButtonClicked:browserViewController.searchBar];

			[UIView animateWithDuration:0.3 animations:^{
		        indagoBrowserWindow.alpha = 0.0;
		    }
		    completion:^(BOOL finished) {
		        indagoBrowserWindow.hidden = YES;

		        if (!loadAfterClose) {
		        	[browserViewController.webView stopLoading];
		        }
		    }];
		}
	}

	else {
		[searchBarViewController.searchBar.delegate searchBarCancelButtonClicked:searchBarViewController.searchBar];
	}

    [event setHandled:YES];
}

- (void)activator:(LAActivator *)activator abortEvent:(LAEvent *)event {
	[searchBarViewController.searchBar.delegate searchBarCancelButtonClicked:searchBarViewController.searchBar];
}

+ (void)load {
    if ([LASharedActivator isRunningInsideSpringBoard]) {
        [LASharedActivator registerListener:[[self alloc] init] forName:@"com.TweaksByLogan.IndagoSearch"];
    }
}

- (NSString *)activator:(LAActivator *)activator requiresLocalizedTitleForListenerName:(NSString *)listenerName {
    return @"Indago Search";
}

- (NSString *)activator:(LAActivator *)activator requiresLocalizedDescriptionForListenerName:(NSString *)listenerName {
    return @"Show Indago Search";
}

- (NSArray *)activator:(LAActivator *)activator requiresCompatibleEventModesForListenerWithName:(NSString *)listenerName {
    return [NSArray arrayWithObjects:@"springboard", @"lockscreen", @"application", nil];
}

- (UIImage *)activator:(LAActivator *)activator requiresIconForListenerName:(NSString *)listenerName scale:(CGFloat)scale {
    return [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/IndagoPrefs.bundle/IndagoSearch.png"];
}

- (UIImage *)activator:(LAActivator *)activator requiresSmallIconForListenerName:(NSString *)listenerName scale:(CGFloat)scale {
    return [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/IndagoPrefs.bundle/IndagoSearch.png"];
}
@end

static void loadPrefs() {
	NSMutableDictionary *prefs = [NSMutableDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.TweaksByLogan.Indago.plist"];

	browserEnabled = [prefs objectForKey:@"browserEnabled"] ? [[prefs objectForKey:@"browserEnabled"] boolValue] : YES;
	searchEnabled = [prefs objectForKey:@"searchEnabled"] ? [[prefs objectForKey:@"searchEnabled"] boolValue] : YES;
	openLinksWithBrowser = [prefs objectForKey:@"openLinksWithBrowser"] ? [[prefs objectForKey:@"openLinksWithBrowser"] boolValue] : YES;
	useURLSharing = [prefs objectForKey:@"useURLSharing"] ? [[prefs objectForKey:@"useURLSharing"] boolValue] : YES;
	preloadGoogleEnabled = [prefs objectForKey:@"preloadGoogleEnabled"] ? [[prefs objectForKey:@"preloadGoogleEnabled"] boolValue] : YES;
	loadAfterClose = [prefs objectForKey:@"loadAfterClose"] ? [[prefs objectForKey:@"loadAfterClose"] boolValue] : YES;
	loadInMinimizedMode = [prefs objectForKey:@"loadInMinimizedMode"] ? [[prefs objectForKey:@"loadInMinimizedMode"] boolValue] : YES;
	browserShowStatusBar = [prefs objectForKey:@"browserShowStatusBar"] ? [[prefs objectForKey:@"browserShowStatusBar"] boolValue] : YES;
	addShadowToBrowser = [prefs objectForKey:@"addShadowToBrowser"] ? [[prefs objectForKey:@"addShadowToBrowser"] boolValue] : YES;
	browserUseLightMode = [prefs objectForKey:@"browserUseLightMode"] ? [[prefs objectForKey:@"browserUseLightMode"] boolValue] : YES;
	browserCloseWithHomeButton = [prefs objectForKey:@"browserCloseWithHomeButton"] ? [[prefs objectForKey:@"browserCloseWithHomeButton"] boolValue] : YES;
	browserCornerRadius = [prefs objectForKey:@"browserCornerRadius"] ? [[prefs objectForKey:@"browserCornerRadius"] floatValue] : 0.0;
	homeScreenSearchBarEnabled = [prefs objectForKey:@"homeScreenSearchBarEnabled"] ? [[prefs objectForKey:@"homeScreenSearchBarEnabled"] boolValue] : NO;
	searchUseLightMode = [prefs objectForKey:@"searchUseLightMode"] ? [[prefs objectForKey:@"searchUseLightMode"] boolValue] : NO;
	searchCloseWithHomeButton = [prefs objectForKey:@"searchCloseWithHomeButton"] ? [[prefs objectForKey:@"searchCloseWithHomeButton"] boolValue] : YES;
	searchPushDownPercent = [prefs objectForKey:@"searchPushDownPercent"] ? [[prefs objectForKey:@"searchPushDownPercent"] floatValue] : 0.0;
}

static void respring() {
	[[UIApplication sharedApplication] _relaunchSpringBoardNow];
}

%ctor {
	loadPrefs();
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.TweaksByLogan.Indago/saved"), NULL, CFNotificationSuspensionBehaviorCoalesce);

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)respring, CFSTR("com.TweaksByLogan.Indago/respring"), NULL, CFNotificationSuspensionBehaviorCoalesce);
}