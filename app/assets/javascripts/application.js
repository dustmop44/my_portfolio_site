// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .
//= require jquery3
//= require bootstrap

$(function () {
  var lastScrollTop = 0;
  var $navbar = $('.navbar');
  var navbarHeight = $navbar.outerHeight();
  var movement = 0;
  var lastDirection = 0;

  $(window).scroll(function(event){
    var st = $(this).scrollTop();
    movement += st - lastScrollTop;

    if (st > lastScrollTop) { // scroll down
      if (lastDirection != 1) {
        movement = 0;
      }
      var margin = Math.abs(movement);
      if (margin > navbarHeight) {
        margin = navbarHeight;
      }
      margin = -margin;
      $navbar.css('margin-top', margin+"px")

      lastDirection = 1;
    } else { // scroll up
      if (lastDirection != -1) {
        movement = 0;
      }
      var margin = Math.abs(movement);
      if (margin > navbarHeight) {
        margin = navbarHeight;
      }
      margin = margin-navbarHeight;
      $navbar.css('margin-top', margin+"px")

      lastDirection = -1;
    }

    lastScrollTop = st;
    // console.log(margin);
  });
});


$(document).ready( function() {
	$(".quote").css("margin-top", 500);
});

function appenddiv(quote, quotelink) {
	$("#quotess").append('<div class = "container"><div class = "row" style = "margin-top: '
	 + (Math.floor(Math.random() * 500) + 1500)
	 + 'px"><div class = "col-md-4 col-md-offset-'
	 + Math.floor(Math.random() * 8)
	 + ' faded rellax" data-rellax-speed = "-'
	 + (Math.floor(Math.random() * 3) + 2) + '"><a class: "faded" href= "http://reddit.com/' + quotelink + '">'
	 + quote + '</a></div></div></div>');
}

$(document).ready(function() {
  var lazyloadImages;    

  if ("IntersectionObserver" in window) {
    lazyloadImages = document.querySelectorAll(".lazy");
    var imageObserver = new IntersectionObserver(function(entries, observer) {
      console.log(observer);
      entries.forEach(function(entry) {
        if (entry.isIntersecting) {
          var image = entry.target;
          image.src = image.dataset.src;
          image.classList.remove("lazy");
          imageObserver.unobserve(image);
        }
      });
    }, {
      root: document.querySelector("#container"),
      rootMargin: "0px 0px 10000px 0px"
    });

    lazyloadImages.forEach(function(image) {
      imageObserver.observe(image);
    });
  } else {  
    var lazyloadThrottleTimeout;
    lazyloadImages = $(".lazy");
    
    function lazyload () {
      if(lazyloadThrottleTimeout) {
        clearTimeout(lazyloadThrottleTimeout);
      }    

      lazyloadThrottleTimeout = setTimeout(function() {
          var scrollTop = $(window).scrollTop();
          lazyloadImages.each(function() {
              var el = $(this);
              if(el.offset().top < window.innerHeight + scrollTop + 500) {
                var url = el.attr("data-src");
                el.attr("src", url);
                el.removeClass("lazy");
                lazyloadImages = $(".lazy");
              }
          });
          if(lazyloadImages.length == 0) { 
            $(document).off("scroll");
            $(window).off("resize");
          }
      }, 20);
    }

    $(document).on("scroll", lazyload);
    $(window).on("resize", lazyload);
  }
})

window.addEventListener('scroll', function(e) {
	var scrolled = window.pageYOffset;
	const background = document.querySelector('.background');
	backround.style.top = - (scrolled * 0.5) + 'px';
});

