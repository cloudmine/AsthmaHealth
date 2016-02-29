# AsthmaHealth

A demo application that showcases the CloudMine [CMHealthSDK](https://github.com/cloudmine/CMHealthSDK) interface for Apple [ResearchKit](http://http://researchkit.org/).


## CMHealthSDK and ResearchKit

ResearchKit is an Apple framework geared toward the applications of medical researchers.  By itself, ResearchKit is a powerful tool for managing patient consent flows and charting patient activities.  However, ResearchKit provides no mechanisms for storing the patient consent documents or other data it generates.  This is where CloudMine and the [CMHealthSDK](https://github.com/cloudmine/CMHealthSDK) step in.

The [CMHealthSDK](https://github.com/cloudmine/CMHealthSDK) uses the [CloudMine](https://cloudmineinc.com) Connected Health Cloud to manage the user and data needs of ResearchKit applications.  Through the CMHealthSDK, your application can create patient accounts in the cloud, store consent documents and survey data associated with that patient, and even send the patient an email if they forget their password.  Application developers can further leverage patient data using either the [CloudMine iOS SDK](https://cloudmine.io/docs/#/ios) within the application itself, or create a patient portal using the [CloudMine JavaScript SDK](https://cloudmine.io/docs/#/javascript).  In all cases, the data is stored on the CloudMine Connected Health Cloud, a HIPAA HITECH compliant cloud data platform for healthcare.


## Getting Started

This demo application requires [CocoaPods](https://cocoapods.org/) for dependency management.  First, install the `cocoapods` gem:

```
#> sudo gem install cocoapods
```

Then you can proceed to configure and build the project:

```
#> git clone https://github.com/cloudmine/AsthmaHealth.git
#> cd AsthmaHealth
#> cp AsthmaHealth/SupportingFiles/Secrets.h-Template AsthmaHealth/SupportingFiles/Secrets.h
#> pod install
#> open AsthmaHealth.xcworkspace
```

The project should now open and build.


## Your CloudMine Application

You will want to edit `Secret.h` and add your CloudMine [App ID](https://cloudmine.io/docs/#/getting_started#welcome-to-cloudmine) and [API Key](https://cloudmine.io/docs/#/data_security).

Need a [CloudMine](https://cloudmineinc.com) account?  Email our [Sales team](mailto:sales@cloudmineinc.com).
