# how-much

iOS app to record how much things cost using various data persistence implementations. 

The basic data unit is an `item`, a simple dictionary:

```objc
{
    "8ACB9857-5385-4B83-8C36-9FEB278DA86E" =     {
        brand = "Georgia Pacific";
        dateUpdated = 1465489172;
        name = Paper;
        price = 5;
        store = Amazon;
        unit = "Ream (500 Sheets)";
    };
}
```

The app can keep a list of such items (add, edit and delete) :moneybag:

The bulk of the code is in [`HowMuch-Core`](HowMuch-Core) using [`auth`](https://github.com/dkhamsing/DKAuthenticationViewController/blob/master/DKAuthenticationViewController/DKAuthenticationProtocol.h) and [`storage`](HowMuch-Core/StorageProtocol.h) protocols:

1. [User Defaults](HowMuch-UserDefaults/)

## Contact

- [github.com/dkhamsing](https://github.com/dkhamsing)
- [twitter.com/dkhamsing](https://twitter.com/dkhamsing)
