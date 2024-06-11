document.oncontextmenu = function(){
  return false;
};
// Get references to the progress bar container and the progress bar element.
const progress = document.getElementById("progress");
const progressBar = document.getElementById("progressbar");

// Set the initial width of the progress bar to 0%.
progress.style.width = `0%`;

function getElementPosition(element) {
            const rect = element.getBoundingClientRect();
            return {
                top: rect.top + window.scrollY,
                left: rect.left + window.scrollX,
                bottom: rect.bottom + window.scrollY,
                right: rect.right + window.scrollX,
                width: rect.width,
                height: rect.height
            };
        }

window.addEventListener('load', function(ev) {
  // Set an initial progress of 33% when the page loads.
  progress.style.width = `33%`;
 const myElement = document.getElementById('logo');
 const position = getElementPosition(myElement);
 console.log('Element Position:', position);
  // Download main.dart.js
  let target = document.querySelector("#flutter-view");

  // Check if the user is on a mobile device (Android/iOS)
  const isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);

  _flutter.loader.loadEntrypoint({
    serviceWorker: {
      serviceWorkerVersion: serviceWorkerVersion,
    },
    onEntrypointLoaded: async function(engineInitializer) {
         // Update progress to 66% after the entry point is loaded.
         progress.style.width = `66%`;
        const config = {
                          // Set hostElement based on device type
                          hostElement: isMobile ? null : target,
                          canvasKitBaseUrl: "./canvaskit/",
                          useColorEmoji:true,
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
       // Set progress to 99% before adding a delay.
       progress.style.width = `100%`;

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
