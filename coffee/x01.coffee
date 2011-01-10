class x01
  constructor:  (starting_points) ->
    @paper  = Raphael('board')
    @hits   = 0
    @player = 0
    @turns  = 0
    @starting_points = starting_points

    new DartBoard(this);

  start: (players) ->
    @game_over = false
    @players = []
    for i in [0...players]
      @players[i] = {r: Raphael("score#{i}"), score: @starting_points}
      this.setScoreText(@starting_points, @players[i])

  restart: ->
    @hits   = 0
    @player = 0
    @turns  = 0
    @game_over = false
    for player in @players
      player.score = @starting_points
      this.setScoreText(@starting_points, player)

  hit: (score) ->
    return if @game_over
    @hits += 1
    @turns += 1 if @hits % 3 == 0

    switch this.validateScore(score)
      when "good"
        @players[@player].score -= score
        this.setScoreText(@players[@player].score, @players[@player])
      when "win"
        this.setScoreText('WIN!', @players[@player])
        @game_over = true
      when "bust"
        this.setScoreText("BUST!", @players[@player])

    @player = @turns % @players.length

  setScoreText: (score, player) ->
    player.r.clear()
    text = player.r.print(4, 24, score, player.r.getFont("Chalkduster"), 48)
    text.attr({fill: "white"})

  validateScore: (score) ->
    return "good" if score < @players[@player].score
    return "win"  if @players[@player].score == score
    return "bust" if score > @players[@player].score
