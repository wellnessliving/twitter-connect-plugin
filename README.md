# twitter-plugin
### **Using Twitter Kit 3**
Cordova/PhoneGap plugin to use Twitter Single Sign On 

Available on npm at: https://www.npmjs.com/package/cordova-twitter3-connect-plugin

### Install

##### Create a Twitter app

Create a Twitter application in https://apps.twitter.com and get the consumer key and secret under the "Keys and Access Tokens" tab.

IMPORTANT OR OTHERWISE LOGIN WILL FAIL: Make sure that the Callback URL contains:
```
twittersdk://
twitterkit-CONSUMERKEY://
```
See: https://developer.twitter.com/en/docs/basics/apps/guides/callback-urls.html

(replace CONSUMERKEY by your twitter app consumer key)

If desired to see the user's email (for example, by using the verify credentials endpoint), the "Additional Permissions" (in the "Permissions" tab) needs to be checked. Consequently, fill in the respective Privacy Policy URL and Terms of Service URL fields.

##### Add plugin to your Cordova app

Make sure you put in your valid API keys in their respective place.

`cordova plugin add https://github.com/guylando/twitterkit3-plugin --variable TWITTER_KEY=<Twitter Consumer Key> --variable TWITTER_SECRET=<Twitter Consumer Secret>`

IMPORTANT: This plugin has all necessary url scheme handling built-in and does not require you to add anything to your ios AppDelegate. However some plugins such as https://github.com/jeduan/cordova-plugin-facebook4 have openUrl code which prevents this plugin openUrl to run resulting in the login not finalizing after coming back to the app from the twitter webview. So if such problems are encountered then check which plugins are you using and fix the bug there. See: https://github.com/jeduan/cordova-plugin-facebook4/issues/166

### Usage

This plugin adds an object to the window named TwitterConnect. The following methods are provided by the plugin.

#### Login

Login using the `.login` method:
```
TwitterConnect.login(
  function(result) {
    console.log('[Login] - Successful login!');
    console.log(result);
  },
  function(error) {
    console.log('[Login] - Error logging in: ' + error);
  }
);
```

The login reponse object is defined as follows.
```
{
  userName: '<Twitter User Name>',
  userId: '<Twitter User Id>',
  secret: '<Twitter Oauth Secret>',
  token: '<Twitter Oauth Token>'
}
```

NOTE: This plugin has a fix to a bug appearing in the other twitter cordova plugins which returned userId as an integer which is fine in java but gets truncated in javascript because its too big for a javascript integer and thus this plugin fixed it by converting the user id to string before passing it to javascript which insures that correct userId is retrieved.

See:

https://twittercommunity.com/t/twitter-id-and-id-str-are-different/79942

https://developer.twitter.com/en/docs/basics/twitter-ids

https://developer.twitter.com/en/docs/tweets/data-dictionary/overview/user-object

NOTE: TwitterKit saves user id as a long and doesnt provide it as a string so need to convert to string before sending it to javascript

https://github.com/twitter/twitter-kit-android/blob/master/twitter-core/src/main/java/com/twitter/sdk/android/core/TwitterSession.java#L48

https://github.com/twitter/twitter-kit-android/blob/master/twitter-core/src/main/java/com/twitter/sdk/android/core/Session.java#L45

https://github.com/twitter/twitter-kit-android/blob/master/twitter-core/src/main/java/com/twitter/sdk/android/core/identity/AuthHandler.java#L91

https://github.com/twitter/twitter-kit-android/blob/master/twitter-core/src/main/java/com/twitter/sdk/android/core/models/User.java#L128

https://github.com/twitter/twitter-kit-android/blob/master/twitter-core/src/main/java/com/twitter/sdk/android/core/internal/oauth/OAuthResponse.java#L52

#### Logout

Logout using the `.logout` method:
```
TwitterConnect.logout(
  function() {
    console.log('[Logout] - Successful logout!');
  },
  function() {
    console.log('[Logout] - Error logging out');
  }
);
```

#### ShowUser

Show a user's profile information. Returns a JSON object as specified in the API: https://developer.twitter.com/en/docs/accounts-and-users/follow-search-get-users/api-reference/get-users-show
```
TwitterConnect.showUser(

  /*Endpoint arguments*/
  {"include_entities" : false},

  /*Callback functions*/
  function(result) {
    console.log('[ShowUser] - Success!');
    console.log(result);
    console.log('[ShowUser] - Twitter handle: ' + result.screen_name);
  },
  function(error) {
    console.log('[ShowUser] - Error: ' + error);
  }
);
```


#### VerifyCredentials

Show's a user's profile information with added details as specified. Returns a JSON object as specified in the API: https://developer.twitter.com/en/docs/accounts-and-users/manage-account-settings/api-reference/get-account-verify_credentials
```
TwitterConnect.verifyCredentials(

  /*Endpoint arguments*/
  {"include_entities": false,
  "skip_status" : true,
  "include_email": true},

  /*Callback functions*/
  function(result) {
    console.log('[VerifyCredentials] - Success!');
    console.log(result);
  },
  function(error) {
    console.log('[VerifyCredentials] - Error: ' +  error);
  }
);
```
