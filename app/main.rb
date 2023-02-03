require "app/classes.rb"
require "app/constants.rb"
require "app/render.rb"
require "app/tick.rb"

def init(args)
  # args.gtk.hide_cursor
  args.state.rotation ||= 0
  create_particles(args)
  create_labels(args)
  create_background(args)
end

def create_particles(args)
  size = 50
  theme = :cool
  shape = :circle

  args.state.particles ||= []

  size.times do
    particle = Particle.new(x: 640, y: 360, theme: :cool)
    args.state.particles.push(particle)
  end

end

def create_labels(args)
  args.state.labels ||= [
    {x: 10, y: 700, text: "Size: up or down",              r: 255, g: 255, b: 255},
    {x: 10, y: 680, text: "Distance: left or right",       r: 255, g: 255, b: 255},
    {x: 10, y: 660, text: "Speed: left mouse",             r: 255, g: 255, b: 255},
    {x: 10, y: 640, text: "Revese: right mouse",           r: 255, g: 255, b: 255},
    {x: 10, y: 620, text: "Shape: press v",                r: 255, g: 255, b: 255},
    {x: 10, y: 600, text: "Position: press b (for lines)", r: 255, g: 255, b: 255},
    {x: 10, y: 580, text: "Color: press c",                r: 255, g: 255, b: 255},
  ]
end

def create_background(args)
  args.state.background ||= {x: 0, y: 0, w: 1280, h: 720, a: 255, r: 50, g: 50, b: 50}
end

# def create_settings(args)
#   args.state.settings ||= {}
#   # to do
#   # at start up create a window
#   # window gives settings to set the game up
#   # settings:
#   # shape, theme, size
#   settings_items(args)
#   settings_inputs(args)
#   settings_sandbox(args)
# end

# def settings_items(args)
#   args.state.settings.labels = [
#     {x: 1280/3, y: 720/2 + 10, text: "Pick a shape: ",  r: 255, g: 255, b: 255},
#     {x: 1280/3, y: 720/2, text: "Pick a theme: ",              r: 255, g: 255, b: 255}
#     {x: 1280/3, y: 720/2 - 10, text: "How many particles: ",              r: 255, g: 255, b: 255}
#   ]
#   args.state.settings.background = {
#     x: 1280/2, y: 720/2, w: 400, h: 200, path: :pixel, r: 40, g: 40, b: 40
#   }

#   args.state.settings.shapes = [
#     {x: 1280/2, y: 720/2 + 10, path: args.state.settings.path,  r: 255, g: 255, b: 255},
#     {x: 1280/2, y: 720/2 + 10, path: args.state.settings.path,  r: 255, g: 255, b: 255},
#     {x: 1280/2, y: 720/2 + 10, path: args.state.settings.path,  r: 255, g: 255, b: 255}
#   ]
# end
