#import "Indago.h"

@implementation IndagoBrowserViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.shouldLoadInMinimizedMode) {
        self.view = [[UIView alloc] initWithFrame:self.view.frame = CGRectMake(20.0, ([UIScreen mainScreen].bounds.size.height - [UIScreen mainScreen].bounds.size.width + 40.0) / 2.0, [UIScreen mainScreen].bounds.size.width - 40.0, [UIScreen mainScreen].bounds.size.width - 40.0)];
    }

    else {
        self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    
    if (self.shouldAddShadow) {
        self.view.layer.shadowColor = [UIColor blackColor].CGColor;
        self.view.layer.shadowOffset = CGSizeZero;
        self.view.layer.shadowOpacity = 0.3;
        self.view.layer.shadowRadius = 10.0;
    }

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];

    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    pinch.delegate = self;
    [self.view addGestureRecognizer:pinch];
    
    self.topToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 20.0, self.view.frame.size.width, 44.0)];

    self.expand = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(expand:)];

    UIBarButtonItem *spacer1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer1.width = self.view.frame.size.width - 81.0;

    self.share = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];

    [self.topToolbar setItems:[NSArray arrayWithObjects:self.expand, spacer1, self.share, nil]];
    self.topToolbar.translucent = NO;
    self.topToolbar.barTintColor = [UIColor whiteColor];
    [self.view addSubview:self.topToolbar];

    UIView *expandButtonView = [self.expand valueForKey:@"_view"];

    UILongPressGestureRecognizer *longPress1 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleExpandButtonLongPress:)];
    [expandButtonView addGestureRecognizer:longPress1];

    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(40.0, 20.0, self.view.frame.size.width - 81.0, 44.0)];
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchBar.backgroundColor = [UIColor whiteColor];
    self.searchBar.keyboardType = UIKeyboardTypeWebSearch;
    self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.searchBar.placeholder = @"Search";
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];

    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.frame = CGRectMake(0.0, 62.0, self.view.frame.size.width, 2.0);
    self.progressView.progress = 0.0;
    self.progressView.trackTintColor = [UIColor clearColor];
    [self.view addSubview:self.progressView];

    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0.0, 64.0, self.view.frame.size.width, self.view.frame.size.height - 108.0) configuration:[[WKWebViewConfiguration alloc] init]];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.opaque = NO;
    self.webView.allowsBackForwardNavigationGestures = YES;
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;

    if (self.shouldPreloadGoogle) {
        [self loadRequestFromString:@"https://google.com"];
    }

    [self.view addSubview:self.webView];

    self.bottomToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height - 44.0, self.view.frame.size.width, 44.0)];

    self.back = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(goBack:)];

    UIBarButtonItem *spacer2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];

    self.forward = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(goForward:)];

    self.search = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(search:)];

    self.refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];

    self.close = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(close:)];

    [self.bottomToolbar setItems:[NSArray arrayWithObjects:self.back, spacer2, self.forward, spacer2, self.search, spacer2, self.refresh, spacer2, self.close, nil]];
    self.bottomToolbar.translucent = NO;
    self.bottomToolbar.barTintColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomToolbar];

    UIView *closeButtonView = [self.close valueForKey:@"_view"];

    UILongPressGestureRecognizer *longPress2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleCloseButtonLongPress:)];
    [closeButtonView addGestureRecognizer:longPress2];

    if (!self.shouldShowStatusBar) {
        self.topToolbar.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, 44.0);

        self.searchBar.frame = CGRectMake(40.0, 0.0, self.view.frame.size.width - 81.0, 44.0);

        [self.searchBar.delegate searchBarCancelButtonClicked:self.searchBar];

        self.progressView.frame = CGRectMake(0.0, 42.0, self.view.frame.size.width, 2.0);

        self.webView.frame = CGRectMake(0.0, 44.0, self.view.frame.size.width, self.view.frame.size.height - 88.0);
    }

    if (!self.shouldUseLightMode) {
        self.topToolbar.tintColor = [UIColor whiteColor];
        self.topToolbar.barTintColor = [UIColor blackColor];

        self.searchBar.searchBarStyle = UISearchBarStyleDefault;
        self.searchBar.barTintColor = [UIColor blackColor];
        self.searchBar.tintColor = [UIColor whiteColor];
        [self.searchBar setInsertionPointColor:[UIColor colorWithRed:0.557 green:0.557 blue:0.576 alpha:1.0]];

        self.webView.backgroundColor = [UIColor blackColor];

        self.bottomToolbar.tintColor = [UIColor whiteColor];
        self.bottomToolbar.barTintColor = [UIColor blackColor];
    }

    [self updateSubviewCornerRadii];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlaybackStarted:) name:@"UIWindowDidBecomeVisibleNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlaybackFinished:) name:@"UIWindowDidBecomeHiddenNotification" object:nil];
}

