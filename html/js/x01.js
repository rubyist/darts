var x01;
x01 = (function() {
  function x01(starting_points) {
    this.paper = Raphael('board');
    this.hits = 0;
    this.player = 0;
    this.turns = 0;
    this.starting_points = starting_points;
    new DartBoard(this);
  }
  x01.prototype.start = function(players) {
    var i, _results;
    this.game_over = false;
    this.players = [];
    _results = [];
    for (i = 0; (0 <= players ? i < players : i > players); (0 <= players ? i += 1 : i -= 1)) {
      this.players[i] = {
        r: Raphael("score" + i),
        score: this.starting_points
      };
      _results.push(this.setScoreText(this.starting_points, this.players[i]));
    }
    return _results;
  };
  x01.prototype.restart = function() {
    var player, _i, _len, _ref, _results;
    this.hits = 0;
    this.player = 0;
    this.turns = 0;
    this.game_over = false;
    _ref = this.players;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      player = _ref[_i];
      player.score = this.starting_points;
      _results.push(this.setScoreText(this.starting_points, player));
    }
    return _results;
  };
  x01.prototype.hit = function(score) {
    if (this.game_over) {
      return;
    }
    this.hits += 1;
    if (this.hits % 3 === 0) {
      this.turns += 1;
    }
    switch (this.validateScore(score)) {
      case "good":
        this.players[this.player].score -= score;
        this.setScoreText(this.players[this.player].score, this.players[this.player]);
        break;
      case "win":
        this.setScoreText('WIN!', this.players[this.player]);
        this.game_over = true;
        break;
      case "bust":
        this.setScoreText("BUST!", this.players[this.player]);
    }
    return this.player = this.turns % this.players.length;
  };
  x01.prototype.setScoreText = function(score, player) {
    var text;
    player.r.clear();
    text = player.r.print(4, 24, score, player.r.getFont("Chalkduster"), 48);
    return text.attr({
      fill: "white"
    });
  };
  x01.prototype.validateScore = function(score) {
    if (score < this.players[this.player].score) {
      return "good";
    }
    if (this.players[this.player].score === score) {
      return "win";
    }
    if (score > this.players[this.player].score) {
      return "bust";
    }
  };
  return x01;
})();