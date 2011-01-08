class x01
  constructor:  ->
    @paper = Raphael('board')
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
        this.setScoreText(0)
        @game_over = true
      when "bust"
        this.setScoreText("BUST! #{@current_score}")

  updateScore: ->
    this.setScoreText(@current_score)

  setScoreText: (score) ->

    hundreds = parseInt(score / 100)
    tens = parseInt((score - 100 * hundreds) / 10)
    ones = (score - 100 * hundreds - 10 * tens)

    if score == 0
      $('.score .ns').hide()
      $('.score .win').show()
      return
    else
      $('.score .ns').show()
      $('.score .win').hide()

    $('.score div').removeClass (index, klass) =>
      matches = klass.match(/n\d|blank/g) || []
      matches.join(' ')

    if hundreds > 0
      $('.score .h').addClass('n'+hundreds)
    else
      $('.score .h').addClass('blank')

    if hundreds == 0 && tens == 0
      $('.score .t').addClass('blank')
    else
      $('.score .t').addClass('n'+tens)

    $('.score .o').addClass('n'+ones)


  validateScore: (score) ->
    return "good" if score < @current_score
    return "win"  if @current_score == score
    return "bust" if score > @current_score