- (void)videoPlaybackStarted:(NSNotification *)notification {
    if (((UIWindow *)notification.object).windowLevel == 0.0) {
        ((UIWindow *)notification.object).windowLevel = UIWindowLevelStatusBar + 101.0;
    }
}

- (void)videoPlaybackFinished:(NSNotification *)notification {
    if (((UIWindow *)notification.object).windowLevel == UIWindowLevelStatusBar + 101.0) {
        ((UIWindow *)notification.object).windowLevel = 0.0;
    }
}

- (void)loadRequestFromString:(NSString *)string {
    if (![NSURL URLWithString:string].scheme) {
        string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

        if ([string containsString:@"."] && string.length - [string rangeOfString:@"."].location - 1.0 > 1.0 && ![string containsString:@" "]) {
            string = [@"http://" stringByAppendingString:string];
        }
        
        else {
            string = [NSString stringWithFormat:@"https://google.com/search?q=%@", [string stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
        }
    }
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:string]]];
}

- (void)updateWebView {
    self.back.enabled = self.webView.canGoBack;

    self.forward.enabled = self.webView.canGoForward;
    
    NSMutableArray *items = [self.bottomToolbar.items mutableCopy];
    
    if (self.webView.loading) {
        UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activityIndicatorView startAnimating];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stop:)];
        [activityIndicatorView addGestureRecognizer:tap];

        [items replaceObjectAtIndex:6.0 withObject:[[UIBarButtonItem alloc] initWithCustomView:activityIndicatorView]];

        if (![self.webView.title isEqual:@""]) {
            if (self.webView.title.length >= 25.0) {
                self.searchBar.placeholder = [self.webView.title substringToIndex:25];
            }

            else {
                self.searchBar.placeholder = self.webView.title;
            }
        }

        else {
            self.searchBar.placeholder = @"Loading...";
        }
    }
    
    else {
        [items replaceObjectAtIndex:6.0 withObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)]];

        if (![self.webView.title isEqual:@""]) {
            if (self.webView.title.length >= 25.0) {
                self.searchBar.placeholder = [self.webView.title substringToIndex:25];
            }

            else {
                self.searchBar.placeholder = self.webView.title;
            }
        }

        else if (self.webView.URL) {
            if (self.webView.URL.absoluteString.length >= 25.0) {
                self.searchBar.placeholder = [self.webView.URL.absoluteString substringToIndex:25];
            }

            else {
                self.searchBar.placeholder = self.webView.URL.absoluteString;
            }
        }

        else {
            self.searchBar.placeholder = @"Search";
        }
    }
    
    [self.bottomToolbar setItems:items animated:NO];

    if (self.webView.hasOnlySecureContent) {
        [self.searchBar setImage:[[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/IndagoPrefs.bundle/IndagoLock.png"] _flatImageWithColor:[UIColor colorWithRed:0.557 green:0.557 blue:0.576 alpha:1.0]] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    }

    else {
        [self.searchBar setImage:[[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/IndagoPrefs.bundle/IndagoUnlock.png"] _flatImageWithColor:[UIColor colorWithRed:0.557 green:0.557 blue:0.576 alpha:1.0]] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    }
}

- (void)updateSubviewCornerRadii {
    CAShapeLayer *maskLayer1 = [CAShapeLayer layer];
    maskLayer1.frame = self.topToolbar.bounds;

    UIBezierPath *roundedPath1 = [UIBezierPath bezierPathWithRoundedRect:maskLayer1.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(self.cornerRadiusForBrowser, self.cornerRadiusForBrowser)];    
    
    maskLayer1.fillColor = [UIColor whiteColor].CGColor;
    maskLayer1.backgroundColor = [UIColor clearColor].CGColor;
    maskLayer1.path = [roundedPath1 CGPath];

    self.topToolbar.layer.mask = maskLayer1;

    CAShapeLayer *maskLayer2 = [CAShapeLayer layer];
    maskLayer2.frame = self.searchBar.bounds;

    UIBezierPath *roundedPath2 = [UIBezierPath bezierPathWithRoundedRect:maskLayer2.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(self.cornerRadiusForBrowser, self.cornerRadiusForBrowser)];    
    
    maskLayer2.fillColor = [UIColor whiteColor].CGColor;
    maskLayer2.backgroundColor = [UIColor clearColor].CGColor;
    maskLayer2.path = [roundedPath2 CGPath];

    self.searchBar.layer.mask = maskLayer2;
    [self.view addSubview:self.searchBar];

    CAShapeLayer *maskLayer3 = [CAShapeLayer layer];
    maskLayer3.frame = self.bottomToolbar.bounds;

    UIBezierPath *roundedPath3 = [UIBezierPath bezierPathWithRoundedRect:maskLayer3.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(self.cornerRadiusForBrowser, self.cornerRadiusForBrowser)];    
    
    maskLayer3.fillColor = [UIColor whiteColor].CGColor;
    maskLayer3.backgroundColor = [UIColor clearColor].CGColor;
    maskLayer3.path = [roundedPath3 CGPath];

    self.bottomToolbar.layer.mask = maskLayer3;

    [self.view bringSubviewToFront:self.progressView];
}

- (void)updateSubviewFramesAnimated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            if (self.shouldShowStatusBar) {
                self.topToolbar.frame = CGRectMake(0.0, 20.0, self.view.frame.size.width, 44.0);

                self.searchBar.frame = CGRectMake(40.0, 20.0, self.view.frame.size.width - 81.0, 44.0);

                [self.searchBar.delegate searchBarCancelButtonClicked:self.searchBar];

                self.progressView.frame = CGRectMake(0.0, 62.0, self.view.frame.size.width, 2.0);

                self.webView.frame = CGRectMake(0.0, 64.0, self.view.frame.size.width, self.view.frame.size.height - 108.0);
            }

            else {
                self.topToolbar.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, 44.0);

                self.searchBar.frame = CGRectMake(40.0, 0.0, self.view.frame.size.width - 81.0, 44.0);

                [self.searchBar.delegate searchBarCancelButtonClicked:self.searchBar];

                self.progressView.frame = CGRectMake(0.0, 42.0, self.view.frame.size.width, 2.0);

                self.webView.frame = CGRectMake(0.0, 44.0, self.view.frame.size.width, self.view.frame.size.height - 88.0);
            }

            NSMutableArray *items = [self.topToolbar.items mutableCopy];

            UIBarButtonItem *spacer1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            spacer1.width = self.view.frame.size.width - 81.0;
        
            [items replaceObjectAtIndex:1.0 withObject:spacer1];

            [self.topToolbar setItems:items animated:NO];

            self.bottomToolbar.frame = CGRectMake(0.0, self.view.frame.size.height - 44.0, self.view.frame.size.width, 44.0);

            [self updateSubviewCornerRadii];
        }
        completion:^(BOOL finished) {
            
        }];
    }

    else {
        if (self.shouldShowStatusBar) {
            self.topToolbar.frame = CGRectMake(0.0, 20.0, self.view.frame.size.width, 44.0);

            self.searchBar.frame = CGRectMake(40.0, 20.0, self.view.frame.size.width - 81.0, 44.0);

            [self.searchBar.delegate searchBarCancelButtonClicked:self.searchBar];

            self.progressView.frame = CGRectMake(0.0, 62.0, self.view.frame.size.width, 2.0);

            self.webView.frame = CGRectMake(0.0, 64.0, self.view.frame.size.width, self.view.frame.size.height - 108.0);
        }

        else {
            self.topToolbar.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, 44.0);

            self.searchBar.frame = CGRectMake(40.0, 0.0, self.view.frame.size.width - 81.0, 44.0);

            [self.searchBar.delegate searchBarCancelButtonClicked:self.searchBar];

            self.progressView.frame = CGRectMake(0.0, 42.0, self.view.frame.size.width, 2.0);

            self.webView.frame = CGRectMake(0.0, 44.0, self.view.frame.size.width, self.view.frame.size.height - 88.0);
        }

        NSMutableArray *items = [self.topToolbar.items mutableCopy];

        UIBarButtonItem *spacer1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spacer1.width = self.view.frame.size.width - 81.0;
    
        [items replaceObjectAtIndex:1.0 withObject:spacer1];

        [self.topToolbar setItems:items animated:NO];

        self.bottomToolbar.frame = CGRectMake(0.0, self.view.frame.size.height - 44.0, self.view.frame.size.width, 44.0);

        [self updateSubviewCornerRadii];

        [self updateWebView];
    }
}

- (void)updateProgressView:(id)sender {
    if (self.progressView.progress == 1.0) {
        self.progressView.hidden = YES;
        [self.progressViewTimer invalidate];
    }
     
    else {
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
    }
}

- (void)expand:(id)sender {
    if (self.view.frame.size.width == [UIScreen mainScreen].bounds.size.width) {
        self.view.transform = CGAffineTransformIdentity;

        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(20.0, ([UIScreen mainScreen].bounds.size.height - [UIScreen mainScreen].bounds.size.width + 40.0) / 2.0, [UIScreen mainScreen].bounds.size.width - 40.0, [UIScreen mainScreen].bounds.size.width - 40.0);
        }
        completion:^(BOOL finished) {

        }];
    }

    else {
        self.view.transform = CGAffineTransformIdentity;

        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = [UIScreen mainScreen].bounds;
        }
        completion:^(BOOL finished) {

        }];
    }

    [self updateSubviewFramesAnimated:YES];
}

