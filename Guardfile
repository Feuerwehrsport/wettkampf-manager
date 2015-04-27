# A sample Guardfile
# More info at https://github.com/guard/guard#readme

## Uncomment and set this to only include directories you want to watch
# directories %w(app lib config test spec features)

## Uncomment to clear the screen before every task
# clearing :on

## Guard internally checks for changes in the Guardfile and exits.
## If you want Guard to automatically start up again, run guard in a
## shell loop, e.g.:
##
##  $ while bundle exec guard; do echo "Restarting Guard..."; done
##
## Note: if you are using the `directories` clause above and you are not
## watching the project directory ('.'), then you will want to move
## the Guardfile to a watched dir and symlink it back, e.g.
#
#  $ mkdir config
#  $ mv Guardfile config/
#  $ ln -s config/Guardfile .
#
# and, you'll have to watch "config/Guardfile" instead of "Guardfile"


# More info at https://github.com/guard/guard#readme

guard 'rspec', cmd: 'bin/rspec', run_all: { cli: '--tag ~slow' }, failed_mode: :none do
  watch(%r{^spec/factories/.+\.rb$})                  { |m| "spec/factories_spec.rb" }
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/(.*)(\.erb|\.haml)$})                 { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb" }
  watch('app/controllers/application_controller.rb')  { "spec/controllers" }
  watch(%r{^app/views/(.+)/_.*\.(erb|haml)$})         { |m| "spec/views/#{m[1]}/" }
  watch(%r{^app/views/(.+_mailer)/.*\.(erb|haml)$})   { |m| "spec/mailers/#{m[1]}_spec.rb" }
  watch(%r{^lib/(.+)\.rb$})                           { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('app/helpers/labeled_form_helper.rb')         { "spec/views/admin/maps/" }
  watch('app/views/admin/brandings/_modal_form.html.haml') { "spec/views/admin/maps/" }
  watch('lib/crud_actions.rb') { "spec/controllers/admin/users_controller_spec.rb" }
  watch('config/locales/de_lokalsichtbar.yml') { "spec/lib/de_lokalsichtbar_spec.rb" }
  watch('config/locales/de_milabent.yml') { "spec/lib/de_milabent_spec.rb" }
  watch('config/routes.rb') { "spec/routing/domain_routing_spec.rb" }
end

puts ""
puts "Usage"
puts "============================================================================"
puts "  > Save a file to trigger spec watchers."
puts "  > Press Enter to run fast specs."
puts "  > Type `all rspec` to run all specs, including integration tests."
puts "  > Type `p` to pause Guard."
puts "  > Type `r` to reload Guard."
puts ""
