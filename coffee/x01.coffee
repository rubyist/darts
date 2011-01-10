class x01Player
  constructor: (@name, @starting_score, playerid) ->
    @r = Raphael("score#{playerid}") # create a div?
    @score = starting_score
    @round_score = 0
    this.reset()

  drawScore: ->
    @r.clear()
    text = @r.print(4, 24, @score, @r.getFont("Chalkduster"), 48)
    text.attr({fill: "white"})

  startTurn: ->
    @round_score = 0

  win: ->
    @r.clear()
    text = @r.print(4, 24, 'WIN!', @r.getFont("Chalkduster"), 48)
    text.attr({fill: "white"})

  bust: ->
    @score += @round_score
    @round_score = 0
    this.drawScore()

  hit: (score) ->
    @round_score += score
    @score -= score
    this.drawScore()

  reset: ->
    @score = @starting_score
    @round_score = 0
    this.drawScore()

class x01
  constructor:  (starting_points) ->
    @paper  = Raphael('board')
    @starting_points = starting_points
    this.clearStats()

    new DartBoard(this);

  clearStats: ->
    @hits   = 0
    @player = 0
    @turns  = 0
    @game_over = false

  start: (players) ->
    @players = []
    for i in [0...players]
      @players[i] = new x01Player('bill', @starting_points, i)
      @players[i].drawScore()
    @players[0].startTurn()

  restart: ->
    this.clearStats()
    for player in @players
      player.reset()

  miss: ->
    @hits +=1
    @turns += 1 if @hits % 3 == 0
    @player = @turns % @players.length

  hit: (score) ->
    return if @game_over
    @hits += 1
    @turns += 1 if @hits % 3 == 0

    switch this.validateScore(score)
      when "good"
        @players[@player].hit(score)
      when "win"
        @players[@player].win()
        @game_over = true
      when "bust"
        @players[@player].bust()

    @players[@player].startTurn() if @hits % 3 == 0

    @player = @turns % @players.length

  validateScore: (score) ->
    return "good" if score < @players[@player].score
    return "win"  if @players[@player].score == score
    return "bust" if score > @players[@player].score
