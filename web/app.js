window.addEventListener('load', function(ev) {
      // Download main.dart.js
      _flutter.loader.loadEntrypoint({
        serviceWorker: {
          serviceWorkerVersion: serviceWorkerVersion,
        },
        onEntrypointLoaded: async function(engineInitializer) {
           const appRunner = await engineInitializer.initializeEngine();
           var loaderContent = document.querySelector('#loader');
           loaderContent.style.opacity = "0";
           await delay();
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
   document.querySelector('meta[name="theme-color"]').setAttribute("content", color);
}
