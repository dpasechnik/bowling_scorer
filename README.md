# Bowling score api

Task description: 

```
Write a Ruby on Rails API that takes score of a bowling game.
You have the freedom to define the architecture of the API and how its endpoints will look.

Main Requirements:

The API should be written using Ruby on Rails. In addition, it should provide the following:

  ● A way to start a new bowling game;
  ● A way to input the number of pins knocked down by each ball;
  ● A way to output the current game score (score for each frame and total score).

Imagine that this API will be used by a bowling house. On the screen the user starts the game, then after each throw the machine, with a sensor, counts how many pins were dropped and calls the API sending this information. In the meantime the screen is constantly (for example: every 2 seconds) asking the API for the current game status and displays it.
Logic details

  ● Bowling is played by throwing a ball down a narrow alley toward ten wooden pins. The objective is to knock down as many pins as possible per throw.
  ● The game is played in ten frames. At the beginning of each frame, all ten pins are set up. The player then gets two tries to knock them all down.
  ● If the player knocks all the pins down on the first try, it is called a "strike,“ and the frame ends.
  ● If the player fails to knock down all the pins with his first ball, but succeeds with the second ball, it
    is called a "spare“.
  ● After the second ball of the frame, the frame ends even if there are still pins standing.
  ● A strike frame is scored by adding ten, plus the number of pins knocked down by the next two
    balls, to the score of the previous frame.
  ● A spare frame is scored by adding ten, plus the number of pins knocked down by the next ball, to
    the score of the previous frame.
  ● Otherwise, a frame is scored by adding the number of pins knocked down by the two balls in the
    frame to the score of the previous frame.
  ● If a strike is thrown in the tenth frame, then the player may throw two more balls to complete the
    score of the strike.
  ● Likewise, if a spare is thrown in the tenth frame, the player may throw one more ball to complete
    the score of the spare.
  ● Thus the tenth frame may have three balls instead of two.

For background information, please see http://en.wikipedia.org/wiki/Ten-pin_bowling
```

Implementation notes:

 - I've decided to stick with `sqlite` during development as i didn't utilize specific `postgres` features.
 - I think 'sanity checks' and high-level testing of edge cases is enough here so i didn't go through all cases. 
 - API documentation should be accessible only for development/staging environment, i've pretended that project is
   accessible only via local network. 
 
Setup:

```
rake db:create
rake db:migrate
rspec
rails s
```

API documentation:
    http://localhost:3000/index.html