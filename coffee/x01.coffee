class x01Player
  constructor: (@name, @starting_score) ->
    $('#game').append('<div class="score"><div class="score-edit"><input /></div></div>')
    @element = $('#game .score:last')[0]
    $('.score-edit', @element).hide()

    @r = Raphael(@element)
    @score = starting_score
    @round_score = 0
    this.reset()

  drawScore: ->
    @r.clear()
    text = @r.print(4, 35, "#{@score}", @r.getFont("Chalkduster"), 48)
    text.attr({fill: "white"})
    this.drawName()
    if @active
      circle = @r.circle(8, 35, 4)
      circle.attr({fill: "red"})

  drawName: ->
    rect = @r.rect(140, 0, @r.width-140, @r.height)
    rect.attr({fill: "black"})
    rect.click (event) =>
      this.editName()
    name = @r.print(140, 35, @name, @r.getFont("Chalkduster"), 48)
    name.attr({fill: "white"})
    name.click (event) =>
      this.editName()

  editName: ->
    input = $('input', @element)
    input.val(@name)
    $('.score-edit', @element).show()
    input.focus()
    input.change (event) =>
      this.commitEdit()
    input.blur (event) =>
      this.commitEdit()
    input.keydown (event) =>
      this.commitEdit(false) if event.which == 27

  commitEdit: (setname=true) ->
    @name = $('input', @element).val() if setname
    $('.score-edit', @element).hide()
    this.drawScore()

  setInactive: ->
    @active = false
    this.drawScore()

  startTurn: ->
    @active      = true
    @round_score = 0
    this.drawScore()

  win: ->
    @r.clear()
    text = @r.print(4, 35, "WIN!", @r.getFont("Chalkduster"), 48)
    text.attr({fill: "white"})
    this.drawName()

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
  constructor:  (starting_points) ->
    @paper  = Raphael('board')
    @starting_points = starting_points
    this.clearStats()

    @players = []
    @game_started = false

    new DartBoard(this);

  addPlayer: ->
    player = new x01Player("Player #{@players.length + 1}", @starting_points)
    player.drawScore()
    @players.push(player)

  start: ->
    @game_started = true
    @players[0].startTurn()

  clearStats: ->
    @hits   = 0
    @player = 0
    @turns  = 0
    @game_over = false

  restart: ->
    @players[@player].setInactive()
    @players[0].startTurn()
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
