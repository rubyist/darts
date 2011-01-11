var x01, x01Player;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
x01Player = (function() {
  function x01Player(name, starting_score) {
    this.name = name;
    this.starting_score = starting_score;
    $('#game').append('<div class="score"><div class="score-edit"><input /></div></div>');
    this.element = $('#game .score:last')[0];
    $('.score-edit', this.element).hide();
    this.r = Raphael(this.element);
    this.score = starting_score;
    this.round_score = 0;
    this.reset();
  }
  x01Player.prototype.drawScore = function() {
    var circle, text;
    this.r.clear();
    text = this.r.print(4, 35, "" + this.score, this.r.getFont("Chalkduster"), 48);
    text.attr({
      fill: "white"
    });
    this.drawName();
    if (this.active) {
      circle = this.r.circle(8, 35, 4);
      return circle.attr({
        fill: "red"
      });
    }
  };
  x01Player.prototype.drawName = function() {
    var name, rect;
    rect = this.r.rect(140, 0, this.r.width - 140, this.r.height);
    rect.attr({
      fill: "black"
    });
    rect.click(__bind(function(event) {
      return this.editName();
    }, this));
    name = this.r.print(140, 35, this.name, this.r.getFont("Chalkduster"), 48);
    name.attr({
      fill: "white"
    });
    return name.click(__bind(function(event) {
      return this.editName();
    }, this));
  };
  x01Player.prototype.editName = function() {
    var input;
    input = $('input', this.element);
    input.val(this.name);
    $('.score-edit', this.element).show();
    input.focus();
    input.change(__bind(function(event) {
      return this.commitEdit();
    }, this));
    input.blur(__bind(function(event) {
      return this.commitEdit();
    }, this));
    return input.keydown(__bind(function(event) {
      if (event.which === 27) {
        return this.commitEdit(false);
      }
    }, this));
  };
  x01Player.prototype.commitEdit = function(setname) {
    if (setname == null) {
      setname = true;
    }
    if (setname) {
      this.name = $('input', this.element).val();
    }
    $('.score-edit', this.element).hide();
    return this.drawScore();
  };
  x01Player.prototype.setInactive = function() {
    this.active = false;
    return this.drawScore();
  };
  x01Player.prototype.startTurn = function() {
    this.active = true;
    this.round_score = 0;
    return this.drawScore();
  };
  x01Player.prototype.win = function() {
    var text;
    this.r.clear();
    text = this.r.print(4, 35, "WIN!", this.r.getFont("Chalkduster"), 48);
    text.attr({
      fill: "white"
    });
    return this.drawName();
  };
  x01Player.prototype.bust = function() {
    this.score += this.round_score;
    this.round_score = 0;
    this.active = false;
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
    this.players = [];
    this.game_started = false;
    new DartBoard(this);
  }
  x01.prototype.addPlayer = function() {
    var player;
    player = new x01Player("Player " + (this.players.length + 1), this.starting_points);
    player.drawScore();
    return this.players.push(player);
  };
  x01.prototype.start = function() {
    this.game_started = true;
    return this.players[0].startTurn();
  };
  x01.prototype.clearStats = function() {
    this.hits = 0;
    this.player = 0;
    this.turns = 0;
    return this.game_over = false;
  };
  x01.prototype.restart = function() {
    var player, _i, _len, _ref, _results;
    this.players[this.player].setInactive();
    this.players[0].startTurn();
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
      return this.nextPlayer();
    }
  };
  x01.prototype.hit = function(score) {
    if (this.game_over) {
      return;
    }
    this.hits += 1;
    switch (this.validateScore(score)) {
      case "good":
        this.players[this.player].hit(score);
        if (this.hits % 3 === 0) {
          this.nextPlayer();
        }
        break;
      case "win":
        this.players[this.player].win();
        this.game_over = true;
        break;
      case "bust":
        this.players[this.player].bust();
        this.nextPlayer();
        break;
    }
  };
  x01.prototype.nextPlayer = function() {
    this.turns += 1;
    this.hits = 0;
    this.players[this.player].setInactive();
    this.player = this.turns % this.players.length;
    return this.players[this.player].startTurn();
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