- (void)share:(id)sender {
    self.view.transform = CGAffineTransformIdentity;

    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = [UIScreen mainScreen].bounds;
    }
    completion:^(BOOL finished) {

    }];

    [self updateSubviewFramesAnimated:YES];

    [self presentViewController:[[UIActivityViewController alloc] initWithActivityItems:[NSArray arrayWithObjects:self.webView.URL, nil] applicationActivities:nil] animated:YES completion:^{

    }];
}

- (void)goBack:(id)sender {
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }
}

- (void)goForward:(id)sender {
    if (self.webView.canGoForward) {
        [self.webView goForward];
    }
}

- (void)search:(id)sender {
    [self.searchBar.delegate searchBarTextDidBeginEditing:self.searchBar];

    self.searchBar.text = @"";
}

- (void)refresh:(id)sender {
    [self.webView reload];
}

- (void)stop:(id)sender {
    [self.webView stopLoading];
}

- (void)close:(id)sender {
    [self.searchBar.delegate searchBarCancelButtonClicked:self.searchBar];

    IndagoWindow *indagoBrowserWindow = (IndagoWindow *)self.view.superview;

    [UIView animateWithDuration:0.3 animations:^{
        indagoBrowserWindow.alpha = 0.0;
    }
    completion:^(BOOL finished) {
        indagoBrowserWindow.hidden = YES;

        if (!self.shouldLoadAfterClose) {
            [self.webView stopLoading];
        }
    }];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer {
    recognizer.view.center = CGPointMake(recognizer.view.center.x + [recognizer translationInView:self.view].x, recognizer.view.center.y + [recognizer translationInView:self.view].y);
    [recognizer setTranslation:CGPointMake(0.0, 0.0) inView:self.view];

    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (self.view.frame.origin.x <= -30.0) {
            if (self.view.frame.origin.y <= -30.0) {
                self.view.transform = CGAffineTransformIdentity;

                [UIView animateWithDuration:0.3 animations:^{
                    self.view.frame = CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width / 2.0, [UIScreen mainScreen].bounds.size.width / 2.0);
                }
                completion:^(BOOL finished) {

                }];
            }
            
            if (self.view.frame.origin.y + self.view.frame.size.height >= [UIScreen mainScreen].bounds.size.height + 30.0) {
                self.view.transform = CGAffineTransformIdentity;

                [UIView animateWithDuration:0.3 animations:^{
                    self.view.frame = CGRectMake(0.0, [UIScreen mainScreen].bounds.size.height - [UIScreen mainScreen].bounds.size.width / 2.0, [UIScreen mainScreen].bounds.size.width / 2.0, [UIScreen mainScreen].bounds.size.width / 2.0);
                }
                completion:^(BOOL finished) {

                }];
            }
        }
        
        if (self.view.frame.origin.x + self.view.frame.size.width >= [UIScreen mainScreen].bounds.size.width + 30.0) {
            if (self.view.frame.origin.y <= -30.0) {
                self.view.transform = CGAffineTransformIdentity;

                [UIView animateWithDuration:0.3 animations:^{
                    self.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2.0, 0.0, [UIScreen mainScreen].bounds.size.width / 2.0, [UIScreen mainScreen].bounds.size.width / 2.0);
                }
                completion:^(BOOL finished) {

                }];
            }
            
            if (self.view.frame.origin.y + self.view.frame.size.height >= [UIScreen mainScreen].bounds.size.height + 30.0) {
                self.view.transform = CGAffineTransformIdentity;

                [UIView animateWithDuration:0.3 animations:^{
                    self.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2.0, [UIScreen mainScreen].bounds.size.height - [UIScreen mainScreen].bounds.size.width / 2.0, [UIScreen mainScreen].bounds.size.width / 2.0, [UIScreen mainScreen].bounds.size.width / 2.0);
                }
                completion:^(BOOL finished) {

                }];
            }
        }

        if (self.view.frame.size.width == [UIScreen mainScreen].bounds.size.width / 2.0) {
            if (self.view.center.x <= [UIScreen mainScreen].bounds.size.width / 2.0) {
                if (self.view.center.y <= [UIScreen mainScreen].bounds.size.height / 2.0) {
                    self.view.transform = CGAffineTransformIdentity;

                    [UIView animateWithDuration:0.3 animations:^{
                        self.view.frame = CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width / 2.0, [UIScreen mainScreen].bounds.size.width / 2.0);
                    }
                    completion:^(BOOL finished) {

                    }];
                }

                if (self.view.center.y >= [UIScreen mainScreen].bounds.size.height / 2.0) {
                    self.view.transform = CGAffineTransformIdentity;

                    [UIView animateWithDuration:0.3 animations:^{
                        self.view.frame = CGRectMake(0.0, [UIScreen mainScreen].bounds.size.height - [UIScreen mainScreen].bounds.size.width / 2.0, [UIScreen mainScreen].bounds.size.width / 2.0, [UIScreen mainScreen].bounds.size.width / 2.0);
                    }
                    completion:^(BOOL finished) {

                    }];
                }
            }

            if (self.view.center.x >= [UIScreen mainScreen].bounds.size.width / 2.0) {
                if (self.view.center.y <= [UIScreen mainScreen].bounds.size.height / 2.0) {
                    self.view.transform = CGAffineTransformIdentity;

                    [UIView animateWithDuration:0.3 animations:^{
                        self.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2.0, 0.0, [UIScreen mainScreen].bounds.size.width / 2.0, [UIScreen mainScreen].bounds.size.width / 2.0);
                    }
                    completion:^(BOOL finished) {

                    }];
                }

                if (self.view.center.y >= [UIScreen mainScreen].bounds.size.height / 2.0) {
                    self.view.transform = CGAffineTransformIdentity;

                    [UIView animateWithDuration:0.3 animations:^{
                        self.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2.0, [UIScreen mainScreen].bounds.size.height - [UIScreen mainScreen].bounds.size.width / 2.0, [UIScreen mainScreen].bounds.size.width / 2.0, [UIScreen mainScreen].bounds.size.width / 2.0);
                    }
                    completion:^(BOOL finished) {

                    }];
                }
            }
        }

        if (self.view.frame.size.width == [UIScreen mainScreen].bounds.size.width) {
            if (self.view.frame.origin.x <= 50.0 && self.view.frame.origin.y <= 50.0) {
                self.view.transform = CGAffineTransformIdentity;

                [UIView animateWithDuration:0.3 animations:^{
                    self.view.frame = [UIScreen mainScreen].bounds;
                }
                completion:^(BOOL finished) {

                }];
            }
        }

        [self updateSubviewFramesAnimated:YES];
    }
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer {
    CGRect frameWithTransform = CGRectApplyAffineTransform(self.view.frame, CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale));

    if (self.view.frame.size.width != [UIScreen mainScreen].bounds.size.width / 2.0) {
        if (ABS(frameWithTransform.origin.x) + frameWithTransform.size.width <= [UIScreen mainScreen].bounds.size.width && ABS(frameWithTransform.origin.y) + frameWithTransform.size.height <= [UIScreen mainScreen].bounds.size.height && frameWithTransform.size.width >= [UIScreen mainScreen].bounds.size.width / 2.0) {
            if (frameWithTransform.size.width >= [UIScreen mainScreen].bounds.size.width - 50.0 && frameWithTransform.size.height >= [UIScreen mainScreen].bounds.size.height - 50.0) {
                self.view.transform = CGAffineTransformIdentity;

                [UIView animateWithDuration:0.3 animations:^{
                    self.view.frame = [UIScreen mainScreen].bounds;
                }
                completion:^(BOOL finished) {

                }];

                [self updateSubviewFramesAnimated:YES];
            }

            else {
                recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale); 
                recognizer.scale = 1.0;

                [self updateSubviewFramesAnimated:NO];
            }
        }
    }
}

