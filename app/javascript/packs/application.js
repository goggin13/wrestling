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

postBet = function(match_id, wager, over_under) {

};

$(document).on('turbolinks:load', function () {
  $(".tournament-match-up.open .home, .tournament-match-up.open .away").click(function () {
    $this = $(this);
    $parent = $this.parent(".tournament-match-up")
    if ($parent.hasClass("loading")) {
      return false;
    } else {
      $parent.addClass("loading");
    }

    match_id = $parent.attr("data-match-id");
    wager = $(this).hasClass("home") ? "home" : "away";

    $.post("/bets.json", {bet: {match_id: match_id, wager: wager}})
      .done(function (data) {
        console.log(data);
        $parent.children(".home, .away").removeClass("selected");
        $this.addClass("selected");
        $parent.removeClass("loading")
      }).fail(function (data) {
        console.log(data.responseJSON);
        if (data.responseJSON.match[0] == "Must be open for betting") {
          $parent.children(".tournament-match-up.open .home, .tournament-match-up.open .away").unbind("click");
          $parent.removeClass("loading")
          $parent.removeClass("open");
          $parent.addClass("closed");
        }
      });
  });

  $(".tournament-match-up.open .over-under button").click(function () {

    $(".tournament-match-up.open .over-under button").removeClass("over-under-selected");
    $(this).addClass("over-under-selected");
    $this = $(this);

    $parent = $this.parent(".tournament-match-up")
    match_id = $parent.attr("data-match-id");

    over_under = $this.hasClass("over") ? "over" : "under";

    $.post("/bets.json", {bet: {match_id: match_id, over_under: over_under}})
      .done(function (data) {
        console.log(data);
        $this.addClass("over-under-selected");
      }).fail(function (data) {
        console.log(data.responseJSON);
        if (data.responseJSON.match[0] == "Must be open for betting") {
          $parent.children(".tournament-match-up.open .home, .tournament-match-up.open .away").unbind("click");
          $parent.removeClass("loading")
          $parent.removeClass("open");
          $parent.addClass("closed");
        }
      });
  });
});


$(document).on('turbolinks:load', function () {
  if (window.location.pathname.includes("display")) {
    resetVictoryCheck();
    setInterval(updateCurrentMatch, 5000);
  }
});

function updateCurrentMatch () {
  matchId = $("body").attr("data-match-id");
  tournamentId = $("body").attr("data-tournament-id");

  $.getJSON("/tournaments/" + tournamentId + ".json")
    .done(function (tournament) {
      if (tournament.current_match_id == null && matchId == -1) {
        return false;
      } else if (tournament.current_match_id != matchId) {
        console.log("fadeOut");
        $("img:visible, p:visible, div:visible").fadeOut(5000, function () {
          console.log("reload");
          window.location.reload(true);
        });
      }
    }).fail(function (data) {
      console.log("ERROR - failed to get tournament data");
      console.log(data);
    });
};

function resetVictoryCheck () {
  setTimeout(checkForVictory, 5000);
};

window.displayResults = function (match) {
  console.log(match);
  winner_id = match.winner_id
  if (match.home_wrestler_id === match.winner_id) {
    loser_id = match.away_wrestler_id;
  } else {
    loser_id = match.home_wrestler_id;
  }

  $winner = $("#wrestler-" + winner_id);
  $loser = $("#wrestler-" + loser_id);

  $loser.children(".wrestler_name").fadeOut(2500);
  $loser.children(".wrestler_avatar").fadeOut(2500, function () {
    $loser.children(".fatality").fadeIn(5000);
    $.each(match.payouts, function (user_id, payout) {
      console.log(user_id, " , ", payout);
      $bet = $(".matchup_wrestler .user_" + user_id).parent(".bet")
      $bet.children(".payout").html("+" + payout);
      if (payout == 0) {
        $bet.addClass("lost");
      } else {
        $bet.addClass("won");
      }
    });
  });
};

function checkForVictory () {
  matchId = $("body").attr("data-match-id");
  if (matchId == -1) {
    return false;
  }

  $.getJSON("/matches/" + matchId + ".json")
    .done(function (match) {
      if (match.winner_id) {
        displayResults(match);
      } else {
        resetVictoryCheck();
      }
    }).fail(function (data) {
      console.log("ERROR - failed to get match data");
      console.log(data);
    });
};
