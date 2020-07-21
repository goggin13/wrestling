// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
require('jquery')


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
//

$(document).ready(function () {
  $(".tournament-match-up .home, .tournament-match-up .away").click(function () {
    parent = $(this).parent(".tournament-match-up")
    parent.children(".home, .away").removeClass("selected");
    $(this).addClass("selected");

    match_id = parent.attr("data-match-id");
    wager = $(this).hasClass("home") ? "home" : "away";
    console.log("match ", match_id, " bet on ", wager);
    $.post("/bets.json", {bet: {match_id: match_id, wager: wager}}).done(function (data) {
      console.log(data);
    });
  });
});
