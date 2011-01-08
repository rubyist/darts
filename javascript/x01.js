var x01;
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
        this.setScoreText('WIN!');
        return this.game_over = true;
      case "bust":
        return this.setScoreText("BUST! " + this.current_score);
    }
  };
  x01.prototype.updateScore = function() {
    return this.setScoreText(this.current_score);
  };
  x01.prototype.setScoreText = function(text) {
    return $('#score').text(text);
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