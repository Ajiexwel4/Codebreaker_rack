require './lib/racker'

use Rack::Reloader
use Rack::Static, :urls => ['/stylesheets'], :root => 'public'

run Racker
