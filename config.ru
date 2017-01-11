require './lib/racker'

use Rack::Reloader
use Rack::Session::Cookie, key: 'rack.session', path: '/',
                           secret: 'adfagdak1111bbakdaf22'
use Rack::Static, urls: ['/stylesheets', '/img', '/js'], root: 'public'

run Racker
