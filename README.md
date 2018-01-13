# TrainBoard

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
  
## From Brian
### High Level Overview
The goal is to create a train board like you would see at north or south station in boston with the times, status, track, and destination of the trains. 

### Approach
- The page is all templates and generations (no JS front-end for the time being) 
- The core route is "/trains" (also the root) which takes a parameter `origin` which defaults to North Station
- Trains are served out of a postgres database, filtered by `origin`, and ordered by `scheduled_time`
- Train data is pulled from a file located on an MBTA server in csv format that is updated on some regular schedule. 
- I used a simple Genserver, to pull down the csv every 2 minutes, clear the database of existing trains, and load the new ones. (The CSV always includes the full set of trains)

### Future Enhancements
Better Error handling
- I'm not sure how error handling in elixir is supposed to be done, but I found that if the Genserver doing the periodic refresh went down it would continue restarting and retrying forever.
- At least handle the case where the CSV comes back empty. Maybe don't remove trains if there are no trains to be added? 

Don't reload the whole page when we change stations. Make a request to an api and return the data directly to the client.
 - This will avoid the page stutter as the re-render happens and feel smoother
 - Will require some javascript libraries

A better cache
- Postgres works fine for this application but a cache that only one process can write to and the rest can all read from would prevent us from hitting the database for every request and be more concurrent request friendly.
- This would be a little faster and not require a database on the server (I could use an erlang native :ets table or some Genserver implementation)
 
UI 
- Show lateness when a train is marked late
- Some kind of highlighting or UI treatment for trains that are arriving/ boarding 

Tests 
- I didn't spend any time exploring ExUnit here or how elixir handles tests but it would be nice to have. 

Web Sockets
- Phonenix really shines with websockets (at least compared to rails)
- I would like to treat trains as events that can be broadcast via websockets to all active clients and give real-ish time updates whenever there are changes
