#import "Indago.h"

@implementation IndagoSearchBarViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.isNotOnHomeScreen) {
        self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];

        UIView *dimView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 64.0, self.view.frame.size.width, self.view.frame.size.height - 64.0)];
        dimView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        [self.view addSubview:dimView];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSearchBarWindow:)];
        [dimView addGestureRecognizer:tap];

        self.darkEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        self.darkEffectView.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, 64.0);
        [self.view addSubview:self.darkEffectView];

        self.fakeStatusBar = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 20.0)];
        [self.view addSubview:self.fakeStatusBar];

        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 20.0, self.view.frame.size.width, 44.0)];
    }

    else {
        self.view = [[UIView alloc] initWithFrame:CGRectMake(0.0, ([UIScreen mainScreen].bounds.size.height - 40) / 100 * self.searchBarPushDownPercentage + 20, [UIScreen mainScreen].bounds.size.width, 44.0)];

        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44.0)];
    }

    self.searchBar.searchBarStyle = UISearchBarStyleDefault;
    self.searchBar.barTintColor = [UIColor clearColor];
    self.searchBar.keyboardType = UIKeyboardTypeWebSearch;
    self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.searchBar.text = @"";
    self.searchBar.placeholder = @"Search";
    self.searchBar.delegate = self;
    self.searchBar.tintColor = [UIColor whiteColor];
    self.searchBar.backgroundImage = [[UIImage alloc] init];
    self.searchBar.translucent = YES;
    [self.searchBar setInsertionPointColor:[UIColor colorWithRed:0.557 green:0.557 blue:0.576 alpha:1.0]];
    [self.view addSubview:self.searchBar];

    if (self.shouldUseLightMode) {
        if (self.isNotOnHomeScreen) {
            self.darkEffectView.hidden = YES;

            self.lightEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
            self.lightEffectView.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, 64.0);
            [self.view insertSubview:self.lightEffectView atIndex:0.0];
        }

        self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
        self.searchBar.tintColor = [UIColor blackColor];
        [self.searchBar setInsertionPointColor:[UIColor colorWithRed:0.557 green:0.557 blue:0.576 alpha:1.0]];
    }
}

- (void)dismissSearchBarWindow:(UITapGestureRecognizer *)gestureRecognizer {
    [self.searchBar.delegate searchBarCancelButtonClicked:self.searchBar];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.searchBar setShowsCancelButton:YES animated:YES];

    [self.searchBar becomeFirstResponder];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self.searchBar setShowsCancelButton:NO animated:YES];

    self.searchBar.text = @"";

    if (self.isNotOnHomeScreen) {
        IndagoWindow *indagoSearchWindow = (IndagoWindow *)self.view.superview;

        [UIView animateWithDuration:0.3 animations:^{
            indagoSearchWindow.alpha = 0.0;
        }
        completion:^(BOOL finished) {
            indagoSearchWindow.hidden = YES;
        }];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (![self.searchBar.text isEqual:@""]) {
        [[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"ShowIndagoWithURL" object:self.searchBar.text];
    }

    [self.searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}
@end