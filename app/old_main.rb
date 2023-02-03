COLORS = { cool: ["indigo", "violet", "blue"], warm: ["yellow", "red", "orange"] }
SHAPE = ['circle', 'square', 'hexagon', 'triangle']

class Particle
  attr_accessor :x, :y, :radius, :color, :display, :history, :location

  def initialize(x:, y:, path:, theme: :cool)
    @theme = theme
    @x = x
    @y = y
    @path = path
    @shape = SHAPE[0]
    @radius = 2
    @color = @theme == :cool ? COLORS.cool[rand(3)] : COLORS.warm[rand(3)]
    @radians = rand() * Math::PI * 2
    @velocity = 0.05
    @distance = rand(120) + 50
    @angle = 0
    @history = []
    @location = {
      type: 'history',
      x: nil,
      y: nil
    }
  end

  def update(args)
    key_inputs(args)
    update_shape(args)
    update_variables(args)
    draw(args)
  end

  def update_variables(args)
    if @history.length > 40
      @history.delete_at(0)
    end

    @radians += @velocity
    @angle += 3
    @x = args.inputs.mouse.x + Math.cos(@radians) * @distance
    @y = args.inputs.mouse.y + Math.sin(@radians) * @distance

    @display = {x: args.inputs.mouse.x + Math.cos(@radians) * @distance, y: args.inputs.mouse.y + Math.sin(@radians) * @distance}
    @history << @display
    @history = @history[0..40]
  end

  def key_inputs(args)
    if args.inputs.keyboard.up
      @radius += 3
    elsif args.inputs.keyboard.down
      @radius += -3
    end

    if args.inputs.keyboard.left
      @distance += 3
    elsif args.inputs.keyboard.right
      @distance += -3
    end

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

  def update_shape(args)
    if args.inputs.keyboard.key_down.open_square_brace
      current_index = SHAPE.index(@shape)
      next_index = (current_index + 1) % SHAPE.length
      @shape = SHAPE[next_index]
    elsif args.inputs.keyboard.key_down.close_square_brace
      current_index = SHAPE.index(@shape)
      next_index = (current_index - 1) % SHAPE.length
      @shape = SHAPE[next_index]
    end
  end

  def draw(args)

    @history.each_with_index do |position, index|
      args.outputs.sprites << {x: position[:x], y: position[:y], w: @radius, h: @radius, path: "sprites/#{@shape}/#{@color}.png", angle: @angle, a: (80 * index) / @history.length}
    end
    args.outputs.sprites << {x: @x, y: @y, w: @radius, h: @radius, path: "sprites/#{@shape}/#{@color}.png", angle: @angle}
  end
end


def init_variables(args)
  args.state.particles ||= []
  args.state.path ||= 'sprites/circle/blue.png'

  50.times do
    particle = Particle.new(x: 640, y: 360, path: args.state.path, theme: :warm)
    args.state.particles.push(particle)
  end

  args.state.labels ||= [
    {x: 10, y: 700, text: "Left or Right: Changes distance", r: 255, g: 255, b: 255},
    {x: 10, y: 680, text: "Up or Down: Changes size", r: 255, g: 255, b: 255},
    {x: 10, y: 660, text: "Space: #{args.state.particles[0].location.type}", r: 255, g: 255, b: 255},
  ]
  args.state.background ||= {x: 0, y: 0, w: 1280, h: 720, a: 255, r: 50, g: 50, b: 50}

end

def play_update(args)
  args.state.rotation = args.tick_count % 360
  args.state.particles.each do |particle|
    particle.update(args)
  end
end

def play_render(args)
  args.outputs.sprites << args.state.background
  args.outputs.labels << args.state.labels.each
  args.outputs.sprites << {x: args.inputs.mouse.x, y: args.inputs.mouse.y, w: 2, h: 2, angle: args.state.rotation, r: 255, g: 255, b: 255}
end

def tick(args)
  if args.tick_count.zero?
    play ||= {
      state: :create,
    }
    args.state.play ||= play
  end

  case args.state.play.state
  when :create
    init_variables(args)
    args.gtk.hide_cursor
    args.state.rotation ||= 0
    args.state.play.state = :play
  when :play
    play_render(args)
    play_update(args)
  end
end
