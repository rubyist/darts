var x01;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
x01 = (function() {
  function x01() {
    this.paper = Raphael('board');
    new DartBoard(this);
  }
  x01.prototype.start = function(starting_points) {
    this.game_over = false;
    this.current_score = starting_points;
    return this.updateScore();
  };
  x01.prototype.hit = function(score) {
    if (this.game_over) {
      return;
    }
    switch (this.validateScore(score)) {
      case "good":
        this.current_score -= score;
        return this.updateScore();
      case "win":
        this.setScoreText(0);
        return this.game_over = true;
      case "bust":
        return this.setScoreText("BUST! " + this.current_score);
    }
  };
  x01.prototype.updateScore = function() {
    return this.setScoreText(this.current_score);
  };
  x01.prototype.setScoreText = function(score) {
    var hundreds, ones, tens;
    hundreds = parseInt(score / 100);
    tens = parseInt((score - 100 * hundreds) / 10);
    ones = score - 100 * hundreds - 10 * tens;
    if (score === 0) {
      $('.score .ns').hide();
      $('.score .win').show();
      return;
    } else {
      $('.score .ns').show();
      $('.score .win').hide();
    }
    $('.score div').removeClass(__bind(function(index, klass) {
      var matches;
      matches = klass.match(/n\d|blank/g) || [];
      return matches.join(' ');
    }, this));
    if (hundreds > 0) {
      $('.score .h').addClass('n' + hundreds);
    } else {
      $('.score .h').addClass('blank');
    }
    if (hundreds === 0 && tens === 0) {
      $('.score .t').addClass('blank');
    } else {
      $('.score .t').addClass('n' + tens);
    }
    return $('.score .o').addClass('n' + ones);
  };
  x01.prototype.validateScore = function(score) {
    if (score < this.current_score) {
      return "good";
    }
    if (this.current_score === score) {
      return "win";
    }
    if (score > this.current_score) {
      return "bust";
    }
  };
  return x01;
})();