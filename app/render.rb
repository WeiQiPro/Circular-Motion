def render_labels (args)
  args.outputs.labels << args.state.labels
end

def render_background (args)
  args.outputs.sprites << args.state.background
end

def render_mouse (args)
  args.outputs.sprites << {x: args.inputs.mouse.x, y: args.inputs.mouse.y, w: 2, h: 2, angle: args.state.rotation, r: 255, g: 255, b: 255}
end

def render_particles (args)
  args.state.particles.each do |particle|
    particle.update(args)
  end
end
