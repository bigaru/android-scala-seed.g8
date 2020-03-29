enablePlugins(AndroidApp)

fork in Test := true

// Enforce Java 7 compilation (in case you have the JDK 8 installed)
javacOptions ++=
    "-source" :: "1.7" ::
    "-target" :: "1.7" ::
    Nil

libraryDependencies ++=
    "androidx.appcompat" % "appcompat" % "1.1.0" ::
    "org.scalatest" %% "scalatest" % "3.0.5" % "test" ::
    Nil

name := "App"

minSdkVersion := "24"

targetSdkVersion := "28"

platformTarget := "android-28"


// Prevent common com.android.builder.packaging.DuplicateFileException.
// Add further file names if you experience the exception after adding new dependencies
packagingOptions := PackagingOptions(
  excludes =
      "META-INF/LICENSE" ::
      "META-INF/LICENSE.txt" ::
      "META-INF/NOTICE" ::
      "META-INF/NOTICE.txt" ::
      Nil
)

proguardCache ++=
    "androidx" ::
    Nil

proguardOptions ++=
    "-keepattributes EnclosingMethod,InnerClasses,Signature" ::
    "-dontnote androidx.**" ::  // not ideal
    "-dontwarn androidx.appcompat.widget.**" ::
    // "-ignorewarnings" ::
      Nil

resolvers += "Google Maven" at "https://maven.google.com"

// Shortcut: allows you to execute "sbt run" instead of "sbt android:run"
run := (run in Android).evaluated

typedResources := false

scalacOptions ++=
    // Print detailed deprecation warnings to the console
    "-deprecation" ::
    // Print detailed feature warnings to the console
    "-feature" ::
    Nil

// Don't upgrade to 2.12.x as it requires Java 8 which does not work with Android
scalaVersion := "2.11.12"

versionCode := Some(1)

versionName := Some("0.0.1")

parallelExecution in Global := false
