SimpleCov.start do
  track_files "{app,lib}/**/*.rb"

  add_filter "/spec/"
  add_filter "/firesport/"
  add_filter "/firesport-series/"
  add_filter "/app/models/presets/"
end