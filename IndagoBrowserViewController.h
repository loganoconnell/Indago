#import "Indago.h"

@interface WKWebViewConfiguration : NSObject
@end

@protocol WKNavigationDelegate
@optional
- (void)webView:(id)webView didCommitNavigation:(id)navigation;
- (void)webView:(id)webView didStartProvisionalNavigation:(id)navigation;
- (void)webView:(id)webView didFinishNavigation:(id)navigation;
- (void)webView:(id)webView didFailNavigation:(id)navigation withError:(NSError *)error;
- (void)webView:(id)webView didFailProvisionalNavigation:(id)navigation withError:(NSError *)error;
@end

@protocol WKUIDelegate
@optional
- (void)webView:(id)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame completionHandler:(void (^)())completionHandler;
- (void)webView:(id)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(id)frame completionHandler:(void (^)(NSString *))completionHandler;
- (void)webView:(id)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame completionHandler:(void (^)(BOOL))completionHandler;
@end

@interface WKWebView : UIView
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSURL *URL;
@property (nonatomic, weak) id <WKNavigationDelegate> navigationDelegate;
@property (nonatomic, weak) id <WKUIDelegate> UIDelegate;
@property (nonatomic, readonly) double estimatedProgress;
@property (nonatomic, readonly) BOOL hasOnlySecureContent;
@property (nonatomic, readonly, getter=isLoading) BOOL loading;
@property (nonatomic) BOOL allowsBackForwardNavigationGestures;
@property (nonatomic, readonly) BOOL canGoBack;
@property (nonatomic, readonly) BOOL canGoForward;

- (id)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration;
- (id)reload;
- (void)stopLoading;
- (id)goBack;
- (id)goForward;
- (id)loadRequest:(NSURLRequest *)request;
- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(id)completionHandler;
@end

@interface IndagoBrowserViewController : UIViewController <UIGestureRecognizerDelegate, WKNavigationDelegate, WKUIDelegate, UISearchBarDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIToolbar *topToolbar;
@property (nonatomic, strong) UIToolbar *bottomToolbar;
@property (nonatomic, strong) UIBarButtonItem *expand;
@property (nonatomic, strong) UIBarButtonItem *share;
@property (nonatomic, strong) UIBarButtonItem *back;
@property (nonatomic, strong) UIBarButtonItem *forward;
@property (nonatomic, strong) UIBarButtonItem *search;
@property (nonatomic, strong) UIBarButtonItem *refresh;
@property (nonatomic, strong) UIBarButtonItem *close;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, strong) NSTimer *progressViewTimer;
@property (nonatomic, assign) BOOL shouldUseURLSharing;
@property (nonatomic, assign) BOOL shouldPreloadGoogle;
@property (nonatomic, assign) BOOL shouldLoadAfterClose;
@property (nonatomic, assign) BOOL shouldLoadInMinimizedMode;
@property (nonatomic, assign) BOOL shouldShowStatusBar;
@property (nonatomic, assign) BOOL shouldAddShadow;
@property (nonatomic, assign) BOOL shouldUseLightMode;
@property (nonatomic, assign) float cornerRadiusForBrowser;

- (void)loadRequestFromString:(NSString *)string;
@end