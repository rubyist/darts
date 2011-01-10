class x01
  constructor:  ->
    @paper = Raphael('board')
    @score = Raphael('score')

    new DartBoard(this);

  start: (starting_points) ->
    @game_over = false
    @current_score = starting_points
    this.updateScore()

  hit: (score) ->
    return if @game_over

    switch this.validateScore(score)
      when "good"
        @current_score -= score
        this.updateScore()
      when "win"
        this.setScoreText('WIN!')
        @game_over = true
      when "bust"
        this.setScoreText("BUST! #{@current_score}")

  updateScore: ->
    this.setScoreText(@current_score)

  setScoreText: (score) ->
    @score.clear()
    text = @score.print(4, 24, score, @score.getFont("Chalkduster"), 48)
    text.attr({fill: "white"})

  validateScore: (score) ->
    return "good" if score < @current_score
    return "win"  if @current_score == score
    return "bust" if score > @current_score
