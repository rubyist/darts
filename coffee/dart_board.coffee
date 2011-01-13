class DartBoard
  ScoreOrder: [20, 1, 18, 4, 13, 6, 10, 15, 2, 17, 3, 19, 7, 16, 8, 11, 14, 9, 12, 5]

  constructor: (@game) ->
    @paper = @game.paper

    # These are all the same because we're drawing in a square portion
    @originX = Math.min(@paper.width, @paper.height) / 2
    @originY = Math.min(@paper.width, @paper.height) / 2
    @radius  = Math.min(@paper.width, @paper.height) / 2 - 15

    this.draw()

  draw: ->
    idx = 0
    for score in this.ScoreOrder
      slice = new BoardSlice(score, this)
      slice.color(idx)
      slice.rotate(idx * 18)
      idx += 1
    new BullsEye(this)

  emitScore: (score) ->
    @game.hit(score)



class BullsEye
  constructor: (@board) ->
    this.draw()

  draw: ->
    single = @board.paper.circle(@board.originX, @board.originY, @board.radius * 0.1)
    single.attr({fill: "#60af75", "stroke-width": 2, "stroke": "#999999"})
    single.click (event) =>
      this.emitHit(25)


    double = @board.paper.circle(@board.originX, @board.originY, @board.radius * 0.048)
    double.attr({fill: "#bb2e36", "stroke-width": 2, "stroke": "#999999"})
    double.click (event) =>
      this.emitHit(50)

    single.mouseover (event) =>
      single.toFront()
      double.toFront()
      single.animate({scale: "1.07"}, 250, "bounce")

    single.mouseout (event) =>
      single.stop()
      single.animate({scale: "1"}, 250, "bounce")

    double.mouseover (event) =>
      double.toFront()
      double.animate({scale: "1.07"}, 250, "bounce")

    double.mouseout (event) =>
      double.stop()
      double.animate({scale: "1"}, 250, "bounce")

  emitHit: (score) ->
    @board.emitScore(score)




class BoardSlice
  Sections: [
    [0.96, 0.88, 2], # double
    [0.88, 0.56, 1], # outer single
    [0.56, 0.48, 3], # triple
    [0.48, 0.10, 1]  # inner single
  ]

  SingleColors: ['#f5e1c3', '#040204']
  DoubleTripleColors: ['#60af75', '#bb2e36']

  constructor: (@value, @board) ->
    @slices = @board.paper.set()
    for section in this.Sections
      @slices.push(this.drawSection(section))
      @slices.push(this.drawNumber())
    this.color(0)

  rotate: (angle) ->
    @slices.rotate(angle, @board.originX, @board.originY)

  color: (idx) ->
    @slices[0].attr({fill: this.DoubleTripleColors[idx % 2]})
    @slices[2].attr({fill: this.SingleColors[idx % 2]})
    @slices[4].attr({fill: this.DoubleTripleColors[idx % 2]})
    @slices[6].attr({fill: this.SingleColors[idx % 2]})

  drawSection: (range) ->
    section = this.shapePath(range[0], range[1])
    section.attr({"stroke-width": 2, "stroke": "#999999"})
    section.click (event) =>
      this.emitHit(@value * range[2])
    section.mouseover (event) =>
      this.sectionHoverIn(section)
    section.mouseout (event) =>
      this.sectionHoverOut(section)

    section

  drawNumber: () ->
    set = @board.paper.set()
    circle = @board.paper.circle(@board.originX, 12, 10)
    circle.attr({fill: "#f5e1c3", stroke: "#f5e1c3"})
    set.push(circle)
    number = @board.paper.text(@board.originX, 12, @value)
    number.attr({"font-weight": "bold"})
    set.push(number)
    set

  sectionHoverIn: (section) ->
    section.toFront()
    section.animate({scale: "1.07"}, 250, "bounce")

  sectionHoverOut: (section) ->
    section.stop()
    section.animate({scale: "1"}, 250, "bounce")

  emitHit: (score) ->
    @board.emitScore(score)

  pointsFor: (factor) ->
    radius = @board.radius * factor
    lx = radius * Math.cos(Raphael.rad(261)) + @board.originX
    ly = radius * Math.sin(Raphael.rad(261)) + @board.originX
    rx = radius * Math.cos(Raphael.rad(279)) + @board.originX
    ry = radius * Math.sin(Raphael.rad(279)) + @board.originX

    {l: {x: lx, y: ly}, r: {x: rx, y: ry}, radius: radius}

  shapePath: (top_p, bottom_p) ->
    top = this.pointsFor(top_p)
    bottom = this.pointsFor(bottom_p)
    @board.paper.path("M #{bottom.l.x} #{bottom.l.y}L#{top.l.x} #{top.l.y}A #{top.radius} #{top.radius} 0 0 1 #{top.r.x} #{top.r.y}L #{bottom.r.x} #{bottom.r.y}A #{bottom.radius} #{bottom.radius} 0 0 0 #{bottom.l.x} #{bottom.l.y}")