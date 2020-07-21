Wrestling Gambling App

# Relationships
Tournament has_many Matches
Match belongs_to Tournament

Wrestler has_many Matches
Match belongs_to HomeWrestler
Match belongs_to AwayWrestler

Bet belongs_to Match
Bet belongs_to User
Bet.wrestler_type (HOME|AWAY)

# Entities
Wrestler
- Name
- College
- Image
- Bio

Match
- home_wrestler
- away_wrestler
- winner
- tournament_id
- index_id
- description

# July 25th
Kyle Dake vs Frank Chamizo 
Darrion "The Wolf" Caldwell vs Luke Pletcher
Jack Mueller vs Roman Bravo-Young 
Vito Arujau vs Sammy Alvarez
David Taylor vs Myles Martin

# For July 25th
## Pages
### Admin
#### Tournament Scaffold
#### Wrestler Scaffold
#### Match Scaffold
#### Bet Scaffold

### Public
#### Place Bets
All matches in tournament, clickable bets

#### Tournament Matchup View
Wrestler headshots with bets placed on each side
Leaderboard
Admin link to choose winner



rails generate scaffold Tournament name:string
rails generate scaffold Wrestler name:string college:string college_year:integer bio:text
rails generate scaffold Match weight:integer home_wrestler_id:integer away_wrestler_id:integer winner_id:integer tournament:references
rails generate scaffold Bet name:string user_id:integer references:match wager:string