- (void)handleExpandButtonLongPress:(UILongPressGestureRecognizer *)recognizer {
    if (self.view.center.x <= [UIScreen mainScreen].bounds.size.width / 2.0) {
        if (self.view.center.y <= [UIScreen mainScreen].bounds.size.height / 2.0) {
            self.view.transform = CGAffineTransformIdentity;

            [UIView animateWithDuration:0.3 animations:^{
                self.view.frame = CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width / 2.0, [UIScreen mainScreen].bounds.size.width / 2.0);
            }
            completion:^(BOOL finished) {

            }];
        }

        if (self.view.center.y >= [UIScreen mainScreen].bounds.size.height / 2.0) {
            self.view.transform = CGAffineTransformIdentity;

            [UIView animateWithDuration:0.3 animations:^{
                self.view.frame = CGRectMake(0.0, [UIScreen mainScreen].bounds.size.height - [UIScreen mainScreen].bounds.size.width / 2.0, [UIScreen mainScreen].bounds.size.width / 2.0, [UIScreen mainScreen].bounds.size.width / 2.0);
            }
            completion:^(BOOL finished) {

            }];
        }
    }

    if (self.view.center.x >= [UIScreen mainScreen].bounds.size.width / 2.0) {
        if (self.view.center.y <= [UIScreen mainScreen].bounds.size.height / 2.0) {
            self.view.transform = CGAffineTransformIdentity;

            [UIView animateWithDuration:0.3 animations:^{
                self.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2.0, 0.0, [UIScreen mainScreen].bounds.size.width / 2.0, [UIScreen mainScreen].bounds.size.width / 2.0);
            }
            completion:^(BOOL finished) {

            }];
        }

        if (self.view.center.y >= [UIScreen mainScreen].bounds.size.height / 2.0) {
            self.view.transform = CGAffineTransformIdentity;

            [UIView animateWithDuration:0.3 animations:^{
                self.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2.0, [UIScreen mainScreen].bounds.size.height - [UIScreen mainScreen].bounds.size.width / 2.0, [UIScreen mainScreen].bounds.size.width / 2.0, [UIScreen mainScreen].bounds.size.width / 2.0);
            }
            completion:^(BOOL finished) {

            }];
        }
    }

    [self updateSubviewFramesAnimated:YES];
}

