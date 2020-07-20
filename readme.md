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

## KD
Cornell '13
Birthday: February 25, 1991
2x World Champion
4x NCAA Champion

## Frank Chamizo
Birthday: 10 July 1992
2x World Champion, 1x Silver, 1x Bronze
Olympic Bronze Medalist

## Darrion Caldwell
Birthday: December 19, 1987
North Carolina State University '09
NCAA Champion
Current Bellator MMA Fighter

## Luke Pletcher
OSU '20
2x NCAA All-American
1st seed @ cancelled 2020 NCAAs
Coach @ University of Pittsburgh

## Jack Mueller
UVA '20
2x NCAA All American
4 seed @ cancelled 2020 NCAAs

## Roman Bravo Young
PSU '21
NCAA all american as a true freshman
5 seed @ cancelled 2020 NCAAs

## Vito Arujau
Cornell '23
33-4, 4th @ NCAA as true freshman
Redshirt 2020 season to train for Olympics

## Sammy Alvarez
Rutgers '24
10th seed @ cancelled 2020 NCAAs

## David Taylor
PSU '14
World Champion
2x NCAA champion, 2x runner-up

## Myles Martin
NCAA Champion
4x NCAA all-american
