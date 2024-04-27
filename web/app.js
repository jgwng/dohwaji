window.addEventListener('popstate', (event) => {
    console.log('event' + event.state)
//  navigate(event.state)
})


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
