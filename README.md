# GradeManager



🎓A modern App to manage and track your grades 🎓

📖Compiles to Windows, Linux, MacOS, IOS and Android📖



## ⚠️Issues/Feature Requests ➕

To submit an issue in the app or request a feature, you can simply open a Github issue.

There are no specific guidelines, but please clearly describe the problem/feature and include screenshots if possible.

Alternatively, you can also send an email to grademanager@gmx.ch to submit a problem/feature.



## 🚀Integration/Deployment 🚀

This Repository uses a CI/CD Pipe (with Github Actions) to automatically build and deploy the Software for Windows, Android and Linux and upload them to the official [GradeManager Website](https://grademanager.megakuul.ch). The Website is hosted on Netlify and uses another CI/CD Pipeline to deploy the Website.



If a branch gets merged (or directly pushed) into the main branch, the Pipeline will build the software.

The Inno Setup script to build the Windows installer, is found in the Repositoy under `installer.iss`.

**Important:**

For the build and the deployment there are some keys stored in the Repositorys Secret Vault (they are required to run the build.yml Action):

```yaml
KEYSTORE_PASSWORD  = <Keystorepassword for Android Signing key>
KEY_PASSWORD       = <Keypassword for Android Signing key>
KEY_ALIAS          = <keyalias for Android Signing key> #default -> upload
KEYSTORE_BASE64    = <Android Signing key (.jks) in Base64 format>
BOT_ACCESS_TOKEN   = <Github Access token from the BOT>
```

**Apple Builds**

I decided to remove macOS and iOS support. The fact that I spent some hours figuring out why CocoaPods didn't compile on a freshly installed Action Runner without getting any useful errors made me question if my time was well spent creating an automated build for a proprietary, closed-source operating system.

If you are a proud Apple user and believe that this OS is flawless, compile the project yourself. Good luck...