- (void)handleCloseButtonLongPress:(UILongPressGestureRecognizer *)recognizer {
    if (self.shouldUseURLSharing) {
        [[UIApplication sharedApplication] openURL:self.webView.URL];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (CGRectContainsPoint(self.webView.frame, [touch locationInView:self.view]) && gestureRecognizer.view == self.view) {
        return NO;
    }

    else {
        return YES;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ((gestureRecognizer.view == self.view && otherGestureRecognizer.view == self.view) || [self.searchBar isFirstResponder]) {
        return NO;
    }

    else {
        return YES;
    }
}

- (void)webView:(id)webView didCommitNavigation:(id)navigation {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    [self updateWebView];

    [self.searchBar.delegate searchBarCancelButtonClicked:self.searchBar];

    self.progressView.progress = 0.0;
    self.progressView.hidden = NO;
    self.progressViewTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateProgressView:) userInfo:nil repeats:YES];
}

- (void)webView:(id)webView didStartProvisionalNavigation:(id)navigation {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    [self updateWebView];

    [self.searchBar.delegate searchBarCancelButtonClicked:self.searchBar];

    self.progressView.progress = 0.0;
    self.progressView.hidden = NO;
    self.progressViewTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateProgressView:) userInfo:nil repeats:YES];
}

- (void)webView:(id)webView didFinishNavigation:(id)navigation {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    [self updateWebView];
}

