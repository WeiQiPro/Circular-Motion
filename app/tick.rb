def tick (args)
  if args.tick_count.zero?
    init(args)
  end
  
  render_background(args)
  render_labels(args)
  render_mouse(args)
  render_particles(args)

end
