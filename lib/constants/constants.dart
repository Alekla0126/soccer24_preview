
class Constants {
  Constants._();

  //URLs
  static const String playStoreUrl = 'https://play.google.com/store/apps/details?id=com.alekla0126.soccer24';
  static const String appStoreUrl = 'https://apps.apple.com/us/app/soccer24-social-media/id6737065907';

  // Todo: Change the constants of the Info of the app.
  static const String privacyUrl = 'https://alekla0126.github.io/soccer24web/generic.html';
  static const String termsUrl = 'https://alekla0126.github.io/soccer24web/terms.html';
  // static const String faqUrl = 'https://home.microsoftpersonalcontent.com/:fl:/r/contentstorage/CSP_29329f33-c1bf-477e-99fb-a40ccdd14d53/Document%20Library/LoopAppData/Frequently%20Asked%20Questions.loop?d=wece5a433409548bf854259b6de8553ae&csf=1&web=1&e=eefCCy&nav=cz0lMkZjb250ZW50c3RvcmFnZSUyRkNTUF8yOTMyOWYzMy1jMWJmLTQ3N2UtOTlmYi1hNDBjY2RkMTRkNTMmZD1iJTIxTTU4eUtiX0Jma2VaLTZRTXpkRk5VX3VCM2RpZDFfTkx1clNQOGlyM3JuQVpKSERCb3ZqdVJaSk0wTWRoY2M1aCZmPTAxVlg3QTRaWlRVVFM2WkZLQVg1RUlLUVNaVzNQSUtVNU8mYz0lMkYmYT1Mb29wQXBwJnA9JTQwZmx1aWR4JTJGbG9vcC1wYWdlLWNvbnRhaW5lciZ4PSU3QiUyMnclMjIlM0ElMjJUMFJUVUh4b2IyMWxMbTFwWTNKdmMyOW1kSEJsY25OdmJtRnNZMjl1ZEdWdWRDNWpiMjE4WWlGTk5UaDVTMkpmUW1aclpWb3RObEZOZW1SR1RsVmZkVUl6Wkdsa01WOU9USFZ5VTFBNGFYSXpjbTVCV2twSVJFSnZkbXAxVWxwS1RUQk5aR2hqWXpWb2ZEQXhWbGczUVRSYVdqWTFURmszVmtRMFdUZEtRakpOUTB0WlYwMDFRMFF6V1VvJTNEJTIyJTJDJTIyaSUyMiUzQSUyMjM4NWQ5MzgzLTIxNzAtNDY1Ni1iOGE5LWI0OWJkODM5NjI0ZSUyMiU3RA%3D%3D';

  //Hive boxes names
  static const String leaguesBox = 'LeaguesBox';
  static const String pinnedLeaguesBox = 'PinnedLeaguesBox';

  //Firebase collections names
  static const String usersColName = 'Users';
  static const String tipsColName = 'Tips';
  static const String tipsLikesColName = 'TipsLikes';

  //Dates
  static DateTime firstFixtureDate = DateTime(2010, 1, 1);
  static DateTime firstTipDate = DateTime(2024, 2, 20);

  //Admob test ad units
  static const String admobBannerAdUnitIdTest = 'ca-app-pub-7382185127986341/6052014517';
  static const String admobMRecAdUnitIdTest = 'ca-app-pub-7382185127986341/8379068026';
  static const String admobInterstitialAdUnitIdTest = 'ca-app-pub-7382185127986341/4795046230';
  static const String admobAppOpenAdUnitIdTest = 'ca-app-pub-7382185127986341/2388374746';

  //Match Minutes Values
  static const List<String> matchMinutesValues = [
    '0-15',
    '16-30',
    '31-45',
    '46-60',
    '61-75',
    '76-90',
    '91-105',
    '106-120',
  ];
}