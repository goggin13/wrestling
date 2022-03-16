console.log("display.js executed");

$(document).ready(function () {
  console.log("display.js ready");
  var matchId = $("body").attr("data-match-id");
  if (matchId != -1) {
    $(".leaderboard_data").show();
  } else {
    $($("#leaderboard tr").get().reverse()).each(function (i, element) {
      $tr = $($(this));
      $tr.find(".leaderboard_data").delay(1000 * (i + 1)).fadeIn(3000);
    });
  }

  setInterval(pollForTournamentChange, 5000);
  pollForMatchWinner();
});

var pollForMatchWinner = function () {
  var matchId = $("body").attr("data-match-id");
  if (matchId < 0) {
    console.log("no match");
    return;
  }
  var poll = function () {
    $.getJSON("/matches/" + matchId + ".json")
      .done(function (match) {
        console.log(match);
        if (match.home_score !== null) {
          console.log("winner!");
          setWinner(match.home_score > match.away_score ? "home" : "away");
        } else {
          setTimeout(poll, 5000);
        }
      }).fail(function (data) {
        console.log("ERROR - failed to get match data");
        console.log(data);
      });
  }
  poll();
}

var pollForTournamentChange = function () {
  var matchId = $("body").attr("data-match-id");
  var tournamentId = $("body").attr("data-tournament-id");
  $.getJSON("/tournaments/" + tournamentId + ".json")
    .done(function (tournament) {
			console.log(tournament);
      if (tournament.current_match_id == null && matchId == -1) {
        return false;
      } else if (tournament.current_match_id == null && matchId != -1) {
        console.log("fadeOut");
        $("img:visible, p:visible, div:visible, table").fadeOut(2500, function () {
          console.log("reload");
          window.location.reload(true);
        });
      } else if (tournament.current_match_id != matchId) {
        console.log("reload");
        window.location.reload(true);
      }
    }).fail(function (data) {
      console.log("ERROR - failed to get tournament data");
      console.log(data);
    });
}

var setWinner = function(winner) {
  var loser = (winner == "home" ? "away" : "home");
  var $loserDiv = $("#wrestler_" + loser);
  $loserDiv.children(".user_bets").fadeOut();
  $loserDiv.children(".wrestler_name").html("Defeated");
  $loserDiv.children(".wrestler_avatar").fadeOut(function () {
    $loserDiv.children(".fatality").fadeIn();
  });
}

$(document).on('load turbolinks:load', function () {
  console.log("display.js turbolinks loaded");
});
