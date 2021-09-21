return {
  VERSION = { major=1, minor=0, revision=0, },
 
  LrSdkVersion = 9.0,
  LrSdkMinimumVersion = 4.0,
 
  LrToolkitIdentifier = "com.akrabat.hello",
  LrPluginName = "Hello",
  LrPluginInfoUrl="https://akrabat.com/writing-a-lightroom-classic-plug-in",
  LrLibraryMenuItems  = {
    {
      title = "Hello",
      file = "hello.lua",
    },
  },
}