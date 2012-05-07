
soundManager.url = '/assets/soundmanager/swf/';
soundManager.flashVersion = 9; // optional: shiny features (default = 8)
soundManager.useFlashBlock = false; // optionally, enable when you're ready to dive in
/*
 * read up on HTML5 audio support, if you're feeling adventurous.
 * iPad/iPhone and devices without flash installed will always attempt to use it.
*/
soundManager.onready(function() {
  // Ready to use; soundManager.createSound() etc. can now be called.
  console.log('on');
});

soundManager.onerror = function() {
  // SM2 could not start, no sound support, something broke etc. Handle gracefully.
//TODO:: Create user-info for this.
 console.log('you have an error -- no sound for you!');
}

soundManager.defaultOptions = {
 autoLoad: true
}