- (void)webView:(id)webView didFailNavigation:(id)navigation withError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    [self updateWebView];
    
    if ([error code] != NSURLErrorCancelled) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
    }
}
- (void)webView:(id)webView didFailProvisionalNavigation:(id)navigation withError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    [self updateWebView];
    
    if ([error code] != NSURLErrorCancelled) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
    }
}

- (void)webView:(id)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame completionHandler:(void (^)())completionHandler {
    self.view.transform = CGAffineTransformIdentity;

    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = [UIScreen mainScreen].bounds;
    }
    completion:^(BOOL finished) {

    }];

    [self updateSubviewFramesAnimated:YES];

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:self.webView.title message:message preferredStyle:UIAlertControllerStyleAlert];

    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler();
    }]];

    [self presentViewController:alertController animated:YES completion:^{

    }];
}

- (void)webView:(id)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(id)frame completionHandler:(void (^)(NSString *))completionHandler {
    self.view.transform = CGAffineTransformIdentity;

    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = [UIScreen mainScreen].bounds;
    }
    completion:^(BOOL finished) {

    }];

    [self updateSubviewFramesAnimated:YES];

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:self.webView.title message:prompt preferredStyle:UIAlertControllerStyleAlert];

    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = defaultText;
    }];

    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler(nil);
    }]];

    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        completionHandler(((UITextField *)alertController.textFields.firstObject).text);
    }]];

    [self presentViewController:alertController animated:YES completion:^{

    }];
}

