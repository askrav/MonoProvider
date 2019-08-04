# MonoProvider

![Swift](http://img.shields.io/badge/swift-5.0-brightgreen.svg)
![Vapor](http://img.shields.io/badge/vapor-3.0-brightgreen.svg)

[MonoProvider][mono_home] is a Vapor 3 package for the MonoBank API.

## How To Use
In your `Package.swift` file, add the following line:

~~~~swift
.package(url: "https://github.com/askrav/MonoProvider.git", from: "1.0.0")
~~~~

Register the config and the provider in `configure.swift`
~~~~swift
//Public API
let monoPublicConfig = MonoPublicConfig()
services.register(monoPublicConfig)
try services.register(MonoPublicProvider())

//Personal API
let monoPersonalConfig = MonoPersonalConfig(xToken: "YOUR_PERSONAL_TOKEN")
services.register(monoPersonalConfig)
try services.register(MonoPersonalProvider())
~~~~


An usage example:
~~~swift
static func getPersonalInfo(_ req: Request) throws -> Future<UserInfo> {
return try req.make(MonoPersonalClient.self).personal.userInfo().flatMap { userInfo in
let userName = userInfo.name
// ...
// Do whatever you need to
// ...
return req.future(userInfo)
}
}
~~~


All the documentation is available on the [MonoBank API][mono_api] website.


Mono Provider is available under the MIT license. See the [LICENSE](LICENSE) file for more info.


[mono_home]: https://monobank.ua/ "MonoBank"
[mono_api]: https://api.monobank.ua/docs/ "MonoBank API"
