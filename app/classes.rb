class Particle
  attr_accessor :position, :radius, :radians, :trail, :location, :shape, :rgb

  def initialize (x:, y:, theme: :cool)
    @position = {x: x, y: y}
    @theme = theme
    @radius = 10
    initial_variables()
  end

  def initial_variables()
    @angle = 0
    @radius = 7
    @velocity = 0.05
    @distance = rand(120) + 50
    @radians = rand() * Math::PI * 2

    @rgb = {red: 0, green: 0, blue: 0}
    @trail = []
    @shape = SHAPES[0]
    @location = { type: :self, x: nil, y: nil }
    @color = @theme == :cool ? COLORS.cool[rand(3)] : COLORS.warm[rand(3)]

    @path = "sprites/#{@shapes}/#{@color}.png"
  end

  def update(args)
    state(args)
    draw(args)
  end

  private

  def state(args)
    trails(args)
    size(args)
    space(args)
    shapes(args)
    speed(args)
    colors(args)
    sprite(args)
    positions(args)
    variables(args)
  end

  def size(args)
    if @shape != :lines
      if args.inputs.keyboard.up
        @radius += 3
      elsif args.inputs.keyboard.down
        @radius += -3
      end
    end
  end

  def space(args)
    if args.inputs.keyboard.left
      @distance += 3
    elsif args.inputs.keyboard.right
      @distance += -3
    end
  end

  def shapes(args)
    if args.inputs.keyboard.key_down.v
      current_index = SHAPES.index(@shape)
      next_index = (current_index + 1) % SHAPES.length
      @shape = SHAPES[next_index]
    end
  end

  def speed(args)
    if args.inputs.mouse.button_right
      @reverse = true
    else
      @reverse = false
    end

    if args.inputs.mouse.button_left
      if @reverse
        @velocity += -0.008
      else
        @velocity += 0.008
      end
    else
      if @reverse
        @velocity = -0.008
      else
        @velocity = 0.008
      end
    end
  end

  def colors(args)
    if args.inputs.keyboard.key_down.c
      @theme = @theme == :cool ? :warm : :cool
      @color = @theme == :cool ? COLORS.cool[rand(3)] : COLORS.warm[rand(3)]
    end
    coloring()
  end

  def sprite(args)
    @path = "sprites/#{@shapes}/#{@color}.png"
  end

  def positions(args)
    if args.inputs.keyboard.key_down.b
      current_index = LOCATIONS.index(@location.type)
      next_index = (current_index + 1) % LOCATIONS.length
      @location.type = LOCATIONS[next_index]

      case @location.type
      when :top_left
        @location.x = 10
        @location.y = 710
      when :top_right
        @location.x = 1270
        @location.y = 710
      when :bottom_left
        @location.x = 10
        @location.y = 10
      when :bottom_right
        @location.x = 1270
        @location.y = 10
      when :self
        @location.x = 0
        @location.y = 0
      end
    end
  end

  def variables(args)
    @radians += @velocity
    @angle += 3
    @x = args.inputs.mouse.x + Math.cos(@radians) * @distance
    @y = args.inputs.mouse.y + Math.sin(@radians) * @distance
  end

  def trails(args)
    if @trail.length > 30
      @trail.delete_at(0)
    end

    @display = {
      x: args.inputs.mouse.x + Math.cos(@radians) * @distance,
      y: args.inputs.mouse.y + Math.sin(@radians) * @distance
    }
    @trail << @display
    @trail = @trail[0..30]
  end

  def coloring()
    case @color
    when "indigo"
      @rgb.red, @rgb.green, @rgb.blue = [75, 0, 130]
    when "violet"
      @rgb.red, @rgb.green, @rgb.blue = [238, 130, 238]
    when "blue"
      @rgb.red, @rgb.green, @rgb.blue = [0, 0, 255]
    when "yellow"
      @rgb.red, @rgb.green, @rgb.blue = [255, 255, 0]
    when "red"
      @rgb.red, @rgb.green, @rgb.blue = [255, 0, 0]
    when "orange"
      @rgb.red, @rgb.green, @rgb.blue = [255, 165, 0]
    end

  end

  def draw(args)
    if @shape == :lines
      draw_lines(args)
    else
      draw_shapes(args)
    end
  end

  def draw_shapes(args)
    @trail.each_with_index do |position, index|
      args.outputs.sprites << {x: position[:x], y: position[:y], w: @radius, h: @radius, path: "sprites/#{@shape}/#{@color}.png", angle: @angle, a: (80 * index) / @trail.length}
    end
    args.outputs.sprites << {x: @x, y: @y, w: @radius, h: @radius, path: "sprites/#{@shape}/#{@color}.png", angle: @angle}
  end

  def draw_lines(args)
    if @location.type == :self
      @trail.each_with_index do |current, index|
        next_position = @trail[-(index + 2)] || @display
        args.outputs.lines << {x: next_position[:x], y: next_position[:y], x2: current[:x], y2: current[:y], a: (80 * index) / @trail.length, r: @rgb[:red], g: @rgb[:green], b: @rgb[:blue]}
      end
    else
      @trail.each_with_index do |current, index|
        args.outputs.lines << {x: current[:x], y: current[:y], x2: @location[:x], y2: @location[:y], path: :pixel, a: (80 * index) / @trail.length, r: @rgb.red, g: @rgb.green, b: @rgb.blue}
      end
    end

    args.outputs.sprites << {x: @x, y: @y, w: 1, h: 1, path: :pixel, r: @rgb.red, g:@rgb.green, b: @rgb.blue}
  end

end