- (void)webView:(id)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame completionHandler:(void (^)(BOOL))completionHandler {
    self.view.transform = CGAffineTransformIdentity;

    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = [UIScreen mainScreen].bounds;
    }
    completion:^(BOOL finished) {

    }];

    [self updateSubviewFramesAnimated:YES];

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:self.webView.title message:message preferredStyle:UIAlertControllerStyleAlert];

    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler(NO);
    }]];

    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        completionHandler(YES);
    }]];

    [self presentViewController:alertController animated:YES completion:^{

    }];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.text = self.webView.URL.absoluteString;
    
    self.searchBar.placeholder = @"Search";

    [self.searchBar setImage:nil forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];

    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    if (self.shouldShowStatusBar) {
        [UIView animateWithDuration:0.3 animations:^{
            self.searchBar.frame = CGRectMake(0.0, 20.0, self.view.frame.size.width, 44.0);

            [self updateSubviewCornerRadii];
        }
        completion:^(BOOL finished) {
        
        }];
    }

    else {
        [UIView animateWithDuration:0.3 animations:^{
            self.searchBar.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, 44.0);

            [self updateSubviewCornerRadii];
        }
        completion:^(BOOL finished) {
        
        }];
    }

    [self.searchBar setShowsCancelButton:YES animated:YES];

    [self.searchBar becomeFirstResponder];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    if (self.shouldShowStatusBar) {
        [UIView animateWithDuration:0.3 animations:^{
            self.searchBar.frame = CGRectMake(40.0, 20.0, self.view.frame.size.width - 81.0, 44.0);

            [self updateSubviewCornerRadii];
        }
        completion:^(BOOL finished) {
        
        }];
    }

    else {
        [UIView animateWithDuration:0.3 animations:^{
            self.searchBar.frame = CGRectMake(40.0, 0.0, self.view.frame.size.width - 81.0, 44.0);

            [self updateSubviewCornerRadii];
        }
        completion:^(BOOL finished) {
        
        }];
    }

    [self.searchBar setShowsCancelButton:NO animated:YES];
    
    self.searchBar.text = @"";

    [self updateWebView];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (![self.searchBar.text isEqual:@""]) {
        [self loadRequestFromString:self.searchBar.text];
    }

    [self.searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}
@end