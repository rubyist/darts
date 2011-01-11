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
    if @active
      circle = @r.circle(8, 24, 4)
      circle.attr({fill: "red"})

  setInactive: ->
    @active = false
    this.drawScore()

  startTurn: ->
    @active      = true
    @round_score = 0
    this.drawScore()

  win: ->
    @r.clear()
    text = @r.print(4, 24, 'WIN!', @r.getFont("Chalkduster"), 48)
    text.attr({fill: "white"})

  bust: ->
    @score += @round_score
    @round_score = 0
    @active = false
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
  constructor:  (starting_points, players) ->
    @paper  = Raphael('board')
    @starting_points = starting_points
    this.clearStats()

    @players = []
    for i in [0...players]
      @players[i] = new x01Player('bill', @starting_points, i)
      @players[i].drawScore()

    @players[@player].startTurn()

    new DartBoard(this);

  clearStats: ->
    @hits   = 0
    @player = 0
    @turns  = 0
    @game_over = false

  restart: ->
    this.clearStats()
    for player in @players
      player.reset()

  miss: ->
    @hits +=1
    this.nextPlayer() if @hits % 3 == 0

  hit: (score) ->
    return if @game_over
    @hits += 1

    switch this.validateScore(score)
      when "good"
        @players[@player].hit(score)
        this.nextPlayer() if @hits % 3 == 0
        break
      when "win"
        @players[@player].win()
        @game_over = true
        break
      when "bust"
        @players[@player].bust()
        this.nextPlayer()
        break

  nextPlayer: ->
    @turns += 1
    @hits = 0
    @players[@player].setInactive()
    @player = @turns % @players.length
    @players[@player].startTurn()

  validateScore: (score) ->
    return "good" if score < @players[@player].score
    return "win"  if @players[@player].score == score
    return "bust" if score > @players[@player].score
