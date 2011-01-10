var x01, x01Player;
x01Player = (function() {
  function x01Player(name, starting_score, playerid) {
    this.name = name;
    this.starting_score = starting_score;
    this.r = Raphael("score" + playerid);
    this.score = starting_score;
    this.round_score = 0;
    this.reset();
  }
  x01Player.prototype.drawScore = function() {
    var text;
    this.r.clear();
    text = this.r.print(4, 24, this.score, this.r.getFont("Chalkduster"), 48);
    return text.attr({
      fill: "white"
    });
  };
  x01Player.prototype.startTurn = function() {
    return this.round_score = 0;
  };
  x01Player.prototype.win = function() {
    var text;
    this.r.clear();
    text = this.r.print(4, 24, 'WIN!', this.r.getFont("Chalkduster"), 48);
    return text.attr({
      fill: "white"
    });
  };
  x01Player.prototype.bust = function() {
    this.score += this.round_score;
    this.round_score = 0;
    return this.drawScore();
  };
  x01Player.prototype.hit = function(score) {
    this.round_score += score;
    this.score -= score;
    return this.drawScore();
  };
  x01Player.prototype.reset = function() {
    this.score = this.starting_score;
    this.round_score = 0;
    return this.drawScore();
  };
  return x01Player;
})();
x01 = (function() {
  function x01(starting_points) {
    this.paper = Raphael('board');
    this.starting_points = starting_points;
    this.clearStats();
    new DartBoard(this);
  }
  x01.prototype.clearStats = function() {
    this.hits = 0;
    this.player = 0;
    this.turns = 0;
    return this.game_over = false;
  };
  x01.prototype.start = function(players) {
    var i;
    this.players = [];
    for (i = 0; (0 <= players ? i < players : i > players); (0 <= players ? i += 1 : i -= 1)) {
      this.players[i] = new x01Player('bill', this.starting_points, i);
      this.players[i].drawScore();
    }
    return this.players[0].startTurn();
  };
  x01.prototype.restart = function() {
    var player, _i, _len, _ref, _results;
    this.clearStats();
    _ref = this.players;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      player = _ref[_i];
      _results.push(player.reset());
    }
    return _results;
  };
  x01.prototype.miss = function() {
    this.hits += 1;
    if (this.hits % 3 === 0) {
      this.turns += 1;
    }
    return this.player = this.turns % this.players.length;
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
        this.players[this.player].hit(score);
        break;
      case "win":
        this.players[this.player].win();
        this.game_over = true;
        break;
      case "bust":
        this.players[this.player].bust();
    }
    if (this.hits % 3 === 0) {
      this.players[this.player].startTurn();
    }
    return this.player = this.turns % this.players.length;
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