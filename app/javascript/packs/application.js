require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
require('jquery')

var calculatePayout = function (wager, payout_ratio) {
  if (payout_ratio < 0) {
    return (wager * 100.0 / (payout_ratio * -1)).toFixed(2)
  } else {
    return (wager * payout_ratio / 100.0).toFixed(2)
  }
}

var initializeWagerField = function () {
  $(".wager_field input").change(function () {
    $parent = $(this).parent();

    var wager = parseFloat($(this).val());
    var payoutRatio = parseFloat($parent.children(".payout_ratio").first().html());
    var payout = calculatePayout(wager, payoutRatio);

    $parent.next(".to_win_field").children(".to_win_amount").html(payout);
  });
}

$(document).on('turbolinks:load', function () {
  console.log("init");
  $bet_pop_up = $("#bet_pop_up");
  $bet_pop_up_content = $("#bet_pop_up_content");
  $close_bet_pop_up = $("#close_bet_pop_up ");
  
  $(".tournament-match-up.open td").click(function () {
    $hiddenForm = $(this).children(".hidden_bet_form");
    if ($hiddenForm.length > 0) {
      $bet_pop_up_content.html($hiddenForm.html());
      if (!$bet_pop_up.is(":visible")) {
        $bet_pop_up.slideToggle();
      }
      initializeWagerField();
    }
  });

  $close_bet_pop_up.click(function () {
    $bet_pop_up.slideToggle();
  });

  $("#submit_pop_up_form").click(function () {
    $(this).hide();
    $bet_pop_up_content.find(":submit").click();
  });
});


