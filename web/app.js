window.addEventListener('load', function(ev) {
  // Download main.dart.js
  let target = document.querySelector("#flutter-view");

  // Check if the user is on a mobile device (Android/iOS)
  const isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);

  _flutter.loader.loadEntrypoint({
    serviceWorker: {
      serviceWorkerVersion: serviceWorkerVersion,
    },
    onEntrypointLoaded: async function(engineInitializer) {
        const config = {
                          // Set hostElement based on device type
                          hostElement: isMobile ? null : target,
                          canvasKitBaseUrl: "./canvaskit/",
                          buildConfig: {
                              builds: [
                                {
                                  compileTarget: "dart2wasm",
                                  renderer: "skwasm",
                                  mainWasmPath: "main.dart.wasm",
                                  jsSupportRuntimePath: "main.dart.mjs"
                                },
                                {
                                  compileTarget: "dart2js",
                                  renderer: "canvaskit",
                                  mainJsPath: "main.dart.js"
                                }
                              ]
                            }
                       };
       const appRunner = await engineInitializer.initializeEngine(config);
       appRunner.runApp().then((_) => {
        document.querySelector('meta[name="viewport"]').setAttribute('content', "width=device-width, initial-scale=1.0, viewport-fit=cover");
      });
    }
  });
});
function delay(time){
    return new Promise(resolve => setTimeout(resolve,time));
}

function bottomInset() {
   var bottomPadding = parseFloat(getComputedStyle(document.documentElement).getPropertyValue("--sab"));
   return bottomPadding;
}

function topInset() {
   var topPadding = parseFloat(getComputedStyle(document.documentElement).getPropertyValue("--sat"));
   return topPadding;
}

function leftInset() {
   var leftPadding = parseFloat(getComputedStyle(document.documentElement).getPropertyValue("--sal"));
   return leftPadding;
}

function rightInset() {
   var rightPadding = parseFloat(getComputedStyle(document.documentElement).getPropertyValue("--sar"));
   return rightPadding;
}

function setMetaThemeColor(color) {
   console.log(color);
   document.querySelector('meta[name="theme-color"]').setAttribute("content", color);
}

async function removeSplashLogo() {
      document.querySelector('meta[name="viewport"]').setAttribute('content', "width=device-width, initial-scale=1.0, viewport-fit=cover");
      var loaderContent = document.querySelector('.splash');
      var flutterView = document.getElementById('flutter-view');
      // Fade out the splash screen
      loaderContent.style.opacity = "0";
      setTimeout(function () {
          loaderContent.style.display = "none"; // Hide splash completely after fade out
          flutterView.style.display = "flex";  // Show the Flutter view
          setTimeout(function () {
              flutterView.style.opacity = "1";  // Fade in the Flutter view
          }, 10); // short delay to ensure it starts after display change
      }, 400); // This timeout duration should match the CSS opacity transition duration
